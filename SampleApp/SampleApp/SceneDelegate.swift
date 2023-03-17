//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

private class CustomSegmentedControl: SectionedViewProtocol {
    let segmentedControl = UISegmentedControl()
    
    var selectedSectionIndex: Int {
        get { segmentedControl.selectedSegmentIndex }
        set { segmentedControl.selectedSegmentIndex = newValue }
    }
    
    var numberOfSections: Int { segmentedControl.numberOfSegments }
    
    func removeAllSections() {
        segmentedControl.removeAllSegments()
    }
    
    func insertSection(withTitle: String, at: Int) {
        segmentedControl.insertSegment(withTitle: withTitle, at: at, animated: false)
    }
    
    var view: UIControl { segmentedControl }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let textParser = DefaultTextParser()
        
        window?.rootViewController = ZZTaskInputViewComposer.composedWith(
            textParser: textParser,
            itemsLoader: MockItemsLoader(),
            sectionSelectionView: CustomSegmentedControl(),
            containerMapper: { section, items in
                let preselectedItems = section == 0 ? [preselectedItem] : []
                return DefaultItemsContainer(
                    items: items,
                    preSelectedItems: preselectedItems
                )
            })
        window?.makeKeyAndVisible()
    }
}

let preselectedItem = NEED_TO_BE_GENERIC.init(id: UUID(), title: "Avocado")

class MockItemsLoader: ItemsLoader {
    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
        guard let category = Category(rawValue: section) else { fatalError("Failed to init Category enum case.") }
        switch category {
        case .fruits:
            completion(.success([
                .init(id: UUID(), title: "Orange"),
                .init(id: UUID(), title: "Apple"),
                .init(id: UUID(), title: "Watermelon"),
                .init(id: UUID(), title: "Banana"),
                preselectedItem,
                .init(id: UUID(), title: "Carrot"),
            ]))
        case .animals:
            completion(.success([
                .init(id: UUID(), title: "Fox"),
                .init(id: UUID(), title: "Tiger"),
                .init(id: UUID(), title: "Elephant"),
                .init(id: UUID(), title: "Panda"),
                .init(id: UUID(), title: "Eagle"),
                .init(id: UUID(), title: "Polar bear"),
                .init(id: UUID(), title: "Dolphin"),
                .init(id: UUID(), title: "Chimpanzee"),
                .init(id: UUID(), title: "Lion"),
                .init(id: UUID(), title: "Kangaroo"),

            ]))

        case .symbols:
            completion(.success([
                .init(id: UUID(), title: "Up"),
                .init(id: UUID(), title: "Down"),
                .init(id: UUID(), title: "Left"),
                .init(id: UUID(), title: "Right"),
            ]))
            
        default:
            completion(.failure(NSError(domain: "error", code: -1)))
        }
    }
}
