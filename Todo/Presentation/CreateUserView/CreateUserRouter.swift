//
//  CreateUserRouter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import UIKit

protocol CreateUserRouter: DismissTransitionable {
    var viewController: UIViewController? { get set }
}

final class CreateUserRouterImpl: CreateUserRouter {
    weak var viewController: UIViewController?
}
