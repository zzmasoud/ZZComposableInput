# ZZNewTaskView
This is one of the main modules in my app and because of the nested modules and complexity, I've removed extra codes + UI.

![Preview](/Resources/UI.png)

## Story: User wants to add a task

### Narrative
```
As a user
I want the app to show me a handy popup when I want to add a task.
Then, it automatically selects the text field so I can type my task title and description quickly (without manually selecting the text field).
Then I want to scroll between items and select.
Then I want to tap a `save` button and expect it to get closed.
```

#### Scenarios (Acceptance criteria)
```
Given the user has tapped an UI element to add a task
Have entered the title
When tapping the `save` UI element
Then the app should save the task and close the popup
```
```
Given the user has tapped an UI element to add a task
Have entered the title
When the popup opened from a sepecific project/date
Then preselect the specific project/date
```
```
Given the user has tapped an UI element to add a task
And the title is empty
When tapping  a `save` UI element
Then the app should do nothing since the required data haven't entered.
```

### Use Cases

#### Give Title and Description From User's Entered Text
##### Data:
- Title: String
- Description: String?

##### Primary Course:
1. The popup is presented.
2. The "save" UI element is disabled.
3. The text field is first responder.
4. User enters a text as title.
5. The "save" UI element becomes enabled.
6. User tap return and enters description
7. On excuting "send" command, the module delivers above data.

#### Load Selectable Items From Cache Use Case

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
