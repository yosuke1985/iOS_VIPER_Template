//
//  UITableViewCell+Extension.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/19.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: String(describing: `self`), bundle: nil)
    }

    static var identifier: String {
        return String(describing: `self`)
    }
}
