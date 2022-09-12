import Foundation
import ZZNewTaskView

scope(of: "when user taps on (+) button to create a new task") {
    let viewModel = CustomNewTaskView_VM()
    let view = ZZNewTaskView()
    
    // select date
    view.selectButton(at: 0)
    let selectorViewModel = viewModel.selectorViewViewModel
    
    selectorViewModel.didSelect(index: 0)
    
    viewModel.printStatus()
    
}
