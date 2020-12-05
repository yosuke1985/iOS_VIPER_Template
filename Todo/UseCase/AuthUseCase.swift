//
//  AuthUseCase.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

import RxSwift

protocol AuthUseCaseInjectable {
    var authUseCaseImpl: AuthUseCase { get }
}

extension AuthUseCaseInjectable {
    var authUseCaseImpl: AuthUseCase {
        return AuthUseCaseImpl()
    }
}

enum LoginResult {
    case success
    case failure(errorType: ErrorType, messages: [String])
    
    enum ErrorType {
        case validateError
        case apiError
    }
}

enum AuthError: Error {
    case authError(description: String)
}

protocol AuthUseCase {
    func getSessionUser() -> Single<Result<Void, AuthError>>
    func createUser(email: String, password: String) -> Single<Result<Void, AuthError>>
    func login(email: String, password: String) -> Single<Result<Void, AuthError>>
    func logout() -> Single<Result<Void, AuthError>>
}

struct AuthUseCaseImpl: AuthUseCase,
    AuthRepositoryInjectable
{
    func getSessionUser() -> Single<Result<Void, AuthError>> {
        return authRepository.getSessionUser()
    }

    func createUser(email: String, password: String) -> Single<Result<Void, AuthError>> {
        return authRepository.createUser(email: email, password: password)
    }

    func login(email: String, password: String) -> Single<Result<Void, AuthError>> {
        return authRepository.login(email: email, password: password)
    }
    
    func logout() -> Single<Result<Void, AuthError>> {
        return authRepository.logout()
    }
}
