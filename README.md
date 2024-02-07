# Mohamed Ali Ebaid
# Cairo-Egypt
# mo7amedaliebaid@gmail.com

## Notice
- I had a gradle issue with the project you provided me
- So i created a new flutter project and moved all dart files, relevant files and assets to this new flutter project and completed the task.
- there is Screenshots in `screenshots` folder and a video for web demo named `dineOut.mp4` and `mobile.mp4` for mobile.


# DineOut Applicant Task

Thank you for taking the time to complete this task.
We are excited to see your solution!

You should expect the task to take around 1–2 hours to complete in total.

## General Information

At our startup, we are building a Flutter app with which restaurant menus can be searched and viewed.
This is a very simplified version of that app, in which only some parts of the menu viewing functionality are present.
Also, in this version, all data is hardcoded (`lib/model/dummy_data.dart`).

You need to have Flutter (3.16+) installed on your machine.
To verify that your flutter installation works correctly, run `flutter doctor` in your terminal.
To run the app, navigate to the project directory and do the following:
1. `flutter pub get` to install the dependencies
2. `flutter run` to start the app. You may need to choose which platform you want to run the app on.

When you run the app, you will see a list of restaurants. Clicking on a restaurant opens its menu view.
The menu view will not show any dishes before you have implemented subtask 1 (see below).

## Task Description

The task consists of two subtasks. **You need to solve both tasks in your submission!**
You need to start with the first subtask, as the second subtask builds on the first one.
You can use any IDE you like.
The time limit is one week: You need to submit your solution by the **14th of February 2024** (see "Submitting your solution" for details).

### Important preliminaries

**Please read all points below before you start working on the subtasks!**

- You must not add any new dependencies to the project (i.e., do not edit `pubspec.yaml`).
- Make sure your code is readable, clean, and well-structured.
- Your code should break lines after *120 characters*, not 80. You can either configure this in your IDE, or format your code with `dart format -l 120 .`.
- Please document all of your code carefully and extensively.
- You can use any resources you like to solve the task, but please don't copy-paste code from the internet or from something like ChatGPT.
- If you have any questions, feel free to ask us! Contact details are at the bottom of this document.

### Criteria for evaluation
Your submission will be evaluated based on the following criteria, ordered from most to least important:
1. **Correctness**: Does your solution actually solve the problem correctly?
2. **Code quality**: Is your code simple, readable, and well-structured? Does `dart analyze` note any issues?
3. **Documentation**: Is your code well-documented, and are your comments helpful?

### Subtask 1: Pre-order tree traversal

In the DineOut app, the menu is represented as a tree structure, in which each node represents a category or a dish.
We call dishes (i.e., the food items) "entries."
In the tree, a node represents a category if it has children, and an entry if it does not have children.
A category can have more categories as children—this may extend to any depth.
There is also a dedicated root node, which is not visible in the app, but groups all the categories together.
Please look at the file `lib/model/menu_tree.dart` and get a general overview of this tree structure.
**In this subtask, you may not modify any file apart from `lib/model/menu_tree.dart`!**

In that file, on line 31, you will find a method called `traverse()`, which is not yet implemented.
**Your task is to implement this method.**
As its documentation states, this method should traverse the tree below the node in a pre-order manner and return a list of all the nodes (including categories, entries, and the root node).
This method is used to display the restaurant's menu in the app, so when you are done implementing it, you should be able to see the dishes in the app.

The estimated time to complete this subtask is 15 minutes.

#### Verifying your solution
You can verify that your solution is correct in two ways (it is recommended to check both):
1. Run the app, open Restaurant A, and verify that it looks like in `screen_entries.png`.
2. Check the tests in `test/tree_test.dart` by running `flutter test` in your terminal.

### Subtask 2: Category overview

In the DineOut app, the menu view for a restaurant shows all the dishes in a list, while all *top-level* categories are shown in a tab bar at the top of the screen.
What I mean by *top-level* categories is that only the categories that are direct children of the root node (i.e., those on depth 1) are shown in the tab bar.
Categories that are children of other categories are not shown in the tab bar, but are still shown in the list of dishes.
Tapping on an element in the tab bar scrolls the list to the corresponding category.

Now, open Restaurant A in the app, and click on the yellow list button at the bottom right, then on "All Categories".
An empty screen is shown, with a "TODO" text in the middle.
**Your task is to implement this screen in the file `widgets/menu/categories.dart`.**
It should show a list of all *top-level* categories, and tapping on a category should scroll the list to the corresponding category in the list of dishes.
The categories should be arranged in a grid, with their name and number of entries shown.
The app bar at the top should display "$restaurantName: Categories".
Please look at the video `screen_categories.mp4` to see how the screen should look and function.
Note that you should handle different app window sizes well, as shown in the video.

The screen does not have to look exactly the same as in the video—I know I'm not a good UI designer—so feel free to improve it if you know how.
Just make sure it still functions, it is still a grid, and it does not look *worse* than in the video.
(This is not a necessary part of the task, you can absolutely make it look the same as in the video if you want to.)

In `categories.dart`, I recommend you create a separate `CategoryWidget` class to represent a category in the grid.
The `CategoryOverviewWidget` can then use a grid view to display the categories.

Now, how do you scroll to the category after tapping on it in the overview screen?
This functionality is already implemented in `widgets/menu/restaurant.dart:108` (you do not need to edit this file).
All you need to do after clicking on a category is that, when popping from the navigator,
pass the *index of the category within `menuTree.categories` to scroll to* as a result to the `pop()` method.

#### Verifying your solution
Just make sure it fulfills the criteria outlined above, and that it looks and functions as in the video `screen_categories.mp4`.
You can look at Restaurant C too, to see how the screen looks with just one category.

I'd also recommend running `dart format -l 120 .` at this point to format your code, and to check for any issues with `dart analyze`.

## Submitting your solution
When you are done and have verified that both subtasks are solved, please run `flutter clean`, and then upload a zip file containing your solution.
The filename of the zip file should include your name, for example, `dineout_task_ramy_khorshed.zip`.
The zip file should contain the entire project, including all files and directories.
For example, on Linux, you can create the zip file by navigating to the project directory and running `zip -r dineout_task_your_name.zip .`.

Please upload the zip file to https://bin.falko.page/ and send the link to **falko@dineout.ai**.
The uploader password is `dineout`, burn after should be set to "No Limit", the expiration should be set to "1 week" or "never",
and the privacy should be set to "public" or "unlisted" (even with "public", others can't see your submission, so don't worry).
Files can be added at the bottom left.

After clicking on "Save", you will be redirected to a page where your zip file is available at a link.
This link should be sent to **falko@dineout.ai**.
Do not send the zip file directly via email, our mail server will not accept it. It needs to be a link to the file.
If you have trouble with the bin.falko.page website, you can also use something like Google Drive or Dropbox instead.

The submission deadline is the **14th of February 2024, 23:59, Anywhere on Earth**.
Submissions received after this deadline will not be considered.

## I still have questions!
If you have any questions or trouble setting up the project, don't hesitate to contact us at **falko@dineout.ai**!