# Doctor Training App

## Building the Project

To get the app, navigate to the folder you want it to be in and
`git clone` this repository.

### Running the App

Once you've cloned the app open `RefugeeDatabase.xcworkspace` in Xcode.
You must open the `xcworkspace` file rather than the `xcodeproj` file so that 
the dependencies will run. After opening the file, you can select the target in 
the simulator and click the Play button in Xcode to run the app in the simulator.
To deploy to an iOS device, connect it to the computer with a USB cable and select
it as the target in Xcode

### CocoaPods

This app uses CocoaPods, a dependency manager for Cocoa projects. If issues arise
with the Pods in the project, you must install Cocoapods using the following steps:

- Open Terminal
- Enter command: `sudo gem install cocoapods`
- Enter your password

> Wait for this to finish and don't touch Terminal.  It might take a couple minutes

- Run command `pod setup`

The dependencies that the Podfile installs are included in the git repository 
so this step is not required to run the project. However, if any issues arise
with the Pods, or an update to the dependencies is desired,
run `pod install` in the project directory. Warning: this may break the project
if any of the updates contain breaking changes.

## App Structure

Upon opening the app, the user is offered two choices, either to create a new
patient record, or to look one up. If the user looks a patient up, they are 
directed to a screen where they can enter identifying information. In either
case, the user is directed to the main part of the app, with answers loaded or
not accordingly.

The main portion of the app is embedded in a tab controller that has 5 view
controllers, 4 with each of the 4 parts of the questionnaire, and one to enter
patient identifying information to store in the database or locally depending on
Internet access.

The 4 parts of the questionnaire all contain table view controller subclasses that
have their own custom table view cells. Each cell's question text is populated from
the appropriate text file in the Data folder in a method called `readQuestions`. (This
could be refactored to take the file name and into a category so it's accessible
by all the view controllers). The cells and the table view controllers are configured
in `Main.storyboard`. 

Each table view controller implements delegate and data source
methods for a table view and the cells' heights are automatically calculated using
the constraints on the cell and the estimated height. Each table view controller
is also a delegate for its cells so that when a user selects an answer in a cell,
the view controller responds by storing the answer. The answers are stored in a
dictionary with the index of the question as the key and the answer (or answer dictionary)
as the value. This is to avoid storing the questions over and over again. 

When a user selects a tab, the app checks a `PatientResponse` model object that
contains stored patient information. This model is shared between all parts of the
app and is updated as answers change. If model contains answers, they are loaded.

When a user leaves a tab, the answers stored in the view controller are saved in
in the model object (the view controllers could be refactored to not use an internal
answers dictionary but just immediately update the model object).

After filling out all parts of the questionnaire, the user goes to the patient
information tab, where their identifying information (currently only first and
last name) is entered and the data can be saved to the database.

The database backend is accessible through a RESTful API and the app interacts with
it using the AFNetworking CocoaPod, which is included in the Podfile. The Podfile 
also includes the SecureNSUserDefaults CocoaPod, which is used for secure local
storage, in the case that the POST request fails. 

There is a button on the first screen of the app that appears only when there
is local data stored on the device. When tapped, it goes through all the records
and if possible uploads them to the database and removes the information from local
storage. An alert will pop up after, telling the user if the upload succeeded or
failed. If it failed, the data will remain on the device.

## Internationalization
TODO

## Known Bugs

When searching for a patient in the database, lookup is successful the first two
times but fails the third time. I've tracked this bug as far as I could, and it
seems to originate from an object being autoreleased before it's supposed to be.
I hypothesize that the object being released is the sharedResponse, and when a
view controller tries to read from the sharedResponse it throws an error. I
have not been able to track down when or why the sharedResponse is being released,
if that is the cause of the bug.
