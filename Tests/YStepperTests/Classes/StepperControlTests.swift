//
//  StepperControlTests.swift
//  YStepper
//
//  Created by Sahil Saini on 07/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import XCTest
@testable import YStepper

final class StepperControlTests: XCTestCase {
    func test_initWithCoder() throws {
        XCTAssertNotNil(makeSUTWithFailable())
    }

    func testDefaultValues() {
        let sut = makeSUT()
        testDefaultValues(sut: sut)
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

    func test_renderMode_deliversCorrectMode() {
        StepperControl.Images.allCases.forEach {
            XCTAssertEqual($0.image.renderingMode, .alwaysTemplate)
        }
    }

    func testCustomeAppearance() {
        let customeAppearance = StepperControl.Appearance(textStyle: (textColor: .red, typography: .systemButton))
        let sut = makeSUT(appearance: customeAppearance)

        XCTAssertEqual(sut.appearance.textStyle.textColor, customeAppearance.textStyle.textColor)
        XCTAssertTypographyEqual(sut.appearance.textStyle.typography, customeAppearance.textStyle.typography)

        sut.appearance = .default

        testDefaultValues(sut: sut)

        sut.appearance = StepperControl.Appearance(borderColor: .red)

        XCTAssertEqual(sut.appearance.borderColor, .red)
    }

    func testUpdatedValues() {
        let sut = makeSUT()
        testDefaultValues(sut: sut)

        let randomMinValue = Double.random(in: 0...10)
        sut.minimumValue = randomMinValue
        XCTAssertEqual(sut.minimumValue, randomMinValue)

        let randomMaxValue = Double.random(in: randomMinValue...100)
        sut.maximumValue = randomMaxValue
        XCTAssertEqual(sut.maximumValue, randomMaxValue)

        sut.value = 200
        XCTAssertLessThanOrEqual(sut.value, randomMaxValue)

        let randomStepValue = Double.random(in: 1...5)
        sut.stepValue = randomStepValue
        XCTAssertEqual(sut.stepValue, randomStepValue)

        let randomValue = Double.random(in: randomMinValue...randomMaxValue)
        sut.value = randomValue
        XCTAssertGreaterThanOrEqual(sut.value, sut.minimumValue)

        let decimalPlaces = Int.random(in: 1...5)
        sut.decimalPlaces = decimalPlaces
        XCTAssertEqual(sut.decimalPlaces, decimalPlaces)
    }

    func testValueChangeDelegate() {
        let sut = makeSUT(value: 2)
        sut.valueDidChange(newValue: 3)
        XCTAssertEqual(sut.value, 3)
    }
}

private extension StepperControlTests {
    func testDefaultValues(sut: StepperControl) {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.minimumValue, 0)
        XCTAssertEqual(sut.maximumValue, 100)
        XCTAssertEqual(sut.value, 0)
        XCTAssertEqual(sut.stepValue, 1)
    }
}

private extension StepperControlTests {
    func makeSUT(
        appearance: StepperControl.Appearance = .default,
        minValue: Double = 0,
        maxValue: Double = 100,
        stepValue: Double = 1,
        value: Double = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> StepperControl {
        let sut = StepperControl(
            appearance: appearance,
            minimumValue: minValue,
            maximumValue: maxValue,
            stepValue: stepValue,
            value: value < minValue ? minValue : value
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    func makeSUTWithFailable(
        firstWeekday: Int? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> StepperControl? {
        let sut = StepperControl()
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: sut, requiringSecureCoding: false) else {
            return nil
        }
        guard let coder = try? NSKeyedUnarchiver(forReadingFrom: data) else { return nil }
        trackForMemoryLeaks(sut, file: file, line: line)
        return StepperControl(coder: coder)
    }
}
