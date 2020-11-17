//
//  TodoListBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct TodoListBuilder: TodoListPresenterInjectable,
    TodoUseCaseInjectable,
    TodoListRouterInjectable
{
    lazy var todoListPresenter: TodoListPresenter = todoListPresenterImpl
    lazy var todoUseCase: TodoUseCase = todoUseCaseImpl
    lazy var todoListRouter: TodoListRouter = todoListRouterImpl
    
    mutating func build() -> UIViewController {
        let vc = TodoListViewController.instantiate()
        
        todoListRouter.viewController = vc
        todoListPresenter.todoListRouter = todoListRouter
        todoListPresenter.todoListUseCase = todoUseCase
        vc.presenter = todoListPresenter
        
        let navigationViewController = UINavigationController(rootViewController: vc)

        return navigationViewController
    }
}
