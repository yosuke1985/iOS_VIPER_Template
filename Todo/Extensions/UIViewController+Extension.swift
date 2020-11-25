//
//  UIViewController+Extension.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/15.
//

import UIKit

extension UIViewController {
    static func instantiate() -> Self {
        let bundle = Bundle(for: `self`)
        let name = String(describing: `self`)
        return UIStoryboard(name: name, bundle: bundle).instantiateViewController(withIdentifier: name) as! Self
    }
}

extension UIViewController: UITextFieldDelegate {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
