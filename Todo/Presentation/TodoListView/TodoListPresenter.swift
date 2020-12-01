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
    
    var todoTableViewRelay: BehaviorRelay<[SectionTodo]> { get }
    var deletedTodoRelay: PublishRelay<IndexPath> { get }
    
    func setup()
    func tearDown()
    
    func logout()
    
    func toLoginView()
    func toTodoDetailView(todo: Todo)
    func toCreateTodoView()
    
    var showAPIErrorPopupRelay: Signal<Error> { get }
}

// MARK: - TodoListPresenterImpl

final class TodoListPresenterImpl: TodoListPresenter {
    let bag = DisposeBag()
    var router: TodoListRouter!
    var todoUseCase: TodoUseCase!
    var authUseCase: AuthUseCase!
    
    var todoTableViewRelay = BehaviorRelay<[SectionTodo]>(value: [])
    private let _showAPIErrorPopupRelay = PublishRelay<Error>()
    var showAPIErrorPopupRelay: Signal<Error> {
        return _showAPIErrorPopupRelay.asSignal()
    }

    var deletedTodoRelay = PublishRelay<IndexPath>()

    func setup() {
        todoUseCase.startListenTodos()
            .subscribe(onError: { [weak self] error in
                self?._showAPIErrorPopupRelay.accept(error)
            })
            .disposed(by: bag)
                
        todoUseCase.todosRelay()
            .drive(todoTableViewRelay)
            .disposed(by: bag)
        
        deletedTodoRelay
            .subscribe(onNext: { indexPath in
                print("indexPath", indexPath)
            })
            .disposed(by: bag)
    }
    
    func tearDown() {
        todoUseCase.tearDown()
    }

    func logout() {
        authUseCase.logout()
            .subscribe { [weak self] in
                self?.toLoginView()
            }
            .disposed(by: bag)
    }

    func toLoginView() {
        router.toLoginView()
    }
    
    func toTodoDetailView(todo: Todo) {
        router.toTodoDetailView(todo: todo)
    }
    
    func toCreateTodoView() {
        router.toCreateTodoView()
    }
}
