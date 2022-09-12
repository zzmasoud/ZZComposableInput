import Foundation
import ZZNewTaskView

scope(of: "when user taps on (+) button to create a new task and selects first date item") {
    let viewModel = CustomNewTaskView_VM()
    let view = ZZNewTaskView()
    view.viewModel = viewModel
    
    // select date
    viewModel.didSelectButton(at: 0)
    let selectorViewModel = viewModel.selectorViewViewModel

    // select first default value
    selectorViewModel.didSelect(index: 0)

    viewModel.printStatus()
    
}
