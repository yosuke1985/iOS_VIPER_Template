//
//  CheckBoxButton.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/20.
//

import UIKit

@IBDesignable
class CheckBoxButton: UIButton {
    let checkedImage = UIImage(named: "checkBoxTrue")
    let uncheckedImage = UIImage(named: "checkBoxFalse")
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
