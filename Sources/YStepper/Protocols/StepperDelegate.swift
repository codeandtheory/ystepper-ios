//
//  StepperDelegate.swift
//  YStepper
//
//  Created by Sahil Saini on 07/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation

/// Observes `Stepper` actions
public protocol StepperDelegate: AnyObject {
    /// This method is used to inform when there is a change in value.
    /// - Parameter newValue: new value
    func valueDidChange(newValue: Double)
}
