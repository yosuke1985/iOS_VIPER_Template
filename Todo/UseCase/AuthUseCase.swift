//
//  AuthUseCase.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

protocol AuthUseCaseInjectable {
    var authUseCaseImpl: AuthUseCase { get }
}

extension AuthUseCaseInjectable {
    var authUseCaseImpl: AuthUseCase {
        return AuthUseCaseImpl()
    }
}

protocol AuthUseCase {}

struct AuthUseCaseImpl: AuthUseCase,
    AuthRepositoryInjectable {}
