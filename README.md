# MVVM-C SwiftUI App

This repository contains a simple iOS application built with SwiftUI demonstrating a modern MVVM (Model-View-ViewModel) architectural approach using the new `@Observable` macro introduced in iOS 17.

## Features

- **SwiftUI & Modern Concurrency:** Built with SwiftUI, utilizing `async/await` for asynchronous operations.
- **MVVM Architecture:** Clean separation of concerns between Views, ViewModels, and the networking layer.
- **Dependency Injection:** The `ViewModel` is initialized with an `APIProtocol`, allowing for easy mocking and testing.
- **Network Manager:** A generic, reusable `NetworkManager` for making API calls and decoding JSON responses.

## Code Structure

- `ContentView.swift`: Contains the main UI view, the `ViewModel` using the `@Observable` macro, the generic `NetworkManager` implementing `APIProtocol`, and the `User` data model.
- `MVVM_CApp.swift`: The entry point of the application.

## Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later (due to the usage of the `@Observable` macro)
- Swift 5.9

## Getting Started

1. Clone this repository.
2. Open `MVVM-C.xcodeproj` in Xcode.
3. Select an iOS simulator or iOS device.
4. Build and run the project `(Cmd + R)`.

## API Integration

The app fetches a list of mock users from `https://www.bukai95.com/users` and displays their names in a SwiftUI `List`. It includes error handling to display relevant messages if the network request or decoding fails.
