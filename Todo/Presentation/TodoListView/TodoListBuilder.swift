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
        presenter.todoListRouter = router
        presenter.todoListUseCase = todoUseCaseImpl
        vc.presenter = presenter
        
        let navigationViewController = UINavigationController(rootViewController: vc)

        return navigationViewController
    }
}
