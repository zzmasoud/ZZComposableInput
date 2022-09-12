//
//  ZZNewTaskViewTests.swift
//  ZZNewTaskViewTests
//
//  Created by Masoud Sheikh Hosseini on 9/12/22.
//

import XCTest
import ZZNewTaskView

extension Int {
    public var minute: TimeInterval {
        return TimeInterval(self) * 60
    }
    public var hour: TimeInterval {
        return TimeInterval(self) * 60 * 1.minute
    }
    public var day: TimeInterval {
        return Double(self) * 24 * 1.hour
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

extension String {
    var localized: String {
        // return localized string
        return self
    }
}
class Task {}
class Project {}
class UIViewController {}
class CustomModalInputVC: UIViewController {
    public static let id = "CustomModalInputVC"
    
    public enum Child {
        case date, time, project, tag, timeRecord
        var id: String {
            switch self {
            case .date:
                return "dateInput"
            case .time:
                return "timeInput"
            case .project:
                return "newProjectInput"
            case .tag:
                return "newTagInput"
            case .timeRecord:
                return "timeRecordInput"
            }
        }
    }
    
    public static func setup(with child: Child, completion: @escaping ((Any)->Void)) -> UIViewController {
        return UIViewController()
    }
}

protocol NewTaskView_VMP: ZZNewTaskView_VMP {
    func didSelect(value: Any, forIndex: NewTask_VM.Index?)
    var selectedChild: CustomModalInputVC.Child { get }
    var isRepeatOptionHidden: Bool { get }
}

struct DateItem: ZZHorizontalSelectorViewPresentable {
    var color: CGColor = .black
    var title: String
    let date: Date
    
    init(date: Date, title: String) {
        self.date = date
        self.title = title
    }
}

struct TimeItem: ZZHorizontalSelectorViewPresentable {
    var color: CGColor = .black
    var title: String
    let time: TimeInterval
    
    init(time: TimeInterval, title: String) {
        self.time = time
        self.title = title
    }
}

struct weekDayItem: ZZHorizontalSelectorViewPresentable {
    let weekday: Int
    var title: String
    var color: CGColor = .black
}

class NewTask_VM: NSObject {
    
    enum Index: Int, CaseIterable {
        case none = -1, date = 0, time, project, repeatedDays, tags
        
        var title: String? {
            switch self {
            case .date:
                return "newTask_date".localized
            case .time:
                return "newTask_estimatedTime".localized
            case .tags:
                return "tags"
            case .project:
                return "newTask_project".localized
            case .repeatedDays:
                return "newTask_repeat".localized
            default:
                return nil
            }
        }
    }
    
    private weak var view: ZZNewTask_VD? {
        didSet {
            view?.fillUI()
            if let text = text {
                view?.set(text: text)
            }
            // To prepare UI for pre selected values (default values)
            for index in Index.allCases.filter({$0 != .none}) {
                self.view?.updateButton(current: false, selected: !viewModel(forIndex: index).didNotSelectAny, at: index.rawValue)
            }
        }
    }
    
    private var currentIndex: Index = .none {
        didSet {
            guard currentIndex != oldValue else { return }
            if oldValue != .none {
                view?.updateButton(current: false, selected: !viewModel(forIndex: oldValue).didNotSelectAny, at: oldValue.rawValue)
            }
            view?.updateButton(current: true, selected: false, at: currentIndex.rawValue)
            
            view?.updateUI()
        }
    }
    
    private var text: String? {
        didSet {
            view?.toggleSendButton(isEnabled: isSendButtonEnabled)
        }
    }
    
    private var editTask: Task?

    private var selectorViewModels: [Index : ZZHorizontalSelectorView_VMP]
    
    init(defaultViewModels: [Index: ZZHorizontalSelectorView_VMP]? = nil) {
        selectorViewModels = defaultViewModels ?? [:]
    }
    
    convenience init(editTask: Task) {
        self.init()
        self.editTask = editTask
    }
    
    public func set(text: String?) {
        self.text = text
    }

    private func fetchTags() -> [ZZHorizontalSelectorViewPresentable] {
        // fetch tags from persistant store
        return []
    }
    
    private func fetchProjects() -> [ZZHorizontalSelectorViewPresentable] {
        // fetch tags from persistant store
        return []
    }
    
    private func fetchTimes() -> [ZZHorizontalSelectorViewPresentable] {
        let times = [30.minute, 1.hour, 1.hour + 30.minute, 2.hour]
        return times.map({TimeItem(time: $0, title: dateComponentsFormatter.string(from: $0) ?? "-")})
    }
    
    private func fetchDates() -> [ZZHorizontalSelectorViewPresentable] {
        let today = Date().startOfDay
        return [
            DateItem(date: today, title: "today"),
            DateItem(date: today.addingTimeInterval(1.day), title: "tommorow"),
            DateItem(date: today.addingTimeInterval(7.day), title: "next week"),
            ]
    }
    
    private func fetchWeekdays() -> [ZZHorizontalSelectorViewPresentable] {
        let weekdays = Calendar.current.shortWeekdaySymbols
        return [
            weekDayItem(weekday: 1, title: weekdays[0]),
            weekDayItem(weekday: 2, title: weekdays[1]),
            weekDayItem(weekday: 3, title: weekdays[2]),
            weekDayItem(weekday: 4, title: weekdays[3]),
            weekDayItem(weekday: 5, title: weekdays[4]),
            weekDayItem(weekday: 6, title: weekdays[5]),
            weekDayItem(weekday: 7, title: weekdays[6]),
        ]
    }
    
    @discardableResult func viewModel(forIndex index: Index) -> ZZHorizontalSelectorView_VMP {
        if let vm = self.selectorViewModels[index] {
            return vm
        } else {
            var vm: ZZHorizontalSelectorView_VMP

            switch index {
            case .date:
                vm = ZZHorizontalSelectorView_VM(items: fetchDates(), selectionLimit: 1)
            case .time:
                vm = ZZHorizontalSelectorView_VM(items: fetchTimes(), selectionLimit: 1)
            case .tags:
                vm = ZZHorizontalSelectorView_VM(items: fetchTags(), selectionLimit: 5)
            case .project:
                vm = ZZHorizontalSelectorView_VM(items: fetchProjects(), selectionLimit: 1)
            case .repeatedDays:
                vm = ZZHorizontalSelectorView_VM(items: fetchWeekdays(), selectionLimit: 7, canAddNewItem: false)
            default:
                fatalError()
            }
            self.selectorViewModels[index] = vm
            return vm
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        return f
    }()
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .hour]
        f.unitsStyle = .abbreviated
        return f
    }()
    
    private func createAndSaveTask() {
        let task = Task()
        var title: String?
        var desc: String?
        var date: Date?
        var estimatedDuration: TimeInterval = 0
        var project: Project?
        var tags: NSSet?

        let substrings = text!.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        if let s = substrings.first {
            title = String(s)
        }
        if substrings.count > 1 , let s = substrings.last {
            desc = String(s)
        }
        date = (viewModel(forIndex: .date).selectedItems?.first as? DateItem)?.date
        estimatedDuration = (viewModel(forIndex: .time).selectedItems?.first as? TimeItem)?.time ?? 0
       project = (viewModel(forIndex: .project).selectedItems?.first as? Project)
        tags = NSSet()
        
        // save new task
    }
    
    private func updateTask(task: Task) {
        var title: String?
        var desc: String?
        var date: Date?
        var estimatedDuration: TimeInterval = 0
        var project: Project?
        var tags: NSSet?
        
        let substrings = text!.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        if let s = substrings.first {
            title = String(s)
        }
        if substrings.count > 1 , let s = substrings.last {
            desc = String(s)
        }
        date = (viewModel(forIndex: .date).selectedItems?.first as? DateItem)?.date
        estimatedDuration = (viewModel(forIndex: .time).selectedItems?.first as? TimeItem)?.time ?? 0
       project = (viewModel(forIndex: .project).selectedItems?.first as? Project)
        tags = NSSet()
        
        let changed = true
//        let changed: Bool =
//        (
//            task.title != title
//            ||
//            task.desc != desc
//            ||
//            task.date != date
//            ||
//            task.estimatedTime != estimatedDuration
//            ||
//            task.project != project
//        )

        // nothing changed, so skip only
        guard changed else { return }
        
        // edit current task
    }
}

extension NewTask_VM: NewTaskView_VMP {
    var isRepeatOptionHidden: Bool {
        return self.editTask != nil
    }
    
    func didSelect(value: Any, forIndex index: Index? = nil) {
        let index = index ?? self.currentIndex
        //!zzmasoud
        // this is wrong, bcz class creates the VM only if this method called
        //
        //viewModel(forIndex: index)
        
        let vm = self.viewModel(forIndex: index)
        switch index {
        case .date:
            guard let date = value as? Date else { fatalError("object should be Date()") }
            vm.add(item: DateItem(date: date, title: dateFormatter.string(from: date)))
        case .time:
            guard let time = value as? TimeInterval else { fatalError("object should be TimeInterval()") }
            vm.add(item: TimeItem(time: time, title: dateComponentsFormatter.string(from: time) ?? "-"))
        case .project, .tags:
            guard let item = value as? ZZHorizontalSelectorViewPresentable else { return }
            vm.add(item: item)
        default:
            fatalError("This never should happen!")
        }
    }
    
    var selectedChild: CustomModalInputVC.Child {
        switch self.currentIndex {
        case .date:
            return .date
        case .time:
            return .time
        case .project:
            return .project
        case .tags:
            return .tag
        default:
            return .project
        }
    }
    
    var currentTitle: String? {
        return currentIndex.title
    }
    
    var isSendButtonEnabled: Bool {
        text != nil && !text!.isEmpty
    }
    
    func textValueChanged(to text: String?) {
        self.text = text
    }
    
    var selectorViewViewModel: ZZHorizontalSelectorView_VMP {
        return viewModel(forIndex: currentIndex)
    }
    
    private func playSuccessHaptic() {}
    
    func didTapSendButton() {
        playSuccessHaptic()
        if let t = editTask {
            updateTask(task: t)
        } else {
            createAndSaveTask()
        }
        view?.dismiss()
    }
    
    func didSelectButton(at index: Int) {
        guard let newIndex = Index(rawValue: index) else { fatalError() }
        currentIndex = newIndex
    }
    
    func setView(delegate: AnyObject) {
        self.view = delegate as? ZZNewTask_VD
    }
}


class ZZNewTaskViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
