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

protocol AuthUseCase {
    func getSessionUser() -> Single<Result<Void, APIError>>
    func createUser(email: String, password: String) -> Single<Result<Void, APIError>>
    func login(email: String, password: String) -> Single<Result<Void, APIError>>
    func logout() -> Single<Result<Void, APIError>>
}

struct AuthUseCaseImpl: AuthUseCase,
    AuthRepositoryInjectable
{
    func getSessionUser() -> Single<Result<Void, APIError>> {
        return authRepository.getSessionUser()
    }

    func createUser(email: String, password: String) -> Single<Result<Void, APIError>> {
        return authRepository.createUser(email: email, password: password)
    }

    func login(email: String, password: String) -> Single<Result<Void, APIError>> {
        return authRepository.login(email: email, password: password)
    }
    
    func logout() -> Single<Result<Void, APIError>> {
        return authRepository.logout()
    }
}
