//
//  CheckBoxButton.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/20.
//

import UIKit

@IBDesignable
class CheckBoxButton: UIButton {
    var isChecked: Bool? {
        didSet {
            let bundle = Bundle(for: CheckBoxButton.self)
            let checkedImage = UIImage(named: "checkBoxTrue", in: bundle, compatibleWith: nil)
            let uncheckedImage = UIImage(named: "checkBoxFalse", in: bundle, compatibleWith: nil)
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked!
        }
    }
}
