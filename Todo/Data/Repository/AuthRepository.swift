//
//  AuthRepository.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

protocol AuthRepositoryInjectable {
    var authRepository: AuthRepository { get }
}

extension AuthRepositoryInjectable {
    var authRepository: AuthRepository {
        return AuthRepositoryImpl()
    }
}

protocol AuthRepository {}

struct AuthRepositoryImpl: AuthRepository {}
