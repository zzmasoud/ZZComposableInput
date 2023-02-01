# ZZNewTaskView
This is one of the main modules in my app and because of the nested modules and complexity, I've removed extra codes + UI.

![Preview](/Resources/UI.png)

## Story: User wants to add a task

### Narrative
```
As a user
I want the app to show me a handy popup.
Then, it automatically selects the text field so I can type my task title and description quickly (without manually selecting the text field).
Then I want to view and select the required/optional items.
Then I want to tap a `save` button and expect it to get closed.
```
1. User taps on a button
2. `ZZNewTaskView` presents with a keyboard resigned first responder on it's `UITextView`
3. User can enter any text
4. User can select items such as _project_, _estimated time_, _repeat days_ **(multiple selection)** and etc.
5. User then tap on a button to save the context and the view will dissmiss.
6. view model of `ZZNewTaskView` will pass the assigned values in a completion handler.

### [Short preview (video)](/Resources/Preview.MP4)

## Problems
- Abstraction.
- Subclassing in appropriate way.
- Modularity (I think I'm doing the MVVM approach wrongly, everything mixed in the main viewModel).
- How to code the ViewModel without UI existence?
- How to preselect items when it instantiates with editing task?
- Select first item if user entering a duplicate item and prevent duplication (shown in the video when selecting estimated time).
- How to make `ZZHorizontalSelectorView_VMP` generic so the compiler knows if it's a `Date` (selected Date) or `String` (project ID) or `[Int]` (repeated days):
``` Swift
// selected date
let _ = (viewModel(forIndex: .date).selectedItems?.first as? DateItem)?.date
// selected estimated time
let _ = (viewModel(forIndex: .time).selectedItems?.first as? TimeItem)?.time ?? 0
// selected project
let _ = (viewModel(forIndex: .project).selectedItems?.first as? Project)
// selected repeated days
let _ = (viewModel(forIndex: .repeatedDays).selectedItems) as? [weekDayItem]
```
