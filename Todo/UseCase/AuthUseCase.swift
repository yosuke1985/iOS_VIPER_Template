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
    func getSessionUser() -> Completable
    func createUser(email: String, password: String) -> Completable
    func login(email: String, password: String) -> Completable
    func logout() -> Completable
}

struct AuthUseCaseImpl: AuthUseCase,
    AuthRepositoryInjectable
{
    func getSessionUser() -> Completable {
        return authRepository.getSessionUser()
    }

    func createUser(email: String, password: String) -> Completable {
        return authRepository.createUser(email: email, password: password)
    }

    func login(email: String, password: String) -> Completable {
        return authRepository.login(email: email, password: password)
    }
    
    func logout() -> Completable {
        return authRepository.logout()
    }
}
