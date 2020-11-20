//
//  UIViewController+Extension.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/15.
//

import UIKit

extension UIViewController: StoryboardInstantiatable {}

protocol StoryboardInstantiatable {}

extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        let bundle = Bundle(for: `self`)
        let name = String(describing: `self`)
        return UIStoryboard(name: name, bundle: bundle).instantiateViewController(withIdentifier: name) as! Self
    }
}
