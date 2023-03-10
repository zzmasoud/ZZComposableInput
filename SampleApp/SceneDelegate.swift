//
//  Copyright © zzmasoud (github.com/zzmasoud).
//  

import UIKit
import ZZTaskInput
import ZZTaskInputiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let textParser = CLOCTextParser()
        
        window?.rootViewController = ZZTaskInputViewComposer.composedWith(
            textParser: textParser,
            itemsLoader: ItemsLoader(),
            preSelectedItemsHandler: { section in
                return section == 0 ? [preselectedItem] : []
            })
        window?.makeKeyAndVisible()
    }
}

let preselectedItem = NEED_TO_BE_GENERIC.init(id: UUID(), title: "Item 2")

class ItemsLoader: ZZItemsLoader {
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
