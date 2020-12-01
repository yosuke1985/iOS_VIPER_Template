//
//  TodoDetailBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct TodoDetailBuilder: TodoUseCaseInjectable {
    func build(todo: Todo) -> UIViewController {
        let vc = TodoDetailViewController.instantiate()
        let router = TodoDetailRouterImpl()
        let presenter = TodoDetailPresenterImpl(todo: todo)
        
        router.viewController = vc
        presenter.router = router
        presenter.todoUseCase = todoUseCaseImpl
        vc.presenter = presenter
        
        return vc
    }
}
