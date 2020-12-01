//
//  DescriptionTextView.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/20.
//

import UIKit

@IBDesignable
class DescriptionTextView: UITextView {
    @IBInspectable
    var cornerRadius: Float = 0.0 {
        didSet {
            self.layer.cornerRadius = 5.0
        }
    }
    
    override func awakeFromNib() {
        sizeToFit()
    }
}
