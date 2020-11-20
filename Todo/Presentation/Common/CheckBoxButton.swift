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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        isChecked = false
        customDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customDesign()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        customDesign()
    }
      
    private func customDesign() {
        setTitleColor(UIColor(displayP3Red: 79 / 255, green: 172 / 255, blue: 254 / 255, alpha: 1.0), for: .normal)
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
