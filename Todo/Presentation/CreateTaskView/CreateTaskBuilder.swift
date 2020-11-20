//
//  CreateTaskBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct CreateTaskBuilder: TodoUseCaseInjectable {
    func build() -> UIViewController {
        let vc = CreateTaskViewController.instantiate()
        let router = CreateTaskRouterImpl()
        let presenter = CreateTaskPresenterImpl()
        
        router.viewController = vc
        presenter.router = router
        presenter.todoUseCase = todoUseCaseImpl
        vc.presenter = presenter
        
        return vc
    }
}
