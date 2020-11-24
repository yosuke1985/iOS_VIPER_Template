//
//  LoginPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

// MARK: - <P>LoginPresenter

protocol LoginPresenter {
    var router: LoginRouter! { get set }
    var authUseCase: AuthUseCase! { get set }
    
    func toTodoListView()
    
    func toCreateUserView()
}

// MARK: - LoginPresenterImpl

final class LoginPresenterImpl: LoginPresenter {
    var router: LoginRouter!
    var authUseCase: AuthUseCase!
    
    func toTodoListView() {
        router.toTodoListView()
    }
    
    func toCreateUserView() {
        router.toCreateUserView()
    }
}
