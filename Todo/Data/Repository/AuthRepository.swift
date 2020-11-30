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
    func getSessionUser() -> Single<User?>
    func login(email: String, password: String) -> Single<Void>
    func createUser(email: String, password: String) -> Single<Void>
    func logout() -> Completable
}

struct AuthRepositoryImpl: AuthRepository {
    static var shared = AuthRepositoryImpl()
    private init() {}

    let userRelay = BehaviorRelay<User?>(value: nil)
    
    func getSessionUser() -> Single<User?> {
        Single<User?>.create { (observer) -> Disposable in
            Auth.auth().addStateDidChangeListener { _, result in
                if let result = result {
                    let user = User(userId: result.uid)
                    self.userRelay.accept(user)
                    observer(.success(user))
                }
            }
            return Disposables.create()
        }
    }

    func login(email: String, password: String) -> Single<Void> {
        Single<Void>.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    return observer(.error(error))
                } else {
                    if let uid = result?.user.uid {
                        let user = User(userId: uid)
                        AuthRepositoryImpl.shared.userRelay.accept(user)
                    }
                    return observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }
    
    func createUser(email: String, password: String) -> Single<Void> {
        Single<Void>.create { (observer) -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    return observer(.error(error))
                } else {
                    if let uid = result?.user.uid {
                        let user = User(userId: uid)
                        AuthRepositoryImpl.shared.userRelay.accept(user)
                    }
                    return observer(.success(()))
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
