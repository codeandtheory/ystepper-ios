//
//  YStepper+Shapes.swift
//  YStepper
//
//  Created by Sahil Saini on 15/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

extension StepperControl.Appearance {
    /// Stepper's shape.
    public enum Shape: Equatable {
        /// None
        case none
        /// Rectangle
        case rectangle
        /// Rounded rectangle
        case roundRect(cornerRadius: CGFloat)
        /// Rounded rectangle that scales with Dynamic Type.
        case scaledRoundRect(cornerRadius: CGFloat)
        /// Capsule
        case capsule
    }
}
