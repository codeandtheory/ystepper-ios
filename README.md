_Accessible and customizable Stepper user interface elements for iOS._

Licensing
----------
Y—Stepper is licensed under the [Apache 2.0 license](LICENSE).

Documentation
----------

Documentation is automatically generated from source code comments and rendered as a static website hosted via GitHub Pages at: https://yml-org.github.io/ystepper-ios/

Usage
----------
### `StepperControl` (UIKit)

`StepperControl` is a subclass of `UIControl` with an api similar to `UIStepper`.

### `Stepper` (SwiftUI)

`Stepper` is a struct that conforms to the SwiftUI `View` protocol.

### Initializers

Both `StepperControl` and `Stepper`can be initialized with the same five parameters (`StepperControl`uses `Stepper` internally):

```swift
init(
    appearance: StepperControl.Appearance = .default,
    minimumValue: Double = 0,
    maximumValue: Double = 100,
    stepValue: Double = 1,
    value: Double = 0
)
```

The standard initializer lets you specify the appearance, minimum value, maximum value, step value and current value, although it provides sensible defaults for all of these.

`StepperControl` has an additional initializer:

```swift
init?(coder: NSCoder)
```

For use in Interface Builder or Storyboards (although we recommend that you build your UI in code).

A stepper created this way begins with the default appearance, but you can customize it at runtime by updating its `appearance` property.

### Customization

`StepperControl` and `Stepper` both have an `appearance` property of type `Appearance`.

`Appearance` lets you customize the stepper’s appearance. You have full control over the colors, typographies, and images used. The default appearance is dark mode compatible and WCAG 2.0 AA compliant for color contrast.

```swift
/// Appearance for stepper that contains typography and color properties
    public struct Appearance {
        /// Typography of stepper value label
        public var textStyle: (textColor: UIColor, typography: Typography)
        /// Background color for stepper view
        public var backgroundColor: UIColor
        /// Border color for stepper view
        public var borderColor: UIColor
        /// Border width for stepper view
        public var borderWidth: CGFloat
        /// Delete button image
        public var deleteImage: UIImage
        /// Increment button image
        public var incrementImage: UIImage
        /// Decrement button image
        public var decrementImage: UIImage
        /// Stepper's layout properties such as spacing between views. Default is `.default`.
        public var layout: Layout
        /// Whether to show delete image or not
        public var showDeleteImage: Bool
}
```

Appearance has `layout` property that can be used for customizing layout of the content.

```swift
/// A collection of layout properties for the `StepperControl`
    public struct Layout: Equatable {
        /// The content inset from edges. Stepper "content" consists of the two buttons and the text label between them.
        /// Default is `{8, 16, 8, 16}`.
        public var contentInset: NSDirectionalEdgeInsets
        /// The horizontal spacing between the stepper buttons and label. Default is `8.0`.
        public var gap: CGFloat
        /// Stepper's shape. Default is `.capsule`.
        public var shape: Shape

        /// Default stepper control layout.
        public static let `default` = Layout()
}
```

In `layout` there is a `shape` property that help decide the shape of `StepperControl` and `Stepper`

```swift
/// Stepper's shape.
    public enum Shape: Equatable {
        /// None
        case none
        /// Rectangle
        case rectangle
        /// Rounded rectangle
        case roundRect(cornerRadius: CGFloat)
        /// Rounded rectangle that scales with Dynamic Type
        case scaledRoundRect(cornerRadius: CGFloat)
        /// Capsule
        case capsule
    }
```

### Usage (UIKit)

1. **How to import?**
    
    ```swift
    import YStepper
    ```
    
2. **Create a stepper**
    
    ```swift
    // Create stepper with default values
    let stepper = StepperControl()
    
    // Add stepper to any view
    view.addSubview(stepper)
    ```
    
3. **Customize and then update appearance**
    
    ```swift
    // Create a stepper with current value text color set to green
    var stepper = StepperControl(appearance: StepperControl.Appearance(textStyle: (textColor: .green, typography: .systemLabel)))
    
    // Change the text color to red
    stepper.appearance.textStyle.textColor = .red
    ```
    
4. **Update Stepper properties**
    
    ```swift
    // Set minimum value to 10 and maximum value to 101
    stepper.minimumValue = 10
    stepper.maximumValue = 101
    
    // Set current value to 15
    stepper.value = 15
    ```
    
5. **Receive change notifications**
    
    To be notified when the value changes, simply use the target-action mechanism exactly as you would for `UIDatePicker` or `YCalendarPicker`.
    
    ```swift
    // Add target with action
    stepper.addTarget(self, action: #selector(onValueChange), for: .valueChanged)
    ```
    

### Usage (SwiftUI)

1. **How to import?**
    
    ```swift
    import YStepper
    ```
    
2.  **Create a stepper view**
    
    `Stepper` conforms to SwiftUI's `View` protocol so we can directly integrate `Stepper` with any SwiftUI view.
    
    ```swift
    var body: some View {
        Stepper()
    }
    ```
    
3. **Customize and then update appearance**
    
    ```swift
    struct CustomStepper {
        @State var stepper: Stepper = {
            // Create a stepper with text color set to green
            var stepper = Stepper()
            stepper.appearance.textStyle.textColor = .green
            return stepper
        }()
    }
    
    extension CustomStepper: View {
        public var body: some View {
            VStack {
                stepper
                Button("Go Red") {
                    // Change the text color to red
                    stepper.appearance.textStyle.textColor = .red
                }
            }
        }
    }
    ```
    
4. **Update Stepper properties**
    
    ```swift
    struct CustomStepper {
        @State var stepper = Stepper()
    }
    
    extension CustomCalendar: View {
        var body: some View {
            VStack {
                stepper
                Button("Set Min/Max value") {
                    // set minimum value to 10 and maximum value to 101
                    stepper.minimumValue = 10
                    stepper.maximumValue = 101
                }
                Button("Show current value as 15") {
                    // update value
                    stepper.value = 15
                }
            }
        }
    }
    ```
    
5. **Receive change notifications** 
    
    To be notified when the user update the value, you can use the `delegate` property and conform to the `StepperDelegate` protocol.
    
    ```swift
    extension DemoView: StepperDelegate {
        // Value was changed
        func valueDidChange(newValue: Double) {
            print("New value: \(value)")
        }
    }
    ```

Dependencies
----------

Y—Stepper depends upon our [Y—CoreUI](https://github.com/yml-org/ycoreui) and [Y—MatterType](https://github.com/yml-org/ymattertype) frameworks (both also open source and Apache 2.0 licensed).

Installation
----------

You can add Y—Stepper to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Add Packages...**
2. Enter "[https://github.com/yml-org/ystepper-ios](https://github.com/yml-org/ystepper-ios)" into the package repository URL text field
3. Click **Add Package**

Contributing to Y—Stepper
----------

### Requirements

#### SwiftLint (linter)
```
brew install swiftlint
```

#### Jazzy (documentation)
```
sudo gem install jazzy
```

### Setup

Clone the repo and open `Package.swift` in Xcode.

### Versioning strategy

We utilize [semantic versioning](https://semver.org).

```
{major}.{minor}.{patch}
```

e.g.

```
1.0.5
```

### Branching strategy

We utilize a simplified branching strategy for our frameworks.

* main (and development) branch is `main`
* both feature (and bugfix) branches branch off of `main`
* feature (and bugfix) branches are merged back into `main` as they are completed and approved.
* `main` gets tagged with an updated version # for each release
 
### Branch naming conventions:

```
feature/{ticket-number}-{short-description}
bugfix/{ticket-number}-{short-description}
```
e.g.
```
feature/CM-44-button
bugfix/CM-236-textview-color
```

### Pull Requests

Prior to submitting a pull request you should:

1. Compile and ensure there are no warnings and no errors.
2. Run all unit tests and confirm that everything passes.
3. Check unit test coverage and confirm that all new / modified code is fully covered.
4. Run `swiftlint` from the command line and confirm that there are no violations.
5. Run `jazzy` from the command line and confirm that you have 100% documentation coverage.
6. Consider using `git rebase -i HEAD~{commit-count}` to squash your last {commit-count} commits together into functional chunks.
7. If HEAD of the parent branch (typically `main`) has been updated since you created your branch, use `git rebase main` to rebase your branch.
    * _Never_ merge the parent branch into your branch.
    * _Always_ rebase your branch off of the parent branch.

When submitting a pull request:

* Use the [provided pull request template](.github/pull_request_template.md) and populate the Introduction, Purpose, and Scope fields at a minimum.
* If you're submitting before and after screenshots, movies, or GIF's, enter them in a two-column table so that they can be viewed side-by-side.

When merging a pull request:

* Make sure the branch is rebased (not merged) off of the latest HEAD from the parent branch. This keeps our git history easy to read and understand.
* Make sure the branch is deleted upon merge (should be automatic).

### Releasing new versions
* Tag the corresponding commit with the new version (e.g. `1.0.5`)
* Push the local tag to remote

Generating Documentation (via Jazzy)
----------

You can generate your own local set of documentation directly from the source code using the following command from Terminal:
```
jazzy
```
This generates a set of documentation under `/docs`. The default configuration is set in the default config file `.jazzy.yaml` file.

To view additional documentation options type:
```
jazzy --help
```
A GitHub Action automatically runs each time a commit is pushed to `main` that runs Jazzy to generate the documentation for our GitHub page at: https://yml-org.github.io/ystepper-ios/
