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
    
    func createUser(email: String, password: String)
    var showAPIErrorPopupRelay: Signal<Error> { get }

    func toLoginView()
}

// MARK: - CreateUserPresenterImpl

final class CreateUserPresenterImpl: CreateUserPresenter {
    var router: CreateUserRouter!
    var authUseCase: AuthUseCase!
    let bag = DisposeBag()
    
    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }
    
    func createUser(email: String, password: String) {
        authUseCase.createUser(email: email, password: password)
            .subscribe(onSuccess: { [weak self] _ in
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
