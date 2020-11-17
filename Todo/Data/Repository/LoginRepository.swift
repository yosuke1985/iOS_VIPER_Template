//
//  LoginRepository.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

protocol LoginRepositoryInjectable {
    var loginRepository: LoginRepository { get }
}

extension LoginRepositoryInjectable {
    var loginRepository: LoginRepository {
        return LoginRepositoryImpl()
    }
}

protocol LoginRepository {}

struct LoginRepositoryImpl: LoginRepository {}
