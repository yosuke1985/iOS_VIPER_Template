//
//  TodoDetailPresenter.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Foundation
import RxCocoa
import RxSwift

protocol TodoDetailPresenter {
    var router: TodoDetailRouter! { get set }
    var todoUseCase: TodoUseCase! { get set }
    
    var todoRelay: BehaviorRelay<Todo?> { get }
}

final class TodoDetailPresenterImpl: TodoDetailPresenter {
    var router: TodoDetailRouter!
    var todoUseCase: TodoUseCase!
    var todo: Todo!
    var todoRelay = BehaviorRelay<Todo?>(value: nil)
    
    init(todo: Todo) {
        todoRelay.accept(todo)
        print("todo", todo)
    }
}
