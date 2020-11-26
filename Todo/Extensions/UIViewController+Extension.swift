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
    
    func showErrorAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension UIViewController: UITextFieldDelegate {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
