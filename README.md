# ZZComposableInput
<p><img src="https://img.shields.io/badge/Swift-v5-orange"> <img src="https://img.shields.io/badge/iOS-%2B13.0-blue"> <img src="https://img.shields.io/badge/macOS-%2B10.15-blue"> <img src="https://img.shields.io/badge/SPM-Compatible-brightgreen"> <img src = "https://github.com/zzmasoud/ZZComposableInput/actions/workflows/swift.yml/badge.svg">
 <img src="https://img.shields.io/badge/Coverage-100%25-brightgreen"></p>
<p>This multiplatform library helps to get the user's selected items from different sections using high composability.</br>
I'm using it in my personal app <a href="zzmasoud.github.io/CLOC">CLOC: Tasks & Time Tracker</a> to create/edit tasks, here is a quick preview:</p>
<p float="left">
  <img src="https://github.com/zzmasoud/ZZComposableInput/blob/4dd12044476549839fa1ca2e1865a24adba9db8e/Documentation/Resources/preview1.jpg" width="300"/>
    
  <img src="https://github.com/zzmasoud/ZZComposableInput/blob/4dd12044476549839fa1ca2e1865a24adba9db8e/Documentation/Resources/preview2.jpg" width="300"  hspace="20"/> 
</p>

## Documentation
#### ItemType
```swift
public protocol ItemType: Hashable {
    var title: String { get }
}
```
The core model that is used widely in the project. </br>
For now, it is using a typealias `AnyItem` which is equal to `ItemType`. It is added for further development.
#### ItemsLoader
```swift
public protocol ItemsLoader {
    associatedtype Item: AnyItem
    
    typealias FetchItemsResult = Result<[Item], Error>
    typealias FetchItemsCompletion = (FetchItemsResult) -> Void

    func loadItems(for section: Int, completion: @escaping FetchItemsCompletion) -> CancellableFetch
}
```
Abstraction of loading data for each section.

#### ItemsContainer
```swift
public protocol ItemsContainer: AnyObject {
    associatedtype Item: AnyItem
    
    var delegate: ItemsContainerDelegate? { get set }
    var selectionType: ItemsContainerSelectionType { get }
    var items: [Item] { get }
    var selectedItems: [Item]? { get }
    var allowAdding: Bool { get }
    func select(at index: Int)
    func deselect(at index: Int)
    func add(item: Item)
    func removeSelection()
}
```
Abstraction of controlling items in a container. </br> It is provided with `DefaultItemsContainer` which do the things needed, such as:
- [x] Selection
- [x] Deselection
- [x] Prevent selection more than maximum limit
- [x] Delegation

#### SectionedViewProtocol
```swift
public protocol SectionedViewProtocol: AnyObject {
    associatedtype View
    var view: View { get }
    var selectedSectionIndex: Int { set get }
    var numberOfSections: Int { get }
    var onSectionChange: (() -> Void)? { set get }
    func reload(withTitles: [String])
}
```
Abstraction of a view with sections, e.g. `UISegmentedControl`.

#### ResourceListViewProtocol
```swift
public protocol ResourceListViewProtocol: AnyObject {
    associatedtype View
    associatedtype CellController: SelectableCellController
    
    var view: View { get }
    var onSelection: ((Int) -> Void) { get set }
    var onDeselection: ((Int) -> Void) { get set }
    func reloadData(with: [CellController])
    func allowMultipleSelection(_ isOn: Bool)
    func allowAddNew(_ isOn: Bool)
    func deselect(at: Int)
}
```
Abstraction of a view with list of items e.g. `UITableView`, `UICollectionView`.

## Getting Started
- You can head to <a href="https://github.com/zzmasoud/ZZComposableInput/blob/fa060c559a831c2fc48b305224bf45bb61e58a33/Tests/Snapshot%20Tests/iOSSnapshotTests.swift">iOS Snapshot Tests</a> and learn how to use it in your iOS project. There are a lot of mocking which helps you conform your custom views and models to the protocols of this library.
- There is a public class called `ZZComposableInput` which you can get started.

## Contribution
Please feel free to open an issue to:
- Repoert a bug
- Request a feature
- Ask for help
<p>And also you can help improving this project by opening a PR.</p>

## License
ZZComposableInput is available under the MIT license. See the LICENSE file for more info.
