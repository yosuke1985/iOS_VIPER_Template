//
//  NavigationBar.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/20.
//

import UIKit

@IBDesignable
class NavigationBar: UINavigationBar {
    let addHeight: CGFloat = 40.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        barTintColor = UIColor.blue
        tintColor = UIColor.white
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        isTranslucent = false
        
        guard let font = UIFont(name: "HiraKakuProN-W6", size: 20) else { return }
        titleTextAttributes = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
    }
}
