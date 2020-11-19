//
//  LoginPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

// MARK: - <P>LoginPresenter

protocol LoginPresenter {
    var loginRouter: LoginRouter! { get set }
    var loginUseCase: LoginUseCase! { get set }
    
    func toTodoListView()
}

// MARK: - LoginPresenterImpl

final class LoginPresenterImpl: LoginPresenter {
    var loginRouter: LoginRouter!
    var loginUseCase: LoginUseCase!
    
    func toTodoListView() {
        loginRouter.toTodoListView()
    }
}
