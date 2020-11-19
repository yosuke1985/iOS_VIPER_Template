//
//  Router.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/16.
//

import Foundation
import UIKit

protocol LoginViewTransitionable {
    var viewController: UIViewController? { get set }

    func toLoginView()
}

extension LoginViewTransitionable {
    func toLoginView() {
        let viewController = LoginBuilder().build()
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
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

protocol TodoListViewTransitionable {
    var viewController: UIViewController? { get set }

    func toTodoListView()
}

extension TodoListViewTransitionable {
    func toTodoListView() {
        let vc = TodoListBuilder().build()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
