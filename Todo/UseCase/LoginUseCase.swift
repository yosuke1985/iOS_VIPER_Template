//
//  LoginUseCase.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

protocol LoginUseCaseInjectable {
    var loginUseCaseImpl: LoginUseCase { get }
}

extension LoginUseCaseInjectable {
    var loginUseCaseImpl: LoginUseCase {
        return LoginUseCaseImpl()
    }
}

protocol LoginUseCase {}

struct LoginUseCaseImpl: LoginUseCase,
    LoginRepositoryInjectable {}
