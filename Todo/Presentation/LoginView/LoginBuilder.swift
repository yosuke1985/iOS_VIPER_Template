//
//  LoginBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct LoginBuilder: AuthUseCaseInjectable {
    func build() -> UIViewController {
        let vc = LoginViewController.instantiate()
        let router = LoginRouterImpl()
        let presenter = LoginPresenterImpl()
        
        router.viewController = vc
        presenter.router = router
        presenter.authUseCase = AuthUseCaseImpl()
        vc.presenter = presenter
        
        return vc
    }
}
