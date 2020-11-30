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
    
    func setup()
    
    func logout()
    
    func toLoginView()
    func toTodoDetailView()
    func toCreateTodoView()
}

// MARK: - TodoListPresenterImpl

final class TodoListPresenterImpl: TodoListPresenter {
    let bag = DisposeBag()
    var router: TodoListRouter!
    var todoUseCase: TodoUseCase!
    var authUseCase: AuthUseCase!
    
    var todoTableViewRelay = BehaviorRelay<[SectionTodo]>(value: [])
    
    func setup() {
        let sections = [
            SectionTodo(header: "Genre1", items: [
                Todo(id: "id1", name: "todo1", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date()),
                Todo(id: "id1", name: "todo2", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date()),
                Todo(id: "id1", name: "todo3", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date()),
                Todo(id: "id1", name: "todo4", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date()),
                Todo(id: "id1", name: "todo5", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date())
            ])
        ]

        todoTableViewRelay.accept(sections)
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
    
    func toTodoDetailView() {
        router.toTodoDetailView()
    }
    
    func toCreateTodoView() {
        router.toCreateTodoView()
    }
}
