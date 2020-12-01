//
//  CreateTodoRouter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import UIKit

protocol CreateTodoRouter: DismissTransitionable {
    var viewController: UIViewController? { get set }
}

final class CreateTodoRouterImpl: CreateTodoRouter {
    weak var viewController: UIViewController?
}
