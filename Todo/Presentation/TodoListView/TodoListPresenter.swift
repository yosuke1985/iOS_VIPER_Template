//
//  TodoListPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import RxSwift

// MARK: - <P>TodoListPresenter

protocol TodoListPresenter {
    var router: TodoListRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
    
    func logout()
    
    func toLoginView()
    func toTodoDetailView()
    func toCreateTodoView()
}

// MARK: - TodoListPresenterImpl

final class TodoListPresenterImpl: TodoListPresenter {
    let bag = DisposeBag()
    var router: TodoListRouter!
    var todoUseCase: TodoUseCase!
    var authUseCase: AuthUseCase!
    
    func logout() {
        authUseCase.logout()
            .subscribe { [weak self] in
                self?.toLoginView()
            }
            .disposed(by: bag)
    }

    func toLoginView() {
        router.toLoginView()
    }
    
    func toTodoDetailView() {
        router.toTodoDetailView()
    }
    
    func toCreateTodoView() {
        router.toCreateTodoView()
    }
}
