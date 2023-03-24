//
//  StepperControl+Appearance+Layout.swift
//  YStepper
//
//  Created by Sahil Saini on 20/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

extension StepperControl.Appearance {
    /// A collection of layout properties for the `StepperControl`.
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

        /// Initializes a `Layout`.
        /// - Parameters:
        ///   - contentInset: content inset from edges.
        ///   - gap: horizontal spacing between icons and label.
        ///   - shape: Stepper's shape. Default is `.capsule`.
        public init(
            contentInset: NSDirectionalEdgeInsets =
            NSDirectionalEdgeInsets(topAndBottom: 8, leadingAndTrailing: 16),
            gap: CGFloat = 8,
            shape: Shape = .capsule
        ) {
            self.contentInset = contentInset
            self.gap = gap
            self.shape = shape
        }
    }
}
