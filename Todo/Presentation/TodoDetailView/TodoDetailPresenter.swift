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
    var todoTitleDidChangeRelay: BehaviorRelay<String?> { get }
    var didBackToDetailRelay: PublishRelay<Void> { get }
}

final class TodoDetailPresenterImpl: TodoDetailPresenter {
    var router: TodoDetailRouter!
    var todoUseCase: TodoUseCase!
    var todo: Todo!
    var todoRelay = BehaviorRelay<Todo?>(value: nil)
    var todoTitleDidChangeRelay = BehaviorRelay<String?>(value: nil)
    var didBackToDetailRelay = PublishRelay<Void>()
    var bag = DisposeBag()

    init(todo: Todo) {
        todoRelay.accept(todo)
        todoTitleDidChangeRelay.accept(todo.title)
        
        print("todohere", todo)
        print("didChange", todoTitleDidChangeRelay.value)
    }
    
    func setUp() {
        setBind()
    }
    
    private func setBind() {
        didBackToDetailRelay
            .subscribe(onNext: { _ in
                print("called")
                
            })
            .disposed(by: bag)
    }
}
