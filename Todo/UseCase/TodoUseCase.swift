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
    func startListenTodos() -> Single<Result<Void, APIError>>
    func todosRelay() -> Driver<[SectionTodo]>
    func tearDown()
    func add(title: String, description: String) -> Single<Result<Void, APIError>>
    func update(todo: Todo) -> Single<Result<Void, APIError>>
    func delete(todo: Todo) -> Single<Result<Void, APIError>>
}

struct TodoUseCaseImpl: TodoUseCase,
    TodoRepositoryInjectable
{
    func startListenTodos() -> Single<Result<Void, APIError>> {
        return todoRepository.startListenTodos()
    }

    func todosRelay() -> Driver<[SectionTodo]> {
        return todoRepository.todosRelay()
    }

    func tearDown() {
        return todoRepository.removeTodosListener()
    }

    func add(title: String, description: String) -> Single<Result<Void, APIError>> {
        return todoRepository.add(title: title, description: description)
    }
    
    func update(todo: Todo) -> Single<Result<Void, APIError>> {
        return todoRepository.update(todo: todo)
    }

    func delete(todo: Todo) -> Single<Result<Void, APIError>> {
        return todoRepository.delete(todo: todo)
    }
}
