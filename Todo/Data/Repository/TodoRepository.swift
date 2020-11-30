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
    func listenTodos() -> Completable
    func add(title: String, description: String) -> Completable
    func isChecked(todoId: String, isChecked: Bool) -> Completable
    func updateTitle(todoId: String, title: String) -> Completable
    func updateDescription(todoId: String, description: String) -> Completable
    func delete(todoId: String) -> Completable
}

class TodoRepositoryImpl: TodoRepository {
    static var shared = TodoRepositoryImpl()
    var todoTableViewRelay = BehaviorRelay<[SectionTodo]>(value: [])
    private init() {}

    func listenTodos() -> Completable {
//
//        let sections = [
//            SectionTodo(header: "Genre1", items: [
//                Todo(id: "id1", title: "todo1", description: "description1", isChecked: true, createdAt: Date(), updatedAt: Date()),
//                Todo(id: "id1", title: "todo2", description: "description1", isChecked: true, createdAt: Date(), updatedAt: Date()),
//                Todo(id: "id1", title: "todo3", description: "description1", isChecked: true, createdAt: Date(), updatedAt: Date()),
//                Todo(id: "id1", title: "todo4", description: "description1", isChecked: true, createdAt: Date(), updatedAt: Date()),
//                Todo(id: "id1", title: "todo5", description: "description1", isChecked: true, createdAt: Date(), updatedAt: Date())
//            ])
//        ]
//
//        todoTableViewRelay.accept(sections)
        guard let userId = Auth.auth().currentUser?.uid else { return Completable.empty() }
        return Completable.create { (observer) -> Disposable in
            var listener: ListenerRegistration!
            if listener == nil {
                listener = Firestore.firestore().collection("users/\(userId)/todos").order(by: "updatedAt").addSnapshotListener
                    { snapshot, error in
                        if let error = error {
                            observer(.error(error))
                        } else if let snapshot = snapshot?.documents.first {
                            var todos: [Todo] = []
                            do {
                                todos = try snapshot.data(as: [Todo].self)!
                                let sectionTodo = [SectionTodo(header: "", items: todos)]
                                self.todoTableViewRelay.accept(sectionTodo)
                            } catch {
                                print(error)
                            }
                            observer(.completed)
                        }
                    }
            } else {
                if listener != nil {
                    listener.remove()
                    listener = nil
                    self.todoTableViewRelay.accept([])
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }

    func add(title: String, description: String = "") -> Completable {
        guard let userId = Auth.auth().currentUser?.uid else { return Completable.empty() }
        // TODO: need no user login Error

        return Completable.create { (observer) -> Disposable in
            Firestore.firestore().collection("users/\(userId)/todos").document().setData([
                "title": title,
                "description": description,
                "createdAt": Date()
            ], completion: { error in
                if let error = error {
                    observer(.error(error))
                } else {
                    observer(.completed)
                }
            })

            return Disposables.create()
        }
    }

    func isChecked(todoId: String, isChecked: Bool) -> Completable {
        guard let userId = Auth.auth().currentUser?.uid else { return Completable.empty() }

        return Completable.create { (observer) -> Disposable in
            Firestore.firestore().collection("users/\(userId)/todos").document(todoId).updateData(
                [
                    "isChecked": isChecked,
                    "updatedAt": Date()
                ],
                completion: { error in
                    if let error = error {
                        observer(.error(error))

                    } else {
                        observer(.completed)
                    }
                }
            )
            
            return Disposables.create()
        }
    }

    func updateTitle(todoId: String, title: String) -> Completable {
        guard let userId = Auth.auth().currentUser?.uid else { return Completable.empty() }
        return Completable.create { (observer) -> Disposable in

            Firestore.firestore().collection("users/\(userId)/todos").document(todoId).updateData(
                ["title": title,
                 "updatedAt": Date()],
                completion: { error in
                    if let error = error {
                        observer(.error(error))
                    } else {
                        observer(.completed)
                    }
                }
            )
            return Disposables.create()
        }
    }

    func updateDescription(todoId: String, description: String) -> Completable {
        guard let userId = Auth.auth().currentUser?.uid else { return Completable.empty() }
        return Completable.create { (observer) -> Disposable in
            Firestore.firestore().collection("users/\(userId)/todos").document(todoId).updateData(
                ["description": description,
                 "updatedAt": Date()],
                completion: { error in
                    if let error = error {
                        observer(.error(error))
                    } else {
                        observer(.completed)
                    }
                }
            )
            return Disposables.create()
        }
    }

    func delete(todoId: String) -> Completable {
        Completable.create { (observer) -> Disposable in
            if let userId = Auth.auth().currentUser?.uid {
                Firestore.firestore().collection("users/\(userId)/todos").document(todoId).delete { error in
                    if let error = error {
                        observer(.error(error))

                    } else {
                        observer(.completed)
                    }
                }
            }
            return Disposables.create()
        }
    }
}
