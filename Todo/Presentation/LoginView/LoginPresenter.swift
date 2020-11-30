//
//  LoginPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - <P>LoginPresenter

protocol LoginPresenter {
    var router: LoginRouter! { get set }
    var authUseCase: AuthUseCase! { get set }
    
    func getSessionUser()
    func login(email: String, password: String)
    
    var showAPIErrorPopupRelay: Signal<Error> { get }

    func toTodoListView()

    func toCreateUserView()
}

// MARK: - LoginPresenterImpl

final class LoginPresenterImpl: LoginPresenter {
    var router: LoginRouter!
    var authUseCase: AuthUseCase!
    let bag = DisposeBag()
    
    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }
    
    func getSessionUser() {
        authUseCase.getSessionUser()
            .subscribe(onSuccess: { [weak self] user in
                           if user != nil {
                               self?.toTodoListView()
                           }
                       },
                       onError: { [weak self] error in
                           self?._showAPIErrorPopupRelay.accept(error)
                       })
            .disposed(by: bag)
    }

    func login(email: String, password: String) {
        authUseCase.login(email: email, password: password)
            .subscribe(onSuccess: { [weak self] _ in
                           self?.toTodoListView()
                       },
                       onError: { [weak self] error in
                           self?._showAPIErrorPopupRelay.accept(error)
                       })
            .disposed(by: bag)
    }

    func toTodoListView() {
        router.toTodoListView()
    }
    
    func toCreateUserView() {
        router.toCreateUserView()
    }
}
