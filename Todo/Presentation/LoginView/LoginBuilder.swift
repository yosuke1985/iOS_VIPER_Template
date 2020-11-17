//
//  LoginBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

class LoginBuilder: LoginPresenterInjectable,
    LoginUseCaseInjectable,
    LoginRouterInjectable
{
    lazy var loginPresenter: LoginPresenter = loginPresenterImpl
    lazy var loginUseseCase: LoginUseCase = loginUseCaseImpl
    lazy var loginRouter: LoginRouter = loginRouterImpl
    
    func build() -> UIViewController {
        let vc = LoginViewController.instantiate()
        
        loginRouter.viewController = vc
        loginPresenter.loginRouter = loginRouter
        loginPresenter.loginUseCase = loginUseseCase
        vc.presenter = loginPresenter
        
        let navigationViewController = UINavigationController(rootViewController: vc)

        return navigationViewController
    }
}
