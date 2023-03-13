//
//  Stepper+AppearanceObserver.swift
//  YStepper
//
//  Created by Sahil Saini on 06/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation

// extension for appearance
extension Stepper {
    class AppearanceObserver: ObservableObject {
        @Published var appearance: StepperControl.Appearance

        /// initializer for theme observer
        /// - Parameter appearance: appearance object
        init(appearance: StepperControl.Appearance = .default) {
            self.appearance = appearance
        }
    }
}
