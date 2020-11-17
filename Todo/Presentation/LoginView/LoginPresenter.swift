//
//  LoginPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

// MARK: - <P>LoginPresenterInjectable

protocol LoginPresenterInjectable {
    var loginPresenterImpl: LoginPresenter { get }
}

extension LoginPresenterInjectable {
    var loginPresenterImpl: LoginPresenter {
        return LoginPresenterImpl()
    }
}

// MARK: - <P>LoginPresenter

protocol LoginPresenter {
    var loginRouter: LoginRouter! { get set }
    var loginUseCase: LoginUseCase! { get set }
}

// MARK: - LoginPresenterImpl

final class LoginPresenterImpl: LoginPresenter {
    var loginRouter: LoginRouter!
    var loginUseCase: LoginUseCase!
}
