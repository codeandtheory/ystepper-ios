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
            deleteImage: nil,
            incrementImage: nil,
            decrementImage: nil
        ))

        XCTAssertNotNil(sut.getIncrementImage())
        XCTAssertNotNil(sut.getDecrementImage())
        XCTAssertNotNil(sut.getDeleteImage())

        XCTAssertEqual(StepperControl.Appearance.defaultDeleteImage, sut.appearance.deleteImage)
        XCTAssertEqual(StepperControl.Appearance.defaultDecrementImage, sut.appearance.decrementImage)
        XCTAssertEqual(StepperControl.Appearance.defaultIncrementImage, sut.appearance.incrementImage)
    }

    func testDecrementImageshouldNotReturnDeleteImage() {
        let sut = makeSUT(appearance: StepperControl.Appearance(showDeleteImage: false))
        let decrementImage = sut.getDeleteImage()
        XCTAssertNotEqual(decrementImage, sut.getImageForDecrementButton())
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
        var sut = makeSUT(appearance: StepperControl.Appearance(showDeleteImage: false))
        let deleteImage = sut.getDeleteImage()
        let decrementImage = sut.getDecrementImage()
        XCTAssertEqual(sut.value, sut.minimumValue)
        XCTAssertEqual(sut.getImageForDecrementButton(), decrementImage)

        sut.appearance.showDeleteImage = true
        XCTAssertEqual(sut.getImageForDecrementButton(), deleteImage)
    }

    func testButtonAction() {
        let sut = makeSUT()
        XCTAssertEqual(sut.value, sut.minimumValue)
        sut.buttonAction(buttonType: .increment)
        XCTAssertEqual(sut.value, sut.minimumValue + sut.stepValue)
        sut.buttonAction(buttonType: .decrement)
        XCTAssertEqual(sut.value, sut.minimumValue)
    }

    func testShapesNotNil() {
        var expectedAppearance = StepperControl.Appearance(layout: StepperControl.Appearance.Layout(shape: .rectangle))
        var sut = makeSUT(appearance: expectedAppearance)
        let rectShape = sut.getShape()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(rectShape)

        expectedAppearance = StepperControl.Appearance(
            layout: StepperControl.Appearance.Layout(shape: .roundRect(cornerRadius: 10))
        )
        sut.appearance = expectedAppearance
        let roundedRectShape = sut.getShape()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(roundedRectShape)

        expectedAppearance = StepperControl.Appearance(
            layout: StepperControl.Appearance.Layout(shape: .scaledRoundRect(cornerRadius: 10))
        )
        sut.appearance = expectedAppearance
        let scaledRoundRect = sut.getShape()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(scaledRoundRect)

        expectedAppearance = StepperControl.Appearance(layout: StepperControl.Appearance.Layout(shape: .capsule))
        sut.appearance = expectedAppearance
        let capsuleShape = sut.getShape()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(capsuleShape)

        expectedAppearance = StepperControl.Appearance(layout: StepperControl.Appearance.Layout(shape: .none))
        sut.appearance = expectedAppearance
        let emptyView = sut.getShape()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(emptyView)
    }

    func testShapesWithoutStrokeNotNil() {
        var expectedAppearance = StepperControl.Appearance(layout: StepperControl.Appearance.Layout(shape: .rectangle))
        var sut = makeSUT(appearance: expectedAppearance)
        let rectShape = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(rectShape)

        expectedAppearance = StepperControl.Appearance(
            layout: StepperControl.Appearance.Layout(shape: .roundRect(cornerRadius: 10))
        )
        sut.appearance = expectedAppearance
        let roundedRectShape = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(roundedRectShape)

        expectedAppearance = StepperControl.Appearance(
            layout: StepperControl.Appearance.Layout(shape: .scaledRoundRect(cornerRadius: 10))
        )
        sut.appearance = expectedAppearance
        let scaledRoundRect = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(scaledRoundRect)

        expectedAppearance = StepperControl.Appearance(layout: StepperControl.Appearance.Layout(shape: .capsule))
        sut.appearance = expectedAppearance
        let capsuleShape = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(capsuleShape)

        expectedAppearance = StepperControl.Appearance(layout: StepperControl.Appearance.Layout(shape: .none))
        sut.appearance = expectedAppearance
        let emptyView = sut.getShapeWithoutStroke()

        XCTAssertEqual(sut.appearance.layout.shape, expectedAppearance.layout.shape)
        XCTAssertNotNil(emptyView)
    }

    func testPreviewNotNil() {
        XCTAssertNotNil(Stepper_Previews.previews)
    }

    func test_accessibilityIncrement_IncrementsValue() {
        let sut = makeSUT(maxValue: 2)
        sut.accessibilityAction(direction: .increment)
        sut.accessibilityAction(direction: .increment)
        XCTAssertEqual(sut.value, sut.minimumValue + 2 * sut.stepValue)
        XCTAssertEqual(sut.value, sut.maximumValue)
        sut.accessibilityAction(direction: .increment)
        // It should still just be the maximum value
        XCTAssertEqual(sut.value, sut.maximumValue)
    }

    func test_accessibilityDecrement_decrementsValue() {
        let sut = makeSUT()
        sut.accessibilityAction(direction: .increment)
        XCTAssertEqual(sut.value, sut.minimumValue + sut.stepValue)

        sut.accessibilityAction(direction: .decrement)
        XCTAssertEqual(sut.value, sut.minimumValue)

        sut.accessibilityAction(direction: .decrement)
        // It should still just be the minimum value
        XCTAssertEqual(sut.value, sut.minimumValue)
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
