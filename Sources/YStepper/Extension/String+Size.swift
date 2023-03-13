//
//  String+Size.swift
//  YStepper
//
//  Created by Sahil Saini on 14/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit

extension String {
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
