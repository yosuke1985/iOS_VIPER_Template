//
//  CreateTodoPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import RxCocoa
import RxSwift

protocol CreateTodoPresenter {
    var router: CreateTodoRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
    
    func setBind()
    
    var requestCreateTodoRelay: PublishRelay<Void> { get }
    var titleInputtedText: BehaviorRelay<String> { get }
    var descriptionInputtedText: BehaviorRelay<String> { get }
    
    var showAPIErrorPopupRelay: Signal<Error> { get }
}

final class CreateTodoPresenterImpl: CreateTodoPresenter {
    var router: CreateTodoRouter!
    var todoUseCase: TodoUseCase!
    var bag = DisposeBag()

    var requestCreateTodoRelay = PublishRelay<Void>()

    var titleInputtedText = BehaviorRelay<String>(value: "")
    var descriptionInputtedText = BehaviorRelay<String>(value: "")
    
    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }

    func setBind() {
        requestCreateTodoRelay
            .flatMap { [weak self] _ -> Single<Void> in
                guard let weakSelf = self else { return Single<Void>.just(()) }
                return weakSelf.todoUseCase.add(title: weakSelf.titleInputtedText.value, description: weakSelf.descriptionInputtedText.value)
                    .andThen(Single<Void>.just(()))
            }
            .subscribe(onNext: { [weak self] in
                           self?.toLoginView()
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
