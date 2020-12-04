//
//  CreateUserPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import RxCocoa
import RxSwift

// MARK: - <P>CreateUserPresenter

protocol CreateUserPresenter {
    var router: CreateUserRouter! { get set }
    var authUseCase: AuthUseCase! { get set }
    
    func setUp()
        
    var createUserRelay: PublishRelay<Void> { get }
    var emailRelay: BehaviorRelay<String?> { get }
    var passwordRelay: BehaviorRelay<String?> { get }
    var showAPIErrorPopupRelay: Signal<Error> { get }

    func toLoginView()
}

// MARK: - CreateUserPresenterImpl

final class CreateUserPresenterImpl: CreateUserPresenter {
    var router: CreateUserRouter!
    var authUseCase: AuthUseCase!
    let bag = DisposeBag()
    
    var createUserRelay = PublishRelay<Void>()
    var emailRelay = BehaviorRelay<String?>(value: nil)
    var passwordRelay = BehaviorRelay<String?>(value: nil)
    
    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }
    
    func setUp() {
        setBind()
    }
    
    private func setBind() {
        createUserRelay
            .flatMap { [weak self] (_) -> Single<Void> in
                guard let weakSelf = self else { return Single<Void>.never() }
                guard let email = weakSelf.emailRelay.value, let password = weakSelf.passwordRelay.value else { return Single<Void>.never() }
                return weakSelf.authUseCase.createUser(email: email, password: password)
                    .andThen(Single<Void>.just(()))
            }
            .subscribe(onNext: { [weak self] _ in
                           guard let weakSelf = self else { return }
                           weakSelf.toLoginView()
                       },
                       onError: { [weak self] error in
                           self?._showAPIErrorPopupRelay.accept(error)
                       })
            .disposed(by: bag)
    }
    
    func toLoginView() {
        router.dismiss(animated: true, completion: nil)
    }
}
