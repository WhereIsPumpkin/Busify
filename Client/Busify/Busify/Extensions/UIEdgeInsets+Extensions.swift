//
//  UIEdgeInsets+Extensions.swift
//  iNet
//
//  Created by Saba Gogrichiani on 25.01.24.
//

import UIKit

extension UIEdgeInsets {
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
