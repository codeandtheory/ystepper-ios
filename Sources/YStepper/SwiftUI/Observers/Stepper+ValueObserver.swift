//
//  Stepper+ValueObserver.swift
//  YStepper
//
//  Created by Sahil Saini on 06/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation

// extension for appearance
extension Stepper {
    class ValueObserver: ObservableObject {
        @Published var minimumValue: Double
        @Published var maximumValue: Double
        @Published var stepValue: Double
        @Published var value: Double
        @Published var decimalValue: Int

        init(
            minimumValue: Double = 0,
            maximumValue: Double = 100,
            stepValue: Double = 1,
            value: Double = 0,
            decimalValue: Int = 0
        ) {
            self.minimumValue = minimumValue
            self.maximumValue = maximumValue
            self.stepValue = stepValue
            self.value = value
            self.decimalValue = decimalValue
        }
    }
}
