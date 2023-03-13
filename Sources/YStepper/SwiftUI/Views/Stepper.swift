//
//  Stepper.swift
//  YStepper
//
//  Created by Sahil Saini on 06/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import SwiftUI
import YMatterType

/// A SwiftUI stepper control.
public struct Stepper {
    enum ButtonType {
        case increment
        case decrement
    }

    let minimumSize: CGSize = CGSize(width: 44, height: 44)

    @ObservedObject private var appearanceObserver = Stepper.AppearanceObserver()
    @ObservedObject private var valueObserver = Stepper.ValueObserver()

    /// Receive value change notification
    public weak var delegate: StepperDelegate?
    /// Stepper appearance
    public var appearance: StepperControl.Appearance {
        get {
            self.appearanceObserver.appearance
        }
        set {
            self.appearanceObserver.appearance = newValue
        }
    }
    /// Optional minimum vale. Minimum possible value for the stepper.
    public var minimumValue: Double {
        get { valueObserver.minimumValue }
        set {
            onMinimumValueChange(newValue: newValue)
        }
    }
    /// Optional maximum value. Maximum possible value for the stepper.
    public var maximumValue: Double {
        get { valueObserver.maximumValue }
        set {
            onMaximumValueChange(newValue: newValue)
        }
    }
    /// Optional step value. The step, or increment, value for the stepper.
    public var stepValue: Double {
        get { valueObserver.stepValue }
        set { valueObserver.stepValue = newValue }
    }

    /// Stepper's current value
    public var value: Double {
        get { valueObserver.value }
        set { onValueChange(newValue: newValue) }
    }
    /// Decimal digits in current value
    public var decimalPlaces: Int {
        get { valueObserver.decimalValue }
        set { valueObserver.decimalValue = newValue }
    }
    /// Initializes Stepper
    /// - Parameters:
    ///   - appearance: appearance for the stepper. Default is `.default`
    ///   - minimumValue: minimum value. Default is `0`
    ///   - maximumValue: maximum value. Default is `100`
    ///   - stepValue: Step value. Default is `1`
    ///   - value: Current value. Default is `0` or minimumValue (if provided)
    public init(
        appearance: StepperControl.Appearance = .default,
        minimumValue: Double = 0,
        maximumValue: Double = 100,
        stepValue: Double = 1,
        value: Double = 0
    ) {
        self.appearance = appearance
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.stepValue = stepValue
        self.value = (minimumValue...maximumValue).contains(value) ?
        value : minimumValue
    }
}

extension Stepper: View {
    /// :nodoc:
    public var body: some View {
            HStack(spacing: 0) {
                getDecrementButton()
                getTextView()
                getIncrementButton()
            }
            .background(
                Capsule()
                    .strokeBorder(Color(appearance.borderColor), lineWidth: appearance.borderWidth)
                    .background(Capsule().foregroundColor(Color(appearance.backgroundColor)))
            )
    }

    @ViewBuilder
    func getIncrementButton() -> some View {
        Button { buttonAction(buttonType: .increment) } label: {
            getIncrementImage()
        }
        .frame(minWidth: minimumSize.width, minHeight: minimumSize.height)
        .accessibilityLabel(StepperControl.Strings.incrementA11yButton.localized)
        .accessibilityHint(StepperControl.Strings.stepperButtonA11yHint.localized)
    }

    @ViewBuilder
    func getDecrementButton() -> some View {
        Button { buttonAction(buttonType: .decrement) } label: {
            getImageForDecrementButton()
        }
        .frame(minWidth: minimumSize.width, minHeight: minimumSize.height)
        .accessibilityLabel(StepperControl.Strings.decrementA11yButton.localized)
        .accessibilityHint(StepperControl.Strings.stepperButtonA11yHint.localized)
    }

    func getTextView() -> some View {
        let stringSize = getStringSize()
        return TextStyleLabel(
            getValueText(),
            typography: appearance.textStyle.typography
        ) { label in
            label.textAlignment = .center
        }
            .frame(minWidth: stringSize.width, minHeight: stringSize.height)
            .accessibilityLabel(StepperControl.Strings.valueA11yLabel.localized)
    }
}

extension Stepper {
    func getValueText() -> String {
        String(format: "%.\(decimalPlaces)f", value)
    }

    func updateCurrentValue(newValue: Double) {
        if newValue < valueObserver.minimumValue {
            valueObserver.value = valueObserver.minimumValue
        }

        if newValue > valueObserver.maximumValue {
            valueObserver.value = valueObserver.maximumValue
        }
        delegate?.valueDidChange(newValue: valueObserver.value)
    }

    func buttonAction(buttonType: ButtonType) {
        switch buttonType {
        case .increment:
            valueObserver.value += stepValue
        case .decrement:
            valueObserver.value -= stepValue
        }
        updateCurrentValue(newValue: valueObserver.value)
    }

    func getStringSize() -> CGSize {
        let textlabelLayout = appearance.textStyle.typography.generateLayout(compatibleWith: nil)
        let stringSize = "\(maximumValue)".sizeOfString(usingFont: textlabelLayout.font)
        return stringSize
    }
}

extension Stepper {
    func getDeleteImage() -> Image? {
        if let image = appearance.deleteImage {
            return Image(uiImage: image)
        }
        return nil
    }

    @ViewBuilder
    func getIncrementImage() -> Image {
        Image(uiImage: appearance.incrementImage)
    }

    @ViewBuilder
    func getDecrementImage() -> Image {
        Image(uiImage: appearance.decrementImage)
    }

    func getImageForDecrementButton() -> Image? {
        if appearance.hasDeleteButton
            && value <= stepValue
            && minimumValue == 0 {
            return getDeleteImage()
        }
        return getDecrementImage()
    }
}

private extension Stepper {
    func onMinimumValueChange(newValue: Double) {
        if minimumValue < maximumValue {
            valueObserver.minimumValue = newValue
            if value < minimumValue {
                valueObserver.value = minimumValue
            }
        }
    }

    func onMaximumValueChange(newValue: Double) {
        if minimumValue < maximumValue {
            valueObserver.maximumValue = newValue
        }
    }

    func onValueChange(newValue: Double) {
        if (minimumValue...maximumValue).contains(newValue) {
            valueObserver.value = newValue
        }
    }
}

struct Stepper_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer().frame(maxWidth: .infinity)
            Stepper(maximumValue: 10000, stepValue: 200, value: 99)
            Spacer().frame(maxWidth: .infinity)
        }
    }
}