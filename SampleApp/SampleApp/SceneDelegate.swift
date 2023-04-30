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
        let textParser = DefaultTextParser()
        let inputView = makeInputViewController()
        let resourceViewTogglingPresenter = ResourceViewTogglingPresenter(view: WeakRefVirtualProxy(inputView))
        inputView.onViewDidLoad = { [weak self] in
            resourceViewTogglingPresenter.viewDidLoad()
        }
        let sectionsPresenter = SectionsPresenter(
            titles: Category.allCases.map { $0.title },
            view: WeakRefVirtualProxy(inputView.sectionsController!)
        )
        
        let resourceListViewAdapter = ResourceListViewAdapter<DefaultItemsContainer>(
            controller: inputView,
            containerMapper: containerMapper,
            cellControllerMapper: cellControllerMapper)
                
        window?.rootViewController = ZZTaskInputViewComposer.composedWith(
            inputView: inputView,
            textParser: textParser,
            itemsLoader: MockItemsLoader(),
            sectionSelectionView: CustomSegmentedControl(),
            resourceListView: CustomTableView(),
            sectionsPresenter: sectionsPresenter,
            loadResourcePresenter: makeLoadResourcePresenter(
                resourceListViewAdapter: resourceListViewAdapter,
                inputController: inputView
            ),
            sectionsControllerDelegate: SectionsControllerDelegateAdapter(
                sectionsPresenter: sectionsPresenter,
                resourceViewTogglingPresenter: resourceViewTogglingPresenter
            )
        )
        window?.makeKeyAndVisible()
    }
    
    private func makeInputViewController() -> ZZTaskInputViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: SceneDelegate.self))
        return storyboard.instantiateInitialViewController() as! ZZTaskInputViewController
    }
    
    private func makeLoadResourcePresenter(
        resourceListViewAdapter: ResourceListViewAdapter<DefaultItemsContainer>,
        inputController: ZZTaskInputViewController
    ) -> LoadResourcePresenter {
        return LoadResourcePresenter(
            loadingView: WeakRefVirtualProxy(inputController),
            listView: resourceListViewAdapter)
    }
    
    private func cellControllerMapper(items: [AnyItem]) -> [ZZSelectableCellController] {
        items.map { item in
            let view = CustomCellController(model: item as! CustomCellPresentable)
            return ZZSelectableCellController(
                id: item,
                dataSource: view,
                delegate: nil)
        }
    }

    private func containerMapper(section: Int, items: [AnyItem]?) -> DefaultItemsContainer {
        let preselectedItems = section == 0 ? [preselectedItem] : []
        let section = Category.allCases[section]
        return DefaultItemsContainer(
            items: items,
            preSelectedItems: preselectedItems,
            selectionType: section.selectionType, allowAdding: section != .fruits
        )
    }
}

extension ZZTaskInputViewController: ResourceViewToggling {
    public func display(_ viewModel: ResourceViewTogglingViewModel) {
        let targetView = resourceListView.view.superview
        if viewModel.isHidden {
            targetView?.isHidden = viewModel.isHidden
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: .curveLinear) {
                targetView?.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
}
