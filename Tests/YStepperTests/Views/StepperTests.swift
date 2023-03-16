//
//  StepperTests.swift
//  YStepper
//
//  Created by Sahil Saini on 07/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YStepper

final class StepperTests: XCTestCase {
    func testBodyIsNotNil() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.body)
    }

    func testDefaultValues() {
        let sut = makeSUT()
        defaultValuesTest(sut: sut)
    }

    func testDefaultAppearance() {
        let sut = makeSUT()
        let defaultAppearance = StepperControl.Appearance.default
        XCTAssertEqual(sut.appearance.backgroundColor, defaultAppearance.backgroundColor)
        XCTAssertEqual(sut.appearance.borderWidth, defaultAppearance.borderWidth)
        XCTAssertEqual(sut.appearance.borderColor, defaultAppearance.borderColor)
        XCTAssertEqual(sut.appearance.decrementImage, defaultAppearance.decrementImage)
        XCTAssertEqual(sut.appearance.incrementImage, defaultAppearance.incrementImage)
    }

    func testCustomeAppearance() {
        let customeAppearance = StepperControl.Appearance(textStyle: (textColor: .red, typography: .systemButton))
        var sut = makeSUT(appearance: customeAppearance)

        XCTAssertEqual(sut.appearance.textStyle.textColor, customeAppearance.textStyle.textColor)
        XCTAssertTypographyEqual(sut.appearance.textStyle.typography, customeAppearance.textStyle.typography)
        sut.appearance = .default
        defaultValuesTest(sut: sut)
        sut.appearance = StepperControl.Appearance(borderColor: .red)
        XCTAssertEqual(sut.appearance.borderColor, .red)
    }

    func testUpdatedValues() {
        var sut = makeSUT()
        defaultValuesTest(sut: sut)

        let randomMinValue = Double.random(in: 0...10)
        sut.minimumValue = randomMinValue
        XCTAssertEqual(sut.minimumValue, randomMinValue)

        let randomMaxValue = Double.random(in: 10...100)
        sut.maximumValue = randomMaxValue
        XCTAssertEqual(sut.maximumValue, randomMaxValue)

        let randomStepValue = Double.random(in: 1...5)
        sut.stepValue = randomStepValue
        XCTAssertEqual(sut.stepValue, randomStepValue)

        let randomValue = Double.random(in: randomMinValue...randomMaxValue)
        sut.value = randomValue
        XCTAssertEqual(sut.value, randomValue)

        let decimalPlaces = Int.random(in: 1...5)
        sut.decimalPlaces = decimalPlaces
        XCTAssertEqual(sut.decimalPlaces, decimalPlaces)
    }

    func testGetButtonNotNil() {
        let sut = makeSUT()

        let addButton = sut.getIncrementButton()
        let subtractButton = sut.getDecrementButton()

        XCTAssertNotNil(addButton)
        XCTAssertNotNil(subtractButton)
    }

    func testUpdateCurrentValue() {
        var sut = makeSUT(minValue: 5)

        XCTAssertEqual(sut.minimumValue, 5)
        XCTAssertEqual(sut.value, 5)

        sut.value = 4
        XCTAssertEqual(sut.value, 5)

        sut.updateCurrentValue(newValue: sut.minimumValue - 1)
        XCTAssertEqual(sut.value, sut.minimumValue)

        sut.updateCurrentValue(newValue: sut.maximumValue + 1)
        XCTAssertEqual(sut.value, sut.maximumValue)
    }

    func testImagesShouldNotBeNil() {
        let sut = makeSUT(appearance: StepperControl.Appearance(
            deleteImage: StepperControl.Appearance.defaultDeleteImage
        ))

        XCTAssertNotNil(sut.getIncrementImage())
        XCTAssertNotNil(sut.getDecrementImage())
        XCTAssertNotNil(sut.getDeleteImage())
    }

    func testDeleteImageShouldBeNil() {
        let sut = makeSUT(appearance: StepperControl.Appearance(deleteImage: nil))
        XCTAssertNil(sut.getDeleteImage())

        let decrementImage = sut.getDecrementImage()

        XCTAssertEqual(decrementImage, sut.getImageForDecrementButton())
    }

    func testValueGreaterThanMaxValue() {
        let sut = makeSUT(minValue: 1, maxValue: 10, value: 11)
        XCTAssertEqual(sut.value, sut.minimumValue)
    }

    func testValueLessThanMinValue() {
        let sut = makeSUT(minValue: 1, maxValue: 10, value: -1)
        XCTAssertEqual(sut.value, sut.minimumValue)
    }

    func testImageUpdate() {
        var sut = makeSUT(appearance: StepperControl.Appearance(deleteImage: StepperControl.Images.decrement.image))
        let deleteImage = sut.getDeleteImage()
        let decrementImage = sut.getDecrementImage()
        XCTAssertEqual(sut.value, sut.minimumValue)
        XCTAssertEqual(sut.getImageForDecrementButton(), decrementImage)

        sut.value = sut.stepValue
        XCTAssertEqual(sut.getImageForDecrementButton(), deleteImage)

        sut.appearance.deleteImage = nil
        XCTAssertEqual(sut.getImageForDecrementButton(), decrementImage)
    }

    func testButtonAction() {
        let sut = makeSUT()
        XCTAssertEqual(sut.value, sut.minimumValue)
        sut.buttonAction(buttonType: .increment)
        XCTAssertEqual(sut.value, sut.minimumValue + sut.stepValue)
        sut.buttonAction(buttonType: .decrement)
        XCTAssertEqual(sut.value, sut.minimumValue)
    }

    func testBackgroundNotNil() {
        let sut = makeSUT()
        let button = sut.getDecrementButton()

        XCTAssertNotNil(button)
    }

    func testShapesNotNil() {
        var expectedAppearance = StepperControl.Appearance(shape: .rectangle)
        var sut = makeSUT(appearance: expectedAppearance)
        let rectShape = sut.getShape()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(rectShape)

        expectedAppearance = StepperControl.Appearance(shape: .roundRect(cornerRadius: 10))
        sut.appearance = expectedAppearance
        let roundedRectShape = sut.getShape()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(roundedRectShape)

        expectedAppearance = StepperControl.Appearance(shape: .scaledRoundRect(cornerRadius: 10))
        sut.appearance = expectedAppearance
        let scaledRoundRect = sut.getShape()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(scaledRoundRect)

        expectedAppearance = StepperControl.Appearance(shape: .capsule)
        sut.appearance = expectedAppearance
        let capsuleShape = sut.getShape()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(capsuleShape)

        expectedAppearance = StepperControl.Appearance(shape: .none)
        sut.appearance = expectedAppearance
        let emptyView = sut.getShape()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(emptyView)
    }

    func testShapesWithoutStrokeNotNil() {
        var expectedAppearance = StepperControl.Appearance(shape: .rectangle)
        var sut = makeSUT(appearance: expectedAppearance)
        let rectShape = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(rectShape)

        expectedAppearance = StepperControl.Appearance(shape: .roundRect(cornerRadius: 10))
        sut.appearance = expectedAppearance
        let roundedRectShape = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(roundedRectShape)

        expectedAppearance = StepperControl.Appearance(shape: .scaledRoundRect(cornerRadius: 10))
        sut.appearance = expectedAppearance
        let scaledRoundRect = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(scaledRoundRect)

        expectedAppearance = StepperControl.Appearance(shape: .capsule)
        sut.appearance = expectedAppearance
        let capsuleShape = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(capsuleShape)

        expectedAppearance = StepperControl.Appearance(shape: .none)
        sut.appearance = expectedAppearance
        let emptyView = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.shape, expectedAppearance.shape)
        XCTAssertNotNil(emptyView)
    }

    func testPreviewNotNil() {
        XCTAssertNotNil(Stepper_Previews.previews)
    }

    func testGetAccessibilityText() {
        var sut = makeSUT()
        XCTAssertEqual(sut.getAccessibilityText(), StepperControl.Strings.deleteA11yButton.localized)

        sut.appearance.deleteImage = nil
        XCTAssertEqual(sut.getAccessibilityText(), StepperControl.Strings.decrementA11yButton.localized)
    }
}

private extension StepperTests {
    func defaultValuesTest(sut: Stepper) {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.minimumValue, 0)
        XCTAssertEqual(sut.maximumValue, 100)
        XCTAssertEqual(sut.value, 0)
        XCTAssertEqual(sut.stepValue, 1)

        XCTAssertNotNil(sut.getIncrementImage())
        XCTAssertNotNil(sut.getDecrementImage())
        XCTAssertNotNil(sut.getDeleteImage())
    }
}

extension StepperTests {
    func makeSUT(
        appearance: StepperControl.Appearance = .default,
        minValue: Double = 0,
        maxValue: Double = 100,
        stepValue: Double = 1,
        value: Double = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Stepper {
        let sut = Stepper(
            appearance: appearance,
            minimumValue: minValue,
            maximumValue: maxValue,
            stepValue: stepValue,
            value: value < minValue ? minValue : value
        )
        return sut
    }
}
