# ZZNewTaskView
This is one of the main modules in my app and because of the nested modules and complexity, I've removed extra codes + UI.

![Preview](/Resources/UI.png)
### [Video Preview](/Resources/Preview.MP4)

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

#### Get Title and Description From User's Entered Text
##### Data:
- Title: String
- Description: String?

##### Primary Course:
1. User enters a text.
2. User enters return and continues typing.
3. On excuting "send" command, the module delivers above data.


#### Load Selectable Items For Each Section Use Case
##### Data:
- Section

##### Primary Course:
1. Execute "fetch items" command with above data.
2. User can select each section and the module should load them if needed.
3. Hold loaded items to prevent further loading.

#### Empty Items Course:
1. Delivers nothing to select.

#### Retrieval Error Course (Sad Path):
1. System delivers error.


#### Select/Deselect Items In A Section
##### Data:
- Selected items

##### Primary Course:
1. The module should know if the current section is single or multiple selection.
1. User can select single or multiple regarding to step (1).
2. If it's a single selection, after selecting any it should replace.
3. If it's a multiple selection, after selecting any, if selecting the same item, it means deselect.
4. The module should hold only selected items.
5. On excuting "send" command, the module delivers above data.

##### Empty Items Course:
1. There's nothing to select.
