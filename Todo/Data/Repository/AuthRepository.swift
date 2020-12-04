//
//  AuthRepository.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

import Firebase
import RxCocoa
import RxSwift

protocol AuthRepositoryInjectable {
    var authRepository: AuthRepository { get }
}

extension AuthRepositoryInjectable {
    var authRepository: AuthRepository {
        return AuthRepositoryImpl.shared
    }
}

protocol AuthRepository {
    func getSessionUser() -> Completable
    func login(email: String, password: String) -> Completable
    func createUser(email: String, password: String) -> Completable
    func logout() -> Completable
}

struct AuthRepositoryImpl: AuthRepository {
    static var shared = AuthRepositoryImpl()
    private init() {}

    let userRelay = BehaviorRelay<User?>(value: nil)
    
    func getSessionUser() -> Completable {
        Completable.create { (observer) -> Disposable in
            Auth.auth().addStateDidChangeListener { _error, result in
                
                if let error = _error as? Error {
                    observer(.error(error))
                } else {
                    if let uid = result?.uid {
                        let user = User(userId: uid)
                        self.userRelay.accept(user)
                    }
                    observer(.completed)
                }
            }
            return Disposables.create()
        }
    }

    func login(email: String, password: String) -> Completable {
        Completable.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    return observer(.error(error))
                } else {
                    if let uid = result?.user.uid {
                        let user = User(userId: uid)
                        AuthRepositoryImpl.shared.userRelay.accept(user)
                    }
                    return observer(.completed)
                }
            }
            return Disposables.create()
        }
    }
    
    func createUser(email: String, password: String) -> Completable {
        Completable.create { (observer) -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    return observer(.error(error))
                } else {
                    if let uid = result?.user.uid {
                        let user = User(userId: uid)
                        AuthRepositoryImpl.shared.userRelay.accept(user)
                    }
                    return observer(.completed)
                }
            }
            return Disposables.create()
        }
    }
        
    func logout() -> Completable {
        return Completable.create { observer -> Disposable in
            do {
                try Auth.auth().signOut()
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}
