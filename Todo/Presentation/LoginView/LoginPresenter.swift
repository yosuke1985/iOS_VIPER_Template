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
    
    func setUp()
    
    var getSessionRelay: PublishRelay<Void> { get }
    var loginRelay: PublishRelay<Void> { get }
    var emailRelay: BehaviorRelay<String?> { get }
    var passwordRelay: BehaviorRelay<String?> { get }
    
    var showAPIErrorPopupRelay: Signal<Error> { get }

    func toTodoListView()

    func toCreateUserView()
}

// MARK: - LoginPresenterImpl

final class LoginPresenterImpl: LoginPresenter {
    var router: LoginRouter!
    var authUseCase: AuthUseCase!
    let bag = DisposeBag()
    
    var getSessionRelay = PublishRelay<Void>()
    var loginRelay = PublishRelay<Void>()
    var emailRelay = BehaviorRelay<String?>(value: nil)
    var passwordRelay = BehaviorRelay<String?>(value: nil)
    
    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }
    
    func setUp() {
        setBind()
    }
    
    func setBind() {
        loginRelay
            .flatMap { [weak self] (_) -> Single<Void> in
                guard let weakSelf = self else { return Single<Void>.error(CustomError.selfIsNil) }
                guard let email = weakSelf.emailRelay.value, let password = weakSelf.passwordRelay.value else {
                    return Single<Void>.never()
                }
                return weakSelf.authUseCase.login(email: email, password: password)
                    .andThen(Single<Void>.just(()))
            }
            .subscribe(onNext: { [weak self] _ in
                           guard let weakSelf = self else { return }
                           weakSelf.toTodoListView()
                       },
                       onError: { [weak self] error in
                           self?._showAPIErrorPopupRelay.accept(error)
                       })
            .disposed(by: bag)
        
        getSessionRelay
            .flatMap { [weak self] (_) -> Single<Void> in
                guard let weakSelf = self else { return Single<Void>.error(CustomError.selfIsNil) }
                return weakSelf.authUseCase.getSessionUser()
                    .andThen(Single<Void>.just(()))
            }
            .subscribe(onNext: { [weak self] _ in
                           guard let weakSelf = self else { return }
                           weakSelf.toTodoListView()
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
