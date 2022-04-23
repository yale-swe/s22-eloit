# Eloit
Ranking through comparison

## Summary
Eloit is a social platform aiming to rank things by comparison using Elo scores. It is a term project for Yale's CPSC 439 by Xinli, Harry, Jack, Yofti, Revant, and Kevin.

## Problem
We want to address the problem of rating things in a new way. Traditionally, rating sites provide a scale of 1-10 for users to choose from, and people can see rankings based on average ratings. Of course this works, but sometimes what we want is to make comparisons and rank items that generally have similar ratings on a 1-10 scale. Maybe film A has a slightly higher average rating than film B, but 60% of people who have seen both would consider B the better one. That is because when people offer ratings they often don’t have a fair perspective in their judgment. By using other items as a reference, these ratings will have a more intuitive meaning and produce results that more accurately represent people’s preferences. Furthermore, by using a “this or that” structure, people can more easily engage with and debate the results, demonstrating another advantage over traditional ratings.

## Technology Stack
Our technology stack is built around two main technologies: the open-source UI SDK Flutter on the frontend and Google's Firebase backend-as-a-service. Using the cross-platform capabilities of Flutter, our app is able to run on the following systems:
- Web (our current primary platform, hosted at [https://eloit-c4540.web.app](https://eloit-c4540.web.app))
- iOS
- Android
- Mac
with future options for Windows and Linux versions as well. Moreover, in terms of Firebase, we use a variety of cloud functionalities, including:
- **Firebase Authentication** for secure registration and login
- **Cloud Firestore** no-SQL database for storing our basic app data
- **Firebase Storage** for storing images
- **Firebase Hosting** for deploying and hosting the website

## Installation/Running
In order to run our project locally, complete the following steps:
1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install)
2. (Optional) Set up your desired emulators/devices for running
3. Execute `flutter pub get` in the project folder to get updated packages
4. Execute `flutter run` to run the project
Notably, there is no particular backend setup required, as everything is cloud-based and connected via Firebase.

## Project/Folder Structure
While not comprehensive, a basic outline of the folder structure of our project is as follows:
- `lib` conatins the majority of our structual project code
  - `main.dart` contains the `main` function that drives the application
  - `models` contains the database models as Dart classes
  - `screens` contains the code for the UI of each screen
  - `services` contains "backend" services, e.g. database and authentication
  - `shared` includes files and Flutter widgets used in muliple places across the app  
- `test` and `integration_test` contains our test files
-  `db_help` includes some Python scripts for loading categories automatically into the database and other database management tasks
-  `.github/workflows` contains the Github Workflows described below for testing and deployment
- `web`, `android`, `ios`, `macos`, `windows`, and `linux` contain the compiled code and dependencies for each platform

## CI/CD Workflow
Our project, while primarily a mobile application, has a corresponding web version that is hosted via Firebase hosting at [https://eloit-c4540.web.app](https://eloit-c4540.web.app). On all pushes, our `test.yml` workflow gets the required packages using `flutter pub get`, tests the application according to the tests in the `test` and `integration_test` folders using `flutter test`, and builds the web application with `flutter build web`. If the push was to `main` (e.g. for a merged pull request), the `deploy.yml` workflow takes the aforementioned web build and deploys it to Firebase. Ultimately, this creates a workflow of constant testing and deployment of successful versions of `main`.
