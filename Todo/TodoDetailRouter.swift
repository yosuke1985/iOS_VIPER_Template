//
//  TodoDetailRouter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import UIKit

protocol TodoDetailRouter {
    var viewController: UIViewController? { get set }
}

final class TodoDetailRouterImpl: TodoDetailRouter {
    weak var viewController: UIViewController?
}
