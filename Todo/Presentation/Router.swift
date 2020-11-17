//
//  Router.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/16.
//

import Foundation
import UIKit

protocol LoginTransitionable {
    var viewController: UIViewController? { get set }

    func toLogin()
}

extension LoginTransitionable {
    func toLogin() {
        let viewController = LoginViewController.instantiate()
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let rootViewController = window.rootViewController else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.view.frame = rootViewController.view.frame
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { window.rootViewController = navigationController },
                          completion: nil)
    }
}
