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
    func createUser(email: String, password: String) -> Single<Void>
    func login(email: String, password: String) -> Single<Void>
}

struct AuthUseCaseImpl: AuthUseCase,
    AuthRepositoryInjectable
{
    func createUser(email: String, password: String) -> Single<Void> {
        return authRepository.createUser(email: email, password: password)
    }

    func login(email: String, password: String) -> Single<Void> {
        return authRepository.login(email: email, password: password)
    }
}
