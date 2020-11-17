//
//  TodoListRouter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import UIKit

protocol TodoListRouterInjectable {
    var todoListRouterImpl: TodoListRouter { get }
}

extension TodoListRouterInjectable {
    var todoListRouterImpl: TodoListRouter {
        return TodoListRouterImpl()
    }
}

protocol TodoListRouter
//    :TodoListTransitionable,
{
    var viewController: UIViewController? { get set }
}

final class TodoListRouterImpl: TodoListRouter {
    weak var viewController: UIViewController?
}
