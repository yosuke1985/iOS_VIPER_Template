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
        viewController.view.frame = rootViewController.view.frame
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { window.rootViewController = viewController },
                          completion: nil)
    }
}

protocol TodoListViewTransitionable {
    var viewController: UIViewController? { get set }

    func toTodoListView()
}

extension TodoListViewTransitionable {
    func toTodoListView() {
        let viewController = TodoListBuilder().build()
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        guard let rootViewController = window.rootViewController else { return }
        viewController.view.frame = rootViewController.view.frame
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { window.rootViewController = navigationController },
                          completion: nil)
    }
}

protocol TodoDetailViewTransitionable {
    var viewController: UIViewController? { get set }
    func toTodoDetailView()
}

extension TodoDetailViewTransitionable {
    func toTodoDetailView() {
        let vc = TodoDetailBuilder().build()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
