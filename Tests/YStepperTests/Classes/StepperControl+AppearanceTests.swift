//
//  StepperControl+AppearanceTests.swift
//  YStepper
//
//  Created by Sahil Saini on 08/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
import YCoreUI
@testable import YStepper

final class StepperControlAppearanceTests: XCTestCase {
    func testValueTextContrast() {
        let sut = makeSUT()
        _test(color1: sut.textStyle.textColor, color2: sut.backgroundColor)
    }
}

private extension StepperControlAppearanceTests {
    func makeSUT() -> StepperControl.Appearance {
        StepperControl.Appearance.default
    }

    func _test(
        color1: UIColor,
        color2: UIColor,
        context: WCAGContext = .normalText,
        level: WCAGLevel = .AA
    ) {
        for traits in UITraitCollection.allColorSpaces {
            _test(traits: traits, color1: color1, color2: color2, context: context, level: level)
        }
    }

    func _test(
        traits: UITraitCollection,
        color1: UIColor,
        color2: UIColor,
        context: WCAGContext = .normalText,
        level: WCAGLevel
    ) {
        var color1 = color1.resolvedColor(with: traits)
        let color2 = color2.resolvedColor(with: traits)
        let alpha1 = color1.rgbaComponents.alpha
        XCTAssertGreaterThan(alpha1, 0.0, "Color 1 must not be clear.")
        XCTAssertEqual(color2.rgbaComponents.alpha, 1.0, "Color 2 must not be opaque.")

        if alpha1 < 1.0 {
            // if color1 is partially transparent, blend it with color2 before evaluating
            color1 = color2.blended(by: alpha1, with: color1)
        }

        XCTAssertTrue(
            color1.isSufficientContrast(to: color2, context: context, level: level),
            String(
                format: "#%@ vs #%@ ratio = %.02f under %@ Mode%@",
                color1.rgbDisplayString(),
                color2.rgbDisplayString(),
                color1.contrastRatio(to: color2),
                traits.userInterfaceStyle == .dark ? "Dark" : "Light",
                traits.accessibilityContrast == .high ? " Increased Contrast" : ""
            )
        )
    }
}

extension UIColor {
    var isClear: Bool {
        self == UIColor.clear
    }
}

extension UITraitCollection {
    /// Trait collections with high contrast
    /// 1. Light Mode x High Contrast
    /// 2. Dark Mode x High Contrast
    static let highContrastColorSpaces: [UITraitCollection] = [
        UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: .light),
            UITraitCollection(accessibilityContrast: .high)
        ]),
        UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: .dark),
            UITraitCollection(accessibilityContrast: .high)
        ])
    ]
}
