# GHProgrammatic

GHProgrammatic is an iOS application that allows users to search for GitHub users and view their followers programmatically. The app is built using the MVVM architecture and focuses on providing a clean and maintainable codebase with protocol-oriented programming.

## Features

- Search for GitHub users
- View a list of followers for a user
- Filter followers using a search bar
- View user details including avatar, name, location, bio, public repos, public gists, followers, and following

## Usage

1. Launch the app.
2. Use the search bar to enter a GitHub username.
3. View the list of followers for the searched user.
4. Tap on a follower to view their details.

## Architecture

The project uses the MVVM (Model-View-ViewModel) architecture to ensure a clean separation of concerns and promote code reusability. Here's a brief overview of the architecture components:

- **Model**: Represents the data structures used in the app (e.g., `UserEntity`, `FollowerEntity`).
- **View**: The UI components that display the data (e.g., `FollowerListVC`, `UserInfoVC`).
- **ViewModel**: Handles the business logic and data manipulation, and communicates with the view via delegation (e.g., `FollowerListViewModel`, `UserInfoViewModel`).

## Unit Tests

Unit tests are written to ensure the functionality of the ViewModels. Mock services are used to simulate API responses. The tests can be found in the `GHProgrammaticTests` target.

To run the tests:

1. Open the project in Xcode.
2. Select the `GHProgrammaticTests` target.
3. Press `Command + U` to run all tests.
