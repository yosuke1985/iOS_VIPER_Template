//
//  LoginBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

class LoginBuilder {
    func build() -> UIViewController {
        let vc = LoginViewController.instantiate()
        let navigationViewController = UINavigationController(rootViewController: vc)

        return navigationViewController
    }
}
