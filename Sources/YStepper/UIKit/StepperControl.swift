//
//  StepperControl.swift
//  YStepper
//
//  Created by Sahil Saini on 06/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation
import YCoreUI
import SwiftUI

/// A UIKit stepper control.
@objcMembers
open class StepperControl: UIControl {
    var stepperView: Stepper

    /// Stepper appearance
    public var appearance: StepperControl.Appearance {
        get {
            stepperView.appearance
        }
        set {
            stepperView.appearance = newValue
        }
    }
    /// Optional minimum value. Minimum possible value for the stepper.
    public var minimumValue: Double {
        get { stepperView.minimumValue }
        set { stepperView.minimumValue = newValue }
    }
    /// Optional maximum value. Maximum possible value for the stepper.
    public var maximumValue: Double {
        get { stepperView.maximumValue }
        set { stepperView.maximumValue = newValue }
    }
    /// Optional step value. The step, or increment, value for the stepper.
    public var stepValue: Double {
        get { stepperView.stepValue }
        set { stepperView.stepValue = newValue }
    }
    /// Stepper's current value
    public var value: Double {
        get { stepperView.value }
        set { stepperView.value = newValue }
    }
    /// Decimal places visible in current value.
    public var decimalPlaces: Int {
        get { stepperView.decimalPlaces }
        set { stepperView.decimalPlaces = newValue }
    }

    /// Initializes a stepper control.
    /// - Parameters:
    ///   - appearance: appearance for the stepper. Default is `.default`.
    ///   - minimumValue: minimum value. Default is `0`.
    ///   - maximumValue: maximum value. Default is `100`.
    ///   - stepValue: Step value. Default is `1`.
    ///   - value: Current value. Default is `0` or minimumValue (if provided).
    public required init(
        appearance: StepperControl.Appearance = .default,
        minimumValue: Double = 0,
        maximumValue: Double = 100,
        stepValue: Double = 1,
        value: Double = 0
    ) {
        stepperView = Stepper(
            appearance: appearance,
            minimumValue: minimumValue,
            maximumValue: maximumValue,
            stepValue: stepValue,
            value: value
            )
        super.init(frame: .zero)
        addStepperView()
    }

    /// :nodoc:
    public required init?(coder: NSCoder) {
        stepperView = Stepper()
        super.init(coder: coder)
        addStepperView()
    }
}

extension StepperControl {
    /// Collection of Images
    enum Images: String, CaseIterable, SystemImage {
        case increment = "plus"
        case decrement = "minus"
        case delete = "trash"

        public static var renderingMode: UIImage.RenderingMode { .alwaysTemplate }
    }
}

extension StepperControl: StepperDelegate {
    /// This method is used to inform when there is a change in value.
    /// - Parameter value: new value
    public func valueDidChange(newValue: Double) {
        value = newValue
        sendActions(for: .valueChanged)
    }
}

private extension StepperControl {
    func addStepperView() {
        stepperView.delegate = self
        let hostController = UIHostingController(rootView: stepperView)
        hostController.view.backgroundColor = .clear
        addSubview(hostController.view)
        hostController.view.constrainEdges()
    }
}
