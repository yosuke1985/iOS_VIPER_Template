//
//  LoginBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct LoginBuilder: LoginUseCaseInjectable {
    func build() -> UIViewController {
        let vc = LoginViewController.instantiate()
        let router = LoginRouterImpl()
        let presenter = LoginPresenterImpl()
        
        router.viewController = vc
        presenter.loginRouter = router
        presenter.loginUseCase = loginUseCaseImpl
        vc.presenter = presenter
        
        return vc
    }
}
