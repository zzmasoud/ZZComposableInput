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
            preSelectedItemsHandler: { section in
                return section == 0 ? [preselectedItem] : []
            })
        window?.makeKeyAndVisible()
    }
}

let preselectedItem = NEED_TO_BE_GENERIC.init(id: UUID(), title: "Item 2")

class MockItemsLoader: ItemsLoader {
    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) {
        switch section {
        case 0:
            completion(.success([
                .init(id: UUID(), title: "Item 0"),
                .init(id: UUID(), title: "Item 1"),
                preselectedItem,
                .init(id: UUID(), title: "Item 3"),
            ]))
            
        case 1:
            completion(.success([
                .init(id: UUID(), title: "Item --0"),
                .init(id: UUID(), title: "Item --1"),
            ]))

        case 2:
            completion(.success([
                .init(id: UUID(), title: "Item --0--"),
                .init(id: UUID(), title: "Item --1--"),
            ]))
            
        default:
            completion(.failure(NSError(domain: "error", code: -1)))
        }
    }
}
