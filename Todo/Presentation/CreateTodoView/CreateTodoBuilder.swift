//
//  CreateTodoBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct CreateTodoBuilder: TodoUseCaseInjectable {
    func build() -> UIViewController {
        let vc = CreateTodoViewController.instantiate()
        let router = CreateTodoRouterImpl()
        let presenter = CreateTodoPresenterImpl()
        
        router.viewController = vc
        presenter.router = router
        presenter.todoUseCase = todoUseCaseImpl
        vc.presenter = presenter
        
        return vc
    }
}
