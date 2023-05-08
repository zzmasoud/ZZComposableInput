//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import XCTest
import ZZComposableInput

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

class InMemorySelectionManager<Container: ItemsContainer> {
    var loadedContainers = [Int: Container]()

    func sync(container: Container, forSection section: Int) {
        loadedContainers[section]?.selectedItems?.forEach({ item in
            if let index = container.items!.firstIndex(of: item) {
                container.select(at: index)
            }
        })
        loadedContainers[section] = container
    }
}


final class InMemorySelectionManagerTests: XCTestCase {
    
    func test_init_containersAreEmpty() {
        let sut = makeSUT()
        
        XCTAssertTrue(sut.loadedContainers.isEmpty)
    }
    
    func test_add_insertsContainerIfNotExist() {
        let container = makeContainer()
        let sut = makeSUT()

        sut.sync(container: container, forSection: 1)
        
        XCTAssertEqual(sut.loadedContainers.count, 1)
        XCTAssertIdentical(sut.loadedContainers[1], container)
    }
    
    func test_add_syncSelectedItemsWithNewlyAddedContainer() throws {
        let items = makeItems()
        let containerBefore = makeContainer(withItems: items)
        // make a selection before passing to SUT
        containerBefore.select(at: 0)
        let sut = makeSUT()
        
        sut.sync(container: containerBefore, forSection: 0)
        // make a selection after passing to SUT (on the same object)
        containerBefore.select(at: 1)
        
        let newContainer = makeContainer(withItems: Array(items[1...4]))
        sut.sync(container: newContainer, forSection: 0)
        
        // expect SUT to sync previously selected items with the new container (because of the same section)
        let selectedItems = try XCTUnwrap(newContainer.selectedItems)
        XCTAssertEqual(selectedItems, [items[1]])
    }
    
    func test_add_syncSelectedItemsWhenContainerDeselects() throws {
        let items = makeItems()
        let containerBefore = makeContainer(withItems: items)
        // make two selection before passing to SUT
        containerBefore.select(at: 0)
        containerBefore.select(at: 1)
        let sut = makeSUT()
        
        sut.sync(container: containerBefore, forSection: 0)
        // deselecting from the container
        containerBefore.deselect(at: 0)
        
        // expect SUT to sync deselected items too
        let selectedItems = try XCTUnwrap(sut.loadedContainers[0]?.selectedItems)
        XCTAssertEqual(selectedItems, [items[1]])
    }
    
    // MARK: - Helpers
    
    private typealias Container = DefaultItemsContainer<MockItem>
    
    private func makeSUT() -> InMemorySelectionManager<Container>{
        let sut = InMemorySelectionManager<DefaultItemsContainer<MockItem>>()
        
        return sut
    }
    
    private func makeContainer(withItems items: [MockItem]? = nil) -> Container {
        return DefaultItemsContainer(
            items: items ?? makeItems(),
            preSelectedItems: nil,
            selectionType: .multiple(max: 2),
            allowAdding: true
        )
    }
}
