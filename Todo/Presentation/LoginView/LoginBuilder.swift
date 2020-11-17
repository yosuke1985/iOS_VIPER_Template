//
//  LoginBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct LoginBuilder: LoginPresenterInjectable,
    LoginUseCaseInjectable,
    LoginRouterInjectable
{
    lazy var loginPresenter: LoginPresenter = loginPresenterImpl
    lazy var loginUseCase: LoginUseCase = loginUseCaseImpl
    lazy var loginRouter: LoginRouter = loginRouterImpl
    
    mutating func build() -> UIViewController {
        let vc = LoginViewController.instantiate()
        
        loginRouter.viewController = vc
        loginPresenter.loginRouter = loginRouter
        loginPresenter.loginUseCase = loginUseCase
        vc.presenter = loginPresenter
        
        let navigationViewController = UINavigationController(rootViewController: vc)

        return navigationViewController
    }
}
