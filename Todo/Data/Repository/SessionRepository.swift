//
//  UserRepository.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/28.
//

import Firebase
import Foundation
import RxCocoa
import RxSwift

protocol SessionRepositoryInjectable {
    var sessionRepository: SessionRepository { get }
}

extension SessionRepositoryInjectable {
    var sessionRepository: SessionRepository {
        return SessionRepositoryImpl.shared
    }
}

protocol SessionRepository {
    func getSessionUser() -> Single<User?>
}

class SessionRepositoryImpl: SessionRepository {
    static var shared = SessionRepositoryImpl()
    private init() {}

    let userRelay = BehaviorRelay<User?>(value: nil)
    
    func getSessionUser() -> Single<User?> {
        Single<User?>.create { (observer) -> Disposable in
            Auth.auth().addStateDidChangeListener { _, result in
                if let result = result {
                    let user = User(userId: result.uid)
                    self.userRelay.accept(user)
                    observer(.success(user))
                }
            }
            return Disposables.create()
        }
    }
}
