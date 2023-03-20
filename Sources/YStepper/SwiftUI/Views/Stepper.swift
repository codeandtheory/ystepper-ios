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
    @Environment(\.sizeCategory) var sizeCategory

    @ScaledMetric var scale = 1.0
    @ObservedObject private var appearanceObserver = Stepper.AppearanceObserver()
    @ObservedObject private var valueObserver = Stepper.ValueObserver()

    var isIncrementDisabled: Bool {
        value >= maximumValue
    }
    var isDecrmentDisabled: Bool {
        value <= minimumValue
    }
    
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

    /// Minimum value. Minimum possible value for the stepper.
    public var minimumValue: Double {
        get { valueObserver.minimumValue }
        set {
            onMinimumValueChange(newValue: newValue)
        }
    }

    /// Maximum value. Maximum possible value for the stepper.
    public var maximumValue: Double {
        get { valueObserver.maximumValue }
        set {
            onMaximumValueChange(newValue: newValue)
        }
    }

    /// Step value. The step, or increment, value for the stepper.
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

    /// Initializes a stepper view.
    /// - Parameters:
    ///   - appearance: appearance for the stepper. Default is `.default`
    ///   - minimumValue: minimum value. Default is `0`
    ///   - maximumValue: maximum value. Default is `100`
    ///   - stepValue: Step value. Default is `1`
    ///   - value: Current value. Default is `0` or minimumValue
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
        HStack(spacing: appearance.layout.gap) {
            getDecrementButton()
            getTextView()
            getIncrementButton()
        }
        .padding(EdgeInsets(appearance.layout.contentInset))
        .background(
            getShape()
                .background(getShapeWithoutStroke().foregroundColor(Color(appearance.backgroundColor)))
        )
    }

    @ViewBuilder
    func getIncrementButton() -> some View {
        Button { buttonAction(buttonType: .increment) } label: {
            getIncrementImage().renderingMode(.template)
                .foregroundColor(
                    isIncrementDisabled ?
                    Color(appearance.textStyle.textColor).opacity(0.5) : Color(appearance.textStyle.textColor)
                )
        }
        .accessibilityLabel(StepperControl.Strings.incrementA11yButton.localized)
        .disabled(isIncrementDisabled)
    }

    @ViewBuilder
    func getDecrementButton() -> some View {
        Button { buttonAction(buttonType: .decrement) } label: {
            getImageForDecrementButton()?.renderingMode(.template)
                .foregroundColor(
                    isDecrmentDisabled ?
                    Color(appearance.textStyle.textColor).opacity(0.5) : Color(appearance.textStyle.textColor)
                )
        }
        .accessibilityLabel(getAccessibilityText())
        .disabled(isDecrmentDisabled)
    }

    func getTextView() -> some View {
        TextStyleLabel(
            getValueText(),
            typography: appearance.textStyle.typography
        ) { label in
            label.textAlignment = .center
            label.numberOfLines = 1
            label.textColor = appearance.textStyle.textColor
        }
        .frame(width: getStringSize(sizeCategory).width)
        .accessibilityLabel(getAccessibilityLabelText())
    }
    
    @ViewBuilder
    func getShape() -> some View {
        switch appearance.layout.shape {
        case .none:
            EmptyView()
        case .rectangle:
            Rectangle().strokeBorder(Color(appearance.borderColor), lineWidth: appearance.borderWidth)
        case .roundRect(cornerRadius: let cornerRadius):
            RoundedRectangle(
                cornerSize: CGSize(
                    width: cornerRadius,
                    height: cornerRadius
                )
            ).strokeBorder(Color(appearance.borderColor), lineWidth: appearance.borderWidth)
        case .scaledRoundRect(cornerRadius: let cornerRadius):
                RoundedRectangle(
                    cornerSize: CGSize(
                        width: cornerRadius * scale,
                        height: cornerRadius * scale
                    )
                ).strokeBorder(Color(appearance.borderColor), lineWidth: appearance.borderWidth)
        case .capsule:
            Capsule().strokeBorder(Color(appearance.borderColor), lineWidth: appearance.borderWidth)
        }
    }

    @ViewBuilder
    func getShapeWithoutStroke() -> some View {
        switch appearance.layout.shape {
        case .none:
            EmptyView()
        case .rectangle:
            Rectangle()
        case .roundRect(cornerRadius: let cornerRadius):
            RoundedRectangle(
                cornerSize: CGSize(
                    width: cornerRadius,
                    height: cornerRadius
                )
            )
        case .scaledRoundRect(cornerRadius: let cornerRadius):
                RoundedRectangle(
                    cornerSize: CGSize(
                        width: cornerRadius * scale,
                        height: cornerRadius * scale
                    )
                )
        case .capsule:
            Capsule()
        }
    }
}

extension Stepper {
    enum ButtonType {
        case increment
        case decrement
    }

    func getValueText() -> String {
        formatText(for: value)
    }

    func formatText(for value: Double) -> String {
        String(format: "%.\(decimalPlaces)f", value)
    }

    func getAccessibilityText() -> String {
        if appearance.showDeleteImage
            && value <= stepValue
            && minimumValue == 0 {
            return StepperControl.Strings.deleteA11yButton.localized
        }
        return StepperControl.Strings.decrementA11yButton.localized
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

    func getStringSize(_ size: ContentSizeCategory) -> CGSize {
        let traits = UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory(size))
        let layout = appearance.textStyle.typography.generateLayout(compatibleWith: traits)
        let valueSize = getValueText().size(withFont: layout.font)
        let maxSize = formatText(for: maximumValue).size(withFont: layout.font)
        return CGSize(
            width: max(valueSize.width, maxSize.width),
            height: max(valueSize.height, layout.lineHeight)
        )
    }

    func getAccessibilityLabelText() -> String {
        StepperControl.Strings.valueA11yLabel.localized + getValueText()
    }
}

extension Stepper {
    func getDeleteImage() -> Image {
            Image(uiImage: appearance.deleteImage)
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
        if appearance.showDeleteImage
            && value <= stepValue
            && minimumValue == 0 {
            return getDeleteImage()
        }
        return getDecrementImage()
    }
}

private extension Stepper {
    func onMinimumValueChange(newValue: Double) {
        if newValue < maximumValue {
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
        Stepper()
    }
}
