//
//  TodoDetailPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import RxCocoa
import RxSwift

protocol TodoDetailPresenter {
    var router: TodoDetailRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
    
    func setUp()
    var todoRelay: BehaviorRelay<Todo?> { get }
    var todoDescriptionDidChangeRelay: BehaviorRelay<String?> { get }
    var didBackToDetailRelay: PublishRelay<Void> { get }
    
    var showAPIErrorPopupRelay: Signal<Error> { get }
}

final class TodoDetailPresenterImpl: TodoDetailPresenter {
    var router: TodoDetailRouter!
    var todoUseCase: TodoUseCase!
    var bag = DisposeBag()

    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }

    var todoRelay = BehaviorRelay<Todo?>(value: nil)
    var todoDescriptionDidChangeRelay = BehaviorRelay<String?>(value: nil)
    var didBackToDetailRelay = PublishRelay<Void>()

    init(todo: Todo) {
        todoRelay.accept(todo)
    }
    
    func setUp() {
        setBind()
    }
    
    private func setBind() {
        todoDescriptionDidChangeRelay
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] description in
                var todo = self?.todoRelay.value
                todo?.description = description
                self?.todoRelay.accept(todo)
            })
            .disposed(by: bag)

        didBackToDetailRelay
            .flatMap { [weak self] _ -> Single<Void> in
                guard let weakSelf = self else { return Single<Void>.error(CustomError.selfIsNil) }
                if let todo = weakSelf.todoRelay.value {
                    return weakSelf.todoUseCase.update(todo: todo)
                        .andThen(Single<Void>.just(()))
                }
                return Single<Void>.never()
            }
            .subscribe(onError: { [weak self] error in
                self?._showAPIErrorPopupRelay.accept(error)
            }
            )
            .disposed(by: bag)
    }
}
