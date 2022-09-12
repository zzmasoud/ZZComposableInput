# ZZNewTaskView
This is one of the main module in my app

![Preview](/Resources/UI.png)

## How does it work?
1. User taps on a button
2. `ZZNewTaskView` presents with a keyboard resigned first responder on it's `UITextView`
3. User can enter any text
4. User can select items such as _project_, _estimated time_, _repeat days_ **(multiple selection)** and etc.
5. User then tap on a button to save the context and the view will dissmiss.
6. view model of `ZZNewTaskView` will pass the assigned values in a completion handler.

### [Short preview (video)](/Resources/Preview.MP4)
