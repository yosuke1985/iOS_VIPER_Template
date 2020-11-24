//
//  CreateUserPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

// MARK: - <P>CreateUserPresenter

protocol CreateUserPresenter {
    var router: CreateUserRouter! { get set }
    var authUseCase: AuthUseCase! { get set }
    
    func toLoginView()
}

// MARK: - CreateUserPresenterImpl

final class CreateUserPresenterImpl: CreateUserPresenter {
    var router: CreateUserRouter!
    var authUseCase: AuthUseCase!
    
    func toLoginView() {
        router.dismiss(animated: true, completion: nil)
    }
}
