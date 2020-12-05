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
    var isEnableLoginButtonRelay: Driver<Bool> { get }

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
    var _isEnableLoginButtonRelay = BehaviorRelay<Bool>(value: false)
    var isEnableLoginButtonRelay: Driver<Bool> {
        return _isEnableLoginButtonRelay.asDriver()
    }
    
    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }
    
    func setUp() {
        setBind()
    }
    
    func setBind() {
        Observable.combineLatest(emailRelay, passwordRelay)
            .compactMap { (emailText, passText) -> Bool in
                if emailText != "", passText != "" {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: _isEnableLoginButtonRelay)
            .disposed(by: bag)
        
        loginRelay
            .flatMap { [weak self] (_) -> Single<Result<Void, AuthError>> in
                guard let weakSelf = self else { return .error(CustomError.selfIsNil) }
                guard let email = weakSelf.emailRelay.value, let password = weakSelf.passwordRelay.value else {
                    return .never()
                }
                return weakSelf.authUseCase.login(email: email, password: password)
            }
            .debug()
            .subscribe(onNext: { [weak self] result in
                           guard let weakSelf = self else { return }
                           switch result {
                           case .success:
                               weakSelf.toTodoListView()
                           case let .failure(error):
                               weakSelf._showAPIErrorPopupRelay.accept(error)
                           }
                
                       },
                       onError: { _ in
                           fatalError("unexpected error")
                       })
            .disposed(by: bag)
        
        getSessionRelay
            .flatMap { [weak self] (_) -> Single<Result<Void, AuthError>> in
                guard let weakSelf = self else { return .error(CustomError.selfIsNil) }
                return weakSelf.authUseCase.getSessionUser()
            }
            .subscribe(onNext: { [weak self] result in
                           guard let weakSelf = self else { return }
                           switch result {
                           case .success:
                               weakSelf.toTodoListView()
                           case let .failure(error):
                               weakSelf._showAPIErrorPopupRelay.accept(error)
                           }
     
                       },
                       onError: { _ in
                           fatalError("unexpected error")

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
