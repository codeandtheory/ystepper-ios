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
        /// The content inset from edges.
        /// Default is `{8, 16, 8, 16}`.
        public var contentInset: NSDirectionalEdgeInsets
        /// The minimum required horizontal spacing between icons and label. Default is `8.0`.
        public var gap: CGFloat

        /// Default StepperControl view layout.
        public static let `default` = Layout()

        /// Initializes a `Layout`.
        /// - Parameters:
        ///   - contentInset: content inset from edges.
        ///   - gap: horizontal spacing between icons and label.
        public init(
            contentInset: NSDirectionalEdgeInsets =
            NSDirectionalEdgeInsets(topAndBottom: 8, leadingAndTrailing: 16),
            gap: CGFloat = 8
        ) {
            self.contentInset = contentInset
            self.gap = gap
        }
    }
}
