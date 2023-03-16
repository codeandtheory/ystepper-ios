//
//  String+Size.swift
//  YStepper
//
//  Created by Sahil Saini on 14/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YCoreUI

extension String {
    func size(withFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = size(withAttributes: fontAttributes)
        return CGSize(width: size.width.ceiled(), height: size.height.ceiled())
    }
}
