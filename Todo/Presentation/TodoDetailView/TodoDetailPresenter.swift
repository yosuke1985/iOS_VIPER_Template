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
    var initialTodo: Todo

    init(todo: Todo) {
        todoRelay.accept(todo)
        initialTodo = todo
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
            .flatMap { [weak self] _ -> Single<Result<Void, APIError>> in
                guard let weakSelf = self else { return .error(CustomError.selfIsNil) }
                if let todo = weakSelf.todoRelay.value, weakSelf.initialTodo.description != todo.description {
                    return weakSelf.todoUseCase.update(todo: todo)
                }
                return .never()
            }
            .subscribe(onNext: { [weak self] result in
                           guard let weakSelf = self else { return }
                           switch result {
                           case .success:
                               break
                           case let .failure(error):
                               weakSelf._showAPIErrorPopupRelay.accept(error)
                           }

                       },
                       onError: { _ in
                           fatalError("unexpected error")
                       })
            .disposed(by: bag)
    }
}
