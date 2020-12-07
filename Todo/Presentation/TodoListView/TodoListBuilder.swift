//
//  TodoListBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct TodoListBuilder: TodoUseCaseInjectable,
    AuthUseCaseInjectable
{
    func build() -> UIViewController {
        let vc = TodoListViewController.instantiate()
        let router = TodoListRouterImpl()
        let presenter = TodoListPresenterImpl()
        
        router.viewController = vc
        presenter.router = router
        presenter.todoUseCase = todoUseCaseImpl
        presenter.authUseCase = authUseCaseImpl
        vc.presenter = presenter
        
        return vc
    }
}
