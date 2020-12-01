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
    func isChecked(todoId: String, isChecked: Bool) -> Completable
    func updateTitle(todoId: String, title: String) -> Completable
    func updateDescription(todoId: String, description: String) -> Completable
    func delete(todoId: String) -> Completable
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
    
    func isChecked(todoId: String, isChecked: Bool) -> Completable {
        return todoRepository.isChecked(todoId: todoId, isChecked: isChecked)
    }
    
    func updateTitle(todoId: String, title: String) -> Completable {
        return todoRepository.updateTitle(todoId: todoId, title: title)
    }
    
    func updateDescription(todoId: String, description: String) -> Completable {
        return todoRepository.updateDescription(todoId: todoId, description: description)
    }
    
    func delete(todoId: String) -> Completable {
        return todoRepository.delete(todoId: todoId)
    }
}
