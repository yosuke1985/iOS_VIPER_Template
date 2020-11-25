//
//  InputFieldView.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/24.
//

import UIKit

@IBDesignable
class InputFieldView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBInspectable var fieldTitle: String = "" {
        didSet {
            titleLabel.text = fieldTitle
        }
    }
    
    @IBInspectable var fieldTextColor: UIColor = .white {
        didSet {
            titleLabel.textColor = fieldTextColor
        }
    }
    
    @IBInspectable var viewBackgroundColor: UIColor = .clear {
        didSet {
            backgroundColor = viewBackgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    private func loadNib() {
        let view = Bundle(for: type(of: self)).loadNibNamed(typeString, owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
        backgroundColor = .clear
    }
}
