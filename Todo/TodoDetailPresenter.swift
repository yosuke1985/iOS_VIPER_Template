//
//  TodoDetailPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation

protocol TodoDetailPresenter {
    var router: TodoDetailRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
}

final class TodoDetailPresenterImpl: TodoDetailPresenter {
    var router: TodoDetailRouter!
    var todoUseCase: TodoUseCase!
}
