//
//  CreateTaskRouter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import UIKit

protocol CreateTaskRouter {
    var viewController: UIViewController? { get set }
}

final class CreateTaskRouterImpl: CreateTaskRouter {
    weak var viewController: UIViewController?
}
