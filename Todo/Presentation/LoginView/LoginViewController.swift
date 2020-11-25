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
    @IBOutlet weak var createUserButton: UIButton!
    
    @IBOutlet weak var emailInputFieldView: InputFieldView!
    @IBOutlet weak var passInputFieldView: InputFieldView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presenter.toTodoListView()
            })
            .disposed(by: bag)
        
        createUserButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presenter.toCreateUserView()
            })
            .disposed(by: bag)
    }
}
