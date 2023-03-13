//
//  YStepper+Images.swift
//  YStepper
//
//  Created by Sahil Saini on 07/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YCoreUI

/// Collection of Images
enum Images: String, CaseIterable {
    case increment = "plus"
    case decrement = "minus"
    case delete = "trash"
}

extension Images: ImageAsset {
    func loadImage() -> UIImage? {
        UIImage(systemName: rawValue)
    }
}
