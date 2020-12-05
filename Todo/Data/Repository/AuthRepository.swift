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
    func getSessionUser() -> Single<Result<Void, APIError>>
    func login(email: String, password: String) -> Single<Result<Void, APIError>>
    func createUser(email: String, password: String) -> Single<Result<Void, APIError>>
    func logout() -> Single<Result<Void, APIError>>
}

struct AuthRepositoryImpl: AuthRepository {
    static var shared = AuthRepositoryImpl()
    private init() {}

    let userRelay = BehaviorRelay<User?>(value: nil)
    
    func getSessionUser() -> Single<Result<Void, APIError>> {
        Single<Result<Void, APIError>>.create { (observer) -> Disposable in
            Auth.auth().addStateDidChangeListener { _error, result in
                if let error = _error as? Error {
                    let apiError = APIError.response(description: error.localizedDescription)
                    return observer(.success(Result.failure(apiError)))
                } else if let uid = result?.uid {
                    let user = User(userId: uid)
                    AuthRepositoryImpl.shared.userRelay.accept(user)
                    return observer(.success(Result.success(())))
                } else {
                    return observer(.error(CustomError.unknown))
                }
            }
            return Disposables.create()
        }
    }

    func login(email: String, password: String) -> Single<Result<Void, APIError>> {
        Single<Result<Void, APIError>>.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    let apiError = APIError.response(description: error.localizedDescription)
                    return observer(.success(Result.failure(apiError)))
                } else if let uid = result?.user.uid {
                    let user = User(userId: uid)
                    AuthRepositoryImpl.shared.userRelay.accept(user)
                    return observer(.success(Result.success(())))
                } else {
                    return observer(.error(CustomError.unknown))
                }
            }
            return Disposables.create()
        }
    }
    
    func createUser(email: String, password: String) -> Single<Result<Void, APIError>> {
        Single<Result<Void, APIError>>.create { (observer) -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { result, errorOptional in
                if let error = errorOptional {
                    let apiError = APIError.response(description: error.localizedDescription)
                    return observer(.success(Result.failure(apiError)))
                } else if let uid = result?.user.uid {
                    let user = User(userId: uid)
                    AuthRepositoryImpl.shared.userRelay.accept(user)
                    return observer(.success(Result.success(())))
                } else {
                    return observer(.error(CustomError.unknown))
                }
            }
            return Disposables.create()
        }
    }
        
    func logout() -> Single<Result<Void, APIError>> {
        return Single<Result<Void, APIError>>.create { observer -> Disposable in
            do {
                try Auth.auth().signOut()
                observer(.success(Result.success(())))

            } catch {
                let apiError = APIError.response(description: "failure logout")
                observer(.success(Result.failure(apiError)))
            }
            return Disposables.create()
        }
    }
}
