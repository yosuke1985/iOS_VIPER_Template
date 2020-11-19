//
//  TodoListViewController.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import RxCocoa
import RxSwift
import UIKit
    
class TodoListViewController: UIViewController {
    var presenter: TodoListPresenter!
    var bag = DisposeBag()
    
    @IBOutlet weak var backToLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backToLogin.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presenter.toLoginView()
            })
            .disposed(by: bag)
    }
}
