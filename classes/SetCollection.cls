/**
 * Demonstrates common Set operations in Apex:
 *  - Creating and populating sets
 *  - Cloning and clearing
 *  - Membership checks (contains / containsAll)
 *  - Equality checks (order-agnostic)
 *  - Removing, bulk removing, retaining (difference/intersection)
 *  - Union (addAll), size, emptiness
 *  - Converting to List for sorting or indexed access
 *  - Iterating with for-each and Iterator
 */
public class SetCollection {

    /**
     * Walks through typical Set<String> operations and logs outcomes.
     * Mirrors the "Listmethod" style, but for Set.
     */
    public static void SetMethod() {
        // Create a Set with one initial gadget: "Phone"
        Set<String> onboardingGadgets = new Set<String>{'Phone'};

        // Add items: duplicates are ignored silently in a Set
        onboardingGadgets.add('Laptop');
        onboardingGadgets.add('Camera');
        onboardingGadgets.add('Drone');
        onboardingGadgets.add('Selfie Stand');
        onboardingGadgets.add('Watch');
        
        onboardingGadgets.add('Watch'); // duplicate ignored
        System.debug('onboardingGadgets Set Contains: ' + onboardingGadgets);

        // addAll: union operation; duplicates suppressed automatically
        Set<String> extraGadgets = new Set<String>{'Tripod', 'Microphone', 'Camera'};
        onboardingGadgets.addAll(extraGadgets);
        System.debug('After addAll(extraGadgets) → onboardingGadgets: ' + onboardingGadgets);

        // Clone returns a shallow copy (sufficient for Strings)
        Set<String> employeeGadgets = onboardingGadgets.clone();
        System.debug('Cloned employeeGadgets: ' + employeeGadgets);

        // contains / containsAll
        Boolean hasWatch = onboardingGadgets.contains('Watch');
        Boolean hasAllItems = onboardingGadgets.containsAll(new Set<String>{'Phone', 'Laptop'});
        System.debug('Does onboardingGadgets contain "Watch"? ' + hasWatch);
        System.debug('Does onboardingGadgets contain Phone & Laptop? ' + hasAllItems);

        // equals: true only if both sets have the exact same members (order is irrelevant)
        Boolean sameSets = onboardingGadgets.equals(employeeGadgets);
        System.debug('Are onboardingGadgets and employeeGadgets equal? ' + sameSets);

        // isEmpty and size
        Boolean isEmpty = onboardingGadgets.isEmpty();
        Integer size = onboardingGadgets.size();
        System.debug('Is onboardingGadgets empty? ' + isEmpty);
        System.debug('Size of onboardingGadgets: ' + size);

        // remove: removes a single element (no-op if not found)
        Boolean removed = onboardingGadgets.remove('Drone');
        System.debug('Attempted remove("Drone") → removed? ' + removed + ', Current Set: ' + onboardingGadgets);

        // removeAll: set difference (onboardingGadgets = onboardingGadgets - toRemove)
        Set<String> toRemove = new Set<String>{'Selfie Stand', 'NonExistent', 'Tripod'};
        onboardingGadgets.removeAll(toRemove);
        System.debug('After removeAll(Selfie Stand, NonExistent, Tripod): ' + onboardingGadgets);

        // retainAll: set intersection (keep only items present in the given set)
        Set<String> favorites = new Set<String>{'Phone', 'Laptop', 'Watch', 'VR Headset'};
        Set<String> intersectionDemo = onboardingGadgets.clone();
        intersectionDemo.retainAll(favorites);
        System.debug('Intersection with favorites via retainAll: ' + intersectionDemo);

        // Union example (using addAll) without mutating original
        Set<String> unionDemo = onboardingGadgets.clone();
        unionDemo.addAll(favorites);
        System.debug('Union (onboarding ∪ favorites) via addAll: ' + unionDemo);

        // Difference example: (favorites - onboardingGadgets)
        Set<String> differenceDemo = favorites.clone();
        differenceDemo.removeAll(onboardingGadgets);
        System.debug('Difference (favorites - onboarding): ' + differenceDemo);

        // Convert to List for sorting or indexed operations
        List<String> sortedGadgets = new List<String>(onboardingGadgets);
        sortedGadgets.sort(); // allowed on List
        System.debug('Sorted view of onboardingGadgets (via toList + sort): ' + sortedGadgets);

        // Iterate using for-each
        for (String g : onboardingGadgets) {
            // Do something with g; here we just output a normalized name
            System.debug('Iterating gadget (for-each): ' + g);
        }

        // Iterate using explicit Iterator
        Iterator<String> it = onboardingGadgets.iterator();
        while (it.hasNext()) {
            String item = it.next();
            System.debug('Iterating gadget (Iterator): ' + item);
        }

        // clear: remove all elements
        employeeGadgets.clear();
        System.debug('employeeGadgets after clear(): ' + employeeGadgets + ' | isEmpty=' + employeeGadgets.isEmpty());
    }

    /**
     * Returns a sorted List<String> containing all elements from the given Set.
     * Useful when a stable order or index-based access is required.
     */
    public static List<String> toSortedList(Set<String> input) {
        if (input == null) return new List<String>();
        List<String> result = new List<String>(input);
        result.sort();
        return result;
    }

    /**
     * Checks if two sets contain exactly the same elements (order-agnostic).
     * Equivalent to set.equals(other).
     */
    public static Boolean setsAreEqual(Set<String> a, Set<String> b) {
        if (a == null && b == null) return true;
        if (a == null || b == null) return false;
        return a.equals(b);
    }

    /**
     * Returns the union of two sets without mutating inputs.
     * union(A, B) = A ∪ B
     */
    public static Set<String> union(Set<String> a, Set<String> b) {
        Set<String> u = (a == null) ? new Set<String>() : a.clone();
        if (b != null) u.addAll(b);
        return u;
    }

    /**
     * Returns the intersection of two sets without mutating inputs.
     * intersection(A, B) = A ∩ B
     */
    public static Set<String> intersection(Set<String> a, Set<String> b) {
        if (a == null || b == null) return new Set<String>();
        Set<String> i = a.clone();
        i.retainAll(b);
        return i;
    }

    /**
     * Returns the difference of two sets without mutating inputs.
     * difference(A, B) = A - B
     */
    public static Set<String> difference(Set<String> a, Set<String> b) {
        if (a == null) return new Set<String>();
        Set<String> d = a.clone();
        if (b != null) d.removeAll(b);
        return d;
    }

    /**
     * Demo method to show containsAll behavior with duplicates:
     * Note: Since Set collapses duplicates, containsAll considers unique membership only.
     */
    public static Boolean demoContainsAllBehavior() {
        Set<String> base = new Set<String>{'A', 'B', 'C'};
        // The presence of duplicates in the "probe" collection is irrelevant for Sets.
        Set<String> probe = new Set<String>{'A', 'A', 'B'};
        return base.containsAll(probe); // true because A and B are present in base
    }
}