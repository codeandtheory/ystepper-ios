//
//  StepperControl+Appearance.swift
//  YStepper
//
//  Created by Sahil Saini on 06/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YMatterType

extension StepperControl {
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
        public var deleteImage: UIImage?
        /// Increment button image
        public var incrementImage: UIImage?
        /// Decrement button image
        public var decrementImage: UIImage?
        /// Whether to show delete button or not.
        var hasDeleteButton: Bool { deleteImage != nil }

        /// Initializer for appearance
        /// - Parameters:
        ///   - textStyle: Typography and text color for valueText label.
        ///   Default is `(UIColor.label, Typography.systemLabel)`
        ///   - foregroundColor: Foreground color for valueText. Default is `.label`
        ///   - backgroundColor: Background color for stepper view. Default is `.systemBackground`
        ///   - borderColor: Border color for stepper view. Default is `UIColor.label`
        ///   - borderWidth: Border width for day view. Default is `1.0`
        ///   - deleteImage: Delete button image. Default is `Appearance.defaultDeleteImage`
        ///   - incrementImage: Increment button image. Default is `Appearance.defaultIncrementImage`
        ///   - decrementImage: Decrement button image. Default is `Appearance.defaultDecrementImage`
        public init(
            textStyle: (textColor: UIColor, typography: Typography) = (.label, .systemLabel),
            foregroundColor: UIColor = .label,
            backgroundColor: UIColor = .systemBackground,
            borderColor: UIColor = .label,
            borderWidth: CGFloat = 1.0,
            deleteImage: UIImage? = Appearance.defaultDeleteImage,
            incrementImage: UIImage? = Appearance.defaultIncrementImage,
            decrementImage: UIImage? = Appearance.defaultDecrementImage
        ) {
            self.textStyle = textStyle
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.deleteImage = deleteImage
            self.incrementImage = incrementImage
            self.decrementImage = decrementImage
        }
    }
}

extension StepperControl.Appearance {
    ///  Default stepper appearance
    public static let `default` = StepperControl.Appearance()
    /// Default image for delete button. Is a `trash.circle` from SF Symbols in template rendering mode
    public static let defaultDeleteImage = Images.delete.image
    /// Default image for increment button. Is a `plus.circle` from SF Symbols in template rendering mode
    public static let defaultIncrementImage = Images.increment.image
    /// Default image for decrement button. Is a `minus.circle` from SF Symbols in template rendering mode
    public static let defaultDecrementImage = Images.decrement.image
}
