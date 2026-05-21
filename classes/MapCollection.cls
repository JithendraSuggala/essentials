/**
 * Demonstrates common Map operations in Apex:
 *  - Creating, populating maps
 *  - Cloning (shallow) and deepClone (for SObject graphs)
 *  - Membership & access: containsKey, get, remove
 *  - Bulk ops: putAll(Map), putAll(List<SObject>), constructor from List<SObject>
 *  - Size, emptiness, clear
 *  - Equality (equals)
 *  - Iterating keys/values, sorting via keySet().sort()
 *  - Utility patterns: merge, invert (value→key), key union/intersection/difference
 *  - SObject-specific: building Map<Id, SObject>, getSObjectType()
 */
public class MapCollection {

    /**
     * Walks through typical Map<String, Decimal> operations and logs outcomes.
     * Mirrors your List/Set demo flow but tailored to Map.
     */
    public static void MapMethod() {
        // Create a Map of gadget → price
        Map<String, Decimal> gadgetPrices = new Map<String, Decimal>();
        gadgetPrices.put('Phone', 699.00);
        gadgetPrices.put('Laptop', 1399.00);
        gadgetPrices.put('Camera', 899.00);
        gadgetPrices.put('Drone', 1299.00);
        gadgetPrices.put('Selfie Stand', 49.00);
        gadgetPrices.put('Watch', 349.00);
        System.debug('gadgetPrices: ' + gadgetPrices);

        // Overwrite behavior: put on the same key replaces the value
        gadgetPrices.put('Watch', 329.00); // price changed
        System.debug('After overwrite put("Watch", 329.00): ' + gadgetPrices);

        // putAll from another Map (union / overwrite existing keys)
        Map<String, Decimal> promoPrices = new Map<String, Decimal>{
            'Tripod' => 79.00,
            'Camera' => 849.00 // overwrites Camera
        };
        gadgetPrices.putAll(promoPrices);
        System.debug('After putAll(promoPrices): ' + gadgetPrices);

        // Access & membership checks
        Boolean hasDrone = gadgetPrices.containsKey('Drone');
        Decimal dronePrice = gadgetPrices.get('Drone'); // returns null if key missing
        System.debug('containsKey("Drone")=' + hasDrone + ', get("Drone")=' + dronePrice);

        // remove returns the removed value (or null if absent)
        Decimal removed = gadgetPrices.remove('Selfie Stand');
        System.debug('remove("Selfie Stand") returned: ' + removed + ', map now: ' + gadgetPrices);

        // Size and emptiness
        Integer count = gadgetPrices.size();
        Boolean empty = gadgetPrices.isEmpty();
        System.debug('size=' + count + ', isEmpty=' + empty);

        // Clone: shallow copy (safe for primitives; for SObjects consider deepClone)
        Map<String, Decimal> cloned = gadgetPrices.clone();
        System.debug('Cloned (shallow) map: ' + cloned);

        // equals: true if both maps have identical key/value pairs
        Boolean same = gadgetPrices.equals(cloned);
        System.debug('gadgetPrices.equals(cloned)? ' + same);

        // Iterate keys & values
        for (String k : gadgetPrices.keySet()) {
            System.debug('Key iteration → ' + k + ' = ' + gadgetPrices.get(k));
        }
        for (Decimal v : gadgetPrices.values()) {
            System.debug('Value iteration → ' + v);
        }

        // Produce a sorted view by key (Maps are unordered by nature)
        List<String> sortedKeys = new List<String>(gadgetPrices.keySet());
        sortedKeys.sort(); // alphabetical
        List<String> sortedPairs = new List<String>();
        for (String k : sortedKeys) {
            sortedPairs.add(k + '=' + String.valueOf(gadgetPrices.get(k)));
        }
        System.debug('Sorted (by key) pairs: ' + sortedPairs);

        // Clear
        Map<String, Decimal> temp = gadgetPrices.clone();
        temp.clear();
        System.debug('After clear(): temp=' + temp + ', isEmpty=' + temp.isEmpty());
    }

    // ---------------------------
    // Utility helpers (practical)
    // ---------------------------

    /**
     * Returns a NEW Map containing all entries from a and then b (b overwrites on conflicts).
     */
    public static Map<String, Decimal> mergeMaps(Map<String, Decimal> a, Map<String, Decimal> b) {
        Map<String, Decimal> out = (a == null) ? new Map<String, Decimal>() : a.clone();
        if (b != null) out.putAll(b);
        return out;
    }

    /**
     * Inverts a Map<String, String> to Map<String, String> (value → key).
     * If duplicate values exist, the later key wins (last-write-wins).
     */
    public static Map<String, String> invert(Map<String, String> input) {
        Map<String, String> result = new Map<String, String>();
        if (input == null) return result;
        for (String k : input.keySet()) {
            String v = input.get(k);
            // Null values are allowed but cannot be keys after inversion—guard accordingly.
            if (v != null) result.put(v, k);
        }
        return result;
    }

    /**
     * Returns keys present in both maps (intersection of key sets).
     */
    public static Set<String> keyIntersection(Map<String, Object> a, Map<String, Object> b) {
        if (a == null || b == null) return new Set<String>();
        Set<String> s = new Set<String>(a.keySet());
        s.retainAll(b.keySet());
        return s;
    }

    /**
     * Returns keys present in a but not in b (difference of key sets).
     */
    public static Set<String> keyDifference(Map<String, Object> a, Map<String, Object> b) {
        if (a == null) return new Set<String>();
        Set<String> s = new Set<String>(a.keySet());
        if (b != null) s.removeAll(b.keySet());
        return s;
    }

    /**
     * Returns union of keys from both maps.
     */
    public static Set<String> keyUnion(Map<String, Object> a, Map<String, Object> b) {
        Set<String> s = (a == null) ? new Set<String>() : new Set<String>(a.keySet());
        if (b != null) s.addAll(b.keySet());
        return s;
    }

    /**
     * Returns a sorted list of "key=value" pairs (sorted by key ASC).
     */
    public static List<String> toSortedPairs(Map<String, Object> input) {
        List<String> output = new List<String>();
        if (input == null) return output;
        List<String> keys = new List<String>(input.keySet());
        keys.sort();
        for (String k : keys) {
            output.add(k + '=' + String.valueOf(input.get(k)));
        }
        return output;
    }

    // -----------------------------------
    // SObject-flavored Map demonstrations
    // -----------------------------------

    /**
     * Builds a Map<Id, Account> directly from a SOQL list using a Map constructor,
     * and showcases getSObjectType(), clone(), deepClone(), size(), isEmpty(), remove(), equals().
     *
     * Note: Requires Accounts to exist in your org. Safe to run in an org with data.
     */
    public static void SObjectMapDemo() {
        // Typical SOQL (Ids guaranteed to be populated)
        List<Account> accs = [SELECT Id, Name, Industry FROM Account LIMIT 5];

        // 1) Construct from List<SObject>
        Map<Id, Account> accountMap = new Map<Id, Account>(accs);
        System.debug('accountMap (from constructor): ' + accountMap);

        // 2) Alternative: start empty and use putAll(list<SObject>)
        Map<Id, Account> accountMap2 = new Map<Id, Account>();
        accountMap2.putAll(accs);
        System.debug('accountMap2 (via putAll(list)): ' + accountMap2);

        // getSObjectType (only for Map<Id, SObject>)
        Schema.SObjectType token = accountMap.getSObjectType();
        System.debug('SObject type token from accountMap: ' + token);

        // Access by Id (use any Id from keySet)
        if (!accountMap.isEmpty()) {
            Id someId = new List<Id>(accountMap.keySet())[0];
            Account a = accountMap.get(someId);
            System.debug('Fetched account by Id: ' + a);
        }

        // Remove one key, compare maps
        if (!accountMap.isEmpty()) {
            Id idToRemove = new List<Id>(accountMap.keySet())[0];
            Account removed = accountMap.remove(idToRemove);
            System.debug('Removed ' + idToRemove + ' → ' + removed);
        }

        // Shallow clone vs deepClone:
        Map<Id, Account> shallow = accountMap.clone(); // shares SObject references
        Map<Id, Account> deep = accountMap.deepClone();
        System.debug('Shallow clone size=' + shallow.size() + ', Deep clone size=' + deep.size());

        Boolean mapsEqual = accountMap.equals(accountMap2); // order-agnostic equality by key+value refs
        System.debug('accountMap.equals(accountMap2)? ' + mapsEqual);
    }

    // -----------------------------------
    // Small applied examples
    // -----------------------------------

    /**
     * Counts occurrences of each first-letter among given gadget names.
     * Example of Map<String, Integer> accumulation pattern.
     */
    public static Map<String, Integer> countByFirstLetter(List<String> items) {
        Map<String, Integer> counts = new Map<String, Integer>();
        if (items == null) return counts;
        for (String s : items) {
            if (String.isBlank(s)) continue;
            String k = s.substring(0, 1).toUpperCase();
            Integer c = counts.containsKey(k) ? counts.get(k) + 1 : 1;
            counts.put(k, c);
        }
        return counts;
    }

    /**
     * Normalizes String keys to lower-case and merges duplicate keys.
     * Demonstrates case-sensitivity handling for String keys.
     */
    public static Map<String, Integer> normalizeAndMergeCase(Map<String, Integer> input) {
        Map<String, Integer> out = new Map<String, Integer>();
        if (input == null) return out;
        for (String k : input.keySet()) {
            String lower = (k == null) ? null : k.toLowerCase();
            if (lower == null) continue; // null keys not allowed in Maps
            Integer existing = out.containsKey(lower) ? out.get(lower) : 0;
            out.put(lower, existing + (input.get(k) == null ? 0 : input.get(k)));
        }
        return out;
    }
}
/*** ANONYMOUS WINDOW CODE
 Map<String,String>input = new Map<String,String>{'AP'=>'Amaravathi','TG'=>'Hyderabad'};
input.put('Karnataka','Bengaluru');
input.put('West Bengal','Kolkata');
input.put('Karnataka','KGF');
Map<String,String>output = MapCollection.invert(input);
system.debug('Invert method output'+output);

MapCollection.MapMethod();

List<String> strList = new List<String>{'Camera\'man', 'cDrone','Laptop', 'Phone', 'Tripod', 'Watch'};
Map<String,Integer> counterMap =MapCollection.countByFirstLetter(strList);    
system.debug('counter Map =>'+counterMap);

Map<String,Integer>input = new Map<String,integer>{'AP'=>1,'TG'=>2};
input.put('Karnataka',3);
input.put('West Bengal',4);
input.put('Karnataka',5);
Map<String,Integer>output = MapCollection.normalizeAndMergeCase(input);
system.debug('Invert method output'+output);
 */