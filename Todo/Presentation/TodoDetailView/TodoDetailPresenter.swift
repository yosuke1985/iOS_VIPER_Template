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
        todoDescriptionDidChangeRelay.accept(todo.title)
    }
    
    func setUp() {
        setBind()
    }
    
    private func setBind() {
        didBackToDetailRelay
            .flatMap { [weak self] _ -> Single<Void> in
                guard let weakSelf = self else { return Single<Void>.never() }
                if let beforeDescription = weakSelf.todoRelay.value?.description, let afterDescription = weakSelf.todoDescriptionDidChangeRelay.value, beforeDescription != afterDescription {
                    return weakSelf.todoUseCase.updateDescription(todoId: weakSelf.todoRelay.value!.id, description: afterDescription)
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
