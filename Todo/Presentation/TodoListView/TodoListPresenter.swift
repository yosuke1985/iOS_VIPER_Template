//
//  TodoListPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

struct SectionTodo {
    var header: String
    var items: [Item]
}

// AnimatableSectionModelType
extension SectionTodo: AnimatableSectionModelType {
    typealias Item = Todo
    typealias Identity = String

    var identity: String {
        return header
    }
    
    init(original: SectionTodo, items: [Item]) {
        self = original
        self.items = items
    }
}

// MARK: - <P>TodoListPresenter

protocol TodoListPresenter {
    var router: TodoListRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
    var authUseCase: AuthUseCase! { get set }

    var todoTableViewRelay: BehaviorRelay<[SectionTodo]> { get }
    var willDeleteTodoRelay: PublishRelay<Todo> { get }
    
    func setup()
    func tearDown()
    
    var updateIsCheckedRelay: PublishRelay<Todo> { get }
    var logoutRelay: PublishRelay<Void> { get }
    var toTodoDetailViewRelay: PublishRelay<Todo> { get }
    var toCreateTodoViewRelay: PublishRelay<Void> { get }
    var showAPIErrorPopupRelay: Signal<Error> { get }
}

// MARK: - TodoListPresenterImpl

final class TodoListPresenterImpl: TodoListPresenter {
    let bag = DisposeBag()
    var router: TodoListRouter!
    var todoUseCase: TodoUseCase!
    var authUseCase: AuthUseCase!
    
    var todoTableViewRelay = BehaviorRelay<[SectionTodo]>(value: [])
    
    var logoutRelay = PublishRelay<Void>()
    var toTodoDetailViewRelay = PublishRelay<Todo>()
    var toCreateTodoViewRelay = PublishRelay<Void>()

    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }

    var willDeleteTodoRelay = PublishRelay<Todo>()
    var updateIsCheckedRelay = PublishRelay<Todo>()

    func setup() {
        setBind()
    }
    
    func setBind() {
        todoUseCase.startListenTodos()
            .subscribe(onSuccess: { [weak self] result in
                           guard let weakSelf = self else { return }
                           switch result {
                           case .success:
                               break
                           case let .failure(error):
                               weakSelf._showAPIErrorPopupRelay.accept(error)
                           }

                       },
                       onError: { error in
                           fatalError(error.localizedDescription)
                       })
            .disposed(by: bag)
                
        todoUseCase.todosRelay()
            .drive(todoTableViewRelay)
            .disposed(by: bag)
        
        willDeleteTodoRelay
            .flatMap { [weak self] todo -> Single<Result<Void, APIError>> in
                guard let weakSelf = self else { return .error(CustomError.selfIsNil) }
                return weakSelf.todoUseCase.delete(todo: todo)
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
                       onError: { error in
                           fatalError(error.localizedDescription)
                       })
            .disposed(by: bag)
        
        updateIsCheckedRelay
            .flatMap { [weak self] (todo) -> Single<Result<Void, APIError>> in
                guard let weakSelf = self else { return .error(CustomError.selfIsNil) }
                return weakSelf.todoUseCase.update(todo: todo)
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
                       onError: { error in
                           fatalError(error.localizedDescription)
                       })
            .disposed(by: bag)
        
        logoutRelay
            .flatMap { [weak self] (_) -> Single<Result<Void, APIError>> in
                guard let weakSelf = self else { return .error(CustomError.selfIsNil) }
                return weakSelf.authUseCase.logout()
            }
            .do(onNext: { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success:
                    weakSelf.todoUseCase.tearDown()

                case .failure:
                    break
                }
            })
            .subscribe(onNext: { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success:
                    weakSelf.router.toLoginView()
                case let .failure(error):
                    weakSelf._showAPIErrorPopupRelay.accept(error)
                }
            })
            .disposed(by: bag)
        
        toTodoDetailViewRelay
            .subscribe(onNext: { [weak self] todo in
                self?.router.toTodoDetailView(todo: todo)
            })
            .disposed(by: bag)
        
        toCreateTodoViewRelay
            .subscribe(onNext: { [weak self] _ in
                self?.router.toCreateTodoView()
            })
            .disposed(by: bag)
    }
    
    func tearDown() {
        todoUseCase.tearDown()
    }
}
