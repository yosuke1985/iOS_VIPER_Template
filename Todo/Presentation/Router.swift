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

protocol CreateUserViewTransitionable {
    var viewController: UIViewController? { get set }
    func toCreateUserView()
}

extension CreateUserViewTransitionable {
    func toCreateUserView() {
        let vc = CreateUserBuilder().build()
        viewController?.present(vc, animated: true, completion: nil)
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
        let navi = NavigationController(rootVC: viewController, naviBarClass: NavigationBar.self, toolbarClass: nil)
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { window.rootViewController = navi },
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

protocol CreateTodoViewTransitionable {
    var viewController: UIViewController? { get set }
    func toTodoDetailView()
}

extension CreateTodoViewTransitionable {
    func toCreateTodoView() {
        let vc = CreateTodoBuilder().build()
        viewController?.present(vc, animated: true, completion: nil)
    }
}

protocol DismissTransitionable {
    var viewController: UIViewController? { get set }
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension DismissTransitionable {
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        viewController?.dismiss(animated: animated, completion: completion)
    }
}
