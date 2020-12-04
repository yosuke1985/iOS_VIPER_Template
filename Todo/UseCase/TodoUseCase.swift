//
//  TodoUseCase.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

import RxCocoa
import RxSwift

protocol TodoUseCaseInjectable {
    var todoUseCaseImpl: TodoUseCase { get }
}

extension TodoUseCaseInjectable {
    var todoUseCaseImpl: TodoUseCase {
        return TodoUseCaseImpl()
    }
}

protocol TodoUseCase {
    func startListenTodos() -> Completable
    func todosRelay() -> Driver<[SectionTodo]>
    func tearDown()
    func add(title: String, description: String) -> Completable
    func update(todo: Todo) -> Completable
    func delete(todo: Todo) -> Completable
}

struct TodoUseCaseImpl: TodoUseCase,
    TodoRepositoryInjectable
{
    func startListenTodos() -> Completable {
        return todoRepository.startListenTodos()
    }

    func todosRelay() -> Driver<[SectionTodo]> {
        return todoRepository.todosRelay()
    }

    func tearDown() {
        return todoRepository.removeTodosListener()
    }

    func add(title: String, description: String) -> Completable {
        return todoRepository.add(title: title, description: description)
    }
    
    func update(todo: Todo) -> Completable {
        return todoRepository.update(todo: todo)
    }

    func delete(todo: Todo) -> Completable {
        return todoRepository.delete(todo: todo)
    }
}
