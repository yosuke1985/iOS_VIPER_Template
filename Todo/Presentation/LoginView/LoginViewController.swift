//
//  LoginViewController.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

import RxCocoa
import RxSwift
import UIKit

class LoginViewController: UIViewController {
    var presenter: LoginPresenter!
    var bag = DisposeBag()
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presenter.toTodoListView()
            })
            .disposed(by: bag)
    }
}
