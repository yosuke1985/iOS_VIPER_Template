//
//  LoginRouter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import UIKit

protocol LoginRouterInjectable {
    var loginRouterImpl: LoginRouter { get }
}

extension LoginRouterInjectable {
    var loginRouterImpl: LoginRouter {
        return LoginRouterImpl()
    }
}

protocol LoginRouter
//    :TodoListTransitionable,
{
    var viewController: UIViewController? { get set }
}

final class LoginRouterImpl: LoginRouter {
    weak var viewController: UIViewController?
}
