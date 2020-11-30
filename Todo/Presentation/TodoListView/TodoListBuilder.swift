//
//  TodoListBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct TodoListBuilder: TodoUseCaseInjectable {
    func build() -> UIViewController {
        let vc = TodoListViewController.instantiate()
        let router = TodoListRouterImpl()
        let presenter = TodoListPresenterImpl()
        
        router.viewController = vc
        presenter.router = router
        presenter.todoUseCase = todoUseCaseImpl
        presenter.authUseCase = AuthUseCaseImpl()
        vc.presenter = presenter
        
        return vc
    }
}
