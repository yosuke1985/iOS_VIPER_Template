//
//  AuthRepository.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

import Firebase
import RxSwift

protocol AuthRepositoryInjectable {
    var authRepository: AuthRepository { get }
}

extension AuthRepositoryInjectable {
    var authRepository: AuthRepository {
        return AuthRepositoryImpl()
    }
}

protocol AuthRepository {
    func login(email: String, password: String) -> Single<Void>
    func createUser(email: String, password: String) -> Single<Void>
}

struct AuthRepositoryImpl: AuthRepository {
    func login(email: String, password: String) -> Single<Void> {
        Single<Void>.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { _, errorOptional in
                if let error = errorOptional {
                    return observer(.error(error))
                } else {
                    return observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }
    
    func createUser(email: String, password: String) -> Single<Void> {
        Single<Void>.create { (observer) -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { _, errorOptional in
                if let error = errorOptional {
                    return observer(.error(error))
                } else {
                    return observer(.success(()))
                }
            }
            return Disposables.create()
        }
    }
}
