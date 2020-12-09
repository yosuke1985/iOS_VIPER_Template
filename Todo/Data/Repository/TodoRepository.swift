//
//  TodoRepository.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

import Firebase
import FirebaseFirestoreSwift
import RxCocoa
import RxSwift

protocol TodoRepositoryInjectable {
    var todoRepository: TodoRepository { get }
}

extension TodoRepositoryInjectable {
    var todoRepository: TodoRepository {
        return TodoRepositoryImpl.shared
    }
}

protocol TodoRepository {
    func startListenTodos() -> Single<Result<Void, APIError>>
    func removeTodosListener()
    func todosRelay() -> Driver<[SectionTodo]>
    func add(title: String, description: String) -> Single<Result<Void, APIError>>
    func update(todo: Todo) -> Single<Result<Void, APIError>>
    func delete(todo: Todo) -> Single<Result<Void, APIError>>
}

class TodoRepositoryImpl: TodoRepository {
    static var shared = TodoRepositoryImpl()
    var _todosTableViewRelay = BehaviorRelay<[SectionTodo]>(value: [])
    var todosTableViewRelay: Driver<[SectionTodo]> {
        return _todosTableViewRelay.asDriver()
    }

    var snapshotListener: ListenerRegistration!

    private init() {}

    func startListenTodos() -> Single<Result<Void, APIError>> {
        guard let userId = Auth.auth().currentUser?.uid else { return .error(CustomError.noUser) }
        return .create { [weak self] (observer) -> Disposable in
            guard let weakSelf = self else { return Disposables.create() }
            if weakSelf.snapshotListener == nil {
                weakSelf.snapshotListener = Firestore.firestore().collection("users/\(userId)/todos").order(by: "updatedAt", descending: true).addSnapshotListener
                    { snapshot, error in
                        if let error = error {
                            weakSelf._todosTableViewRelay.accept([])
                            let apiError = APIError.response(description: error.localizedDescription)
                            observer(.success(.failure(apiError)))
                        } else if let docs = snapshot?.documents {
                            var todos: [Todo] = []
                            do {
                                try docs.forEach { doc in
                                    let todo = try Firestore.Decoder().decode(Todo.self, from: doc.data())
                                    todos.append(todo)
                                }
                                let sectionTodo = [SectionTodo(header: "", items: todos)]
                                weakSelf._todosTableViewRelay.accept(sectionTodo)
                                observer(.success(.success(())))
                            } catch {
                                let appError = APIError.appError(description: error.localizedDescription)
                                observer(.success(.failure(appError)))
                            }
                        }
                    }
            }
            
            return Disposables.create()
        }
    }
    
    func todosRelay() -> Driver<[SectionTodo]> {
        return todosTableViewRelay
    }

    func removeTodosListener() {
        snapshotListener.remove()
        snapshotListener = nil
        _todosTableViewRelay.accept([])
    }

    func add(title: String, description: String = "") -> Single<Result<Void, APIError>> {
        guard let userId = Auth.auth().currentUser?.uid else { return .error(CustomError.noUser) }
        return .create { (observer) -> Disposable in
            let ref = Firestore.firestore().collection("users/\(userId)/todos").document()
                
            ref.setData([
                "id": ref.documentID,
                "title": title,
                "description": description,
                "isChecked": false,
                "updatedAt": Date(),
                "createdAt": Date()
            ], completion: { error in
                if let error = error {
                    let apiError = APIError.response(description: error.localizedDescription)
                    observer(.success(.failure(apiError)))
                } else {
                    observer(.success(.success(())))
                }
            })

            return Disposables.create()
        }
    }

    func update(todo: Todo) -> Single<Result<Void, APIError>> {
        guard let userId = Auth.auth().currentUser?.uid else { return .error(CustomError.noUser) }
        return .create { (observer) -> Disposable in

            Firestore.firestore().collection("users/\(userId)/todos").document(todo.id)
                .updateData([
                    "id": todo.id,
                    "title": todo.title,
                    "description": todo.description,
                    "isChecked": todo.isChecked,
                    "updatedAt": Date()
                ],
                completion: { error in
                    if let error = error {
                        let apiError = APIError.response(description: error.localizedDescription)
                        observer(.success(.failure(apiError)))
                    } else {
                        observer(.success(.success(())))
                    }
                })
            return Disposables.create()
        }
    }

    func delete(todo: Todo) -> Single<Result<Void, APIError>> {
        guard let userId = Auth.auth().currentUser?.uid else { return .error(CustomError.noUser) }
        return .create { (observer) -> Disposable in
            Firestore.firestore().collection("users/\(userId)/todos").document(todo.id).delete { error in
                if let error = error {
                    let apiError = APIError.response(description: error.localizedDescription)
                    observer(.success(.failure(apiError)))
                } else {
                    observer(.success(.success(())))
                }
            }
            return Disposables.create()
        }
    }
}
