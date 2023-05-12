//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import Foundation

/*
 Scenario:
 1. User selects 2 items for section 0
 2. User switches to section 1
 3. <ItemsLoader> loads items for section 1
 4. Mapping data to <ItemsContainer>
 5. User switches to section 0 again
 6. <ItemsLoader> loads items for section 0 OR load cached data
 7. Mapping data to <ItemsContainer> THIS ALWAYS HAPPENS IN THE CURRENT DESIGN
  
 So we might loose the user's previously selected items, this entity is here to prevent it
 Even if <ItemsLoader> caches items, mapping data to <ItemsContainer> happens, so this is mandatory to keep user's selected items.
 */

final class InMemorySelectionManager<Container: ItemsContainer> {
    private(set) public var loadedContainers = [Int: Container]()
    
    init() {}

    func sync(container: Container, forSection section: Int) {
        loadedContainers[section]?.selectedItems?.forEach({ item in
            if let index = container.items.firstIndex(of: item) {
                container.select(at: index)
            }
        })
        loadedContainers[section] = container
    }
}
