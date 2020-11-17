//
//  TodoUseCase.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//
protocol TodoUseCaseInjectable {
    var todoUseCaseImpl: TodoUseCase { get }
}

extension TodoUseCaseInjectable {
    var todoUseCaseImpl: TodoUseCase {
        return TodoUseCaseImpl()
    }
}

protocol TodoUseCase {}

struct TodoUseCaseImpl: TodoUseCase {}
