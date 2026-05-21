/**
 * Demonstrates common List operations in Apex:
 *  - Creating and populating lists
 *  - Cloning lists to avoid mutating originals
 *  - Sorting, clearing, containment checks, equality checks
 *  - Accessing, updating, removing items by index
 *  - Comparing lists by content irrespective of order using Sets
 */
public class ListCollection {

    /**
     * Walks through typical List<String> operations and logs the outcomes.
     * This method is intended for learning and demonstration purposes.
     */
    public static void Listmethod() {
        // Create a list with one initial gadget: "Phone"
        List<String> onBoardingGadgets = new List<String>{'Phone'};
        
        // Add additional items to the list
        onBoardingGadgets.add('Laptop');
        onBoardingGadgets.add('Camera');
        onBoardingGadgets.add('Drone');
        onBoardingGadgets.add('Selfie Stand');
        onBoardingGadgets.add('Watch');
        System.debug('onBoardingGadgets List Contains: ' + onBoardingGadgets);
        
        // Create a new list by copying values from onBoardingGadgets (shallow copy)
        // Note: For List<String> a shallow copy is sufficient (Strings are immutable)
        List<String> employeeGadgets = new List<String>(onBoardingGadgets);
        System.debug('EmployeeGadgets List Contains: ' + employeeGadgets);
        
        // Clear removes all elements from employeeGadgets
        employeeGadgets.clear();
        System.debug('EmployeeGadgets List After clear(): ' + employeeGadgets);
        
        // Clone the list so that subsequent sorting does NOT affect the original list
        // (clone() returns a new List instance with the same elements)
        List<String> sortedGadgets = onBoardingGadgets.clone();
        
        // Sort the cloned list alphabetically (in-place ascending sort)
        sortedGadgets.sort();
        
        System.debug('Original onBoardingGadgets (Unsorted): ' + onBoardingGadgets);
        System.debug('SortedGadgets List Contains: ' + sortedGadgets);
        
        // Check whether the list contains a specific item: "Watch"
        Boolean doesWatchExist = onBoardingGadgets.contains('Watch');
        System.debug('Is "Watch" present in the list? ' + doesWatchExist);
        
        // Check if two lists are exactly equal (size and order must match)
        // Note: This will typically be false because sortedGadgets is sorted while the original is not
        Boolean areTwoListsSame = sortedGadgets.equals(onBoardingGadgets);
        System.debug('Are SortedGadgets and onBoardingGadgets exactly equal? ' + areTwoListsSame);
        
        // Get the first gadget by index (0-based indexing)
        // Caution: Always ensure the list is non-empty before using get(0) in real code
        String firstGadget = onBoardingGadgets.get(0);
        System.debug('First Gadget in onBoardingGadgets list is ' + firstGadget);
        
        // Check if the list is empty
        Boolean isTheListEmpty = onBoardingGadgets.isEmpty();
        System.debug('Is onBoardingGadgets list empty? ' + isTheListEmpty);
        
        // Remove the element at index 3 and capture the removed value
        // Current list (before removal) has at least 5 items; index 3 is safe here.
        // In production code, validate index bounds to avoid ListException.
        String removedGadget = onBoardingGadgets.remove(3);
        System.debug('This gadget was removed from the list: ' + removedGadget);
        
        // Replace the element now at index 3 with 'Headset'
        // Note: After removal, the list has shifted; index 3 refers to the original index 4.
        onBoardingGadgets.set(3, 'Headset');
        System.debug('Updated onBoardingGadgets contains: ' + onBoardingGadgets);
        
        // Get the size (number of elements) of the list
        Integer onBoardingGadgetsListSize = onBoardingGadgets.size();
        System.debug('Size of onBoardingGadgets List: ' + onBoardingGadgetsListSize);
        
        // Sort again using a fresh clone so the original remains unsorted
        List<String> clonedList = onBoardingGadgets.clone();
        clonedList.sort();
        System.debug('Sorted onBoardingGadgets (cloned) List: ' + clonedList);
    }
    
    /**
     * Compares two lists for having the same elements regardless of order.
     * Implementation detail:
     *  - Clones and sorts the original list (for demonstration)
     *  - Converts both lists to Sets to ignore order (and duplicates)
     *  - Uses Set.equals to check content equality
     *
     * @return true if both lists contain the same unique elements; false otherwise
     */
    public static Boolean listContainsSameElements() {
        // Create and populate a baseline list
        List<String> onBoardingGadgets = new List<String>{'Phone'};
        onBoardingGadgets.add('Laptop');
        onBoardingGadgets.add('Camera');
        onBoardingGadgets.add('Drone');
        onBoardingGadgets.add('Selfie Stand');
        onBoardingGadgets.add('Watch');
        System.debug('onBoardingGadgets List Contains: ' + onBoardingGadgets);
        
        // Clone the list and sort it
        List<String> sortedList = onBoardingGadgets.clone();
        sortedList.sort();
        
        /*
         * By converting both lists to Sets, we remove the significance of ordering.
         * Set.equals() returns true only if both sets contain exactly the same members.
         * Note: Using Sets also collapses duplicates—if duplicate handling matters,
         * consider comparing via Maps of element -> count instead.
         */
        return new Set<String>(onBoardingGadgets)
            .equals(new Set<String>(sortedList));
    }
}