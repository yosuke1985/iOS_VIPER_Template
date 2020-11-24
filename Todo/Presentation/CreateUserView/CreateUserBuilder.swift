//
//  CreateUserBuilder.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import UIKit

struct CreateUserBuilder: AuthUseCaseInjectable {
    func build() -> UIViewController {
        let vc = CreateUserViewController.instantiate()
        let router = CreateUserRouterImpl()
        let presenter = CreateUserPresenterImpl()
        
        router.viewController = vc
        presenter.router = router
        presenter.authUseCase = AuthUseCaseImpl()
        vc.presenter = presenter
        
        return vc
    }
}
