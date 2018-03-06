<center><h1><b>Patterns</b></h1></center>
<center><h6><i>Simplifying pattern building in Swift</i></h6></center>

___

Patterns is a library for building regular-expression-like matchers with native Swift data types.

- [Features](#features)
- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [Documentation](#documentation)
- [License](#license)

## Features

- [x] Enables developers to work with Swift-friendly data types to construct and test patterns.
- [x] Helps building Patterns using descriptive components instead of raw string format.
- [x] Gives developers the capability to use Boolean operators to combine simple patterns to form complex ones.
- [x] Provides the core functionality for building custom pattern types.

## Usage

See [sample code examples](https://github.com/harishkataria/Patterns/blob/master/Documentation/Usage.md).

## Requirements

- iOS 8.0+ /  macOS 10.10+ / tvOS 9+ / watchOS 2+
- Xcode 9+
- Swift 4+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build Patterns 1.0+.

To integrate Patterns into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'harishkataria/Patterns', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Patterns into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "harishkataria/Patterns" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `Patterns.framework` into your Xcode project.

## Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Patterns does support its use on supported platforms.

Once you have your Swift package set up, adding Patterns as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

#### Swift 4

```swift
dependencies: [
    .package(url: "https://github.com/harishkataria/Patterns.git", from: "1.0.0")
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate Patterns into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add Patterns as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/harishkataria/Patterns.git
  ```

- Open the new `Patterns` folder, and drag the `Patterns.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `Patterns.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Select the relevant `Patterns.framework` for the platform.
- And that's it!

## Documentation

See Jazzy-generated [docs](https://harishkataria.github.io/Patterns/).

## License

Patterns is released under the MIT license. See [LICENSE](https://github.com/harishkataria/Patterns/blob/master/LICENSE) for details.
