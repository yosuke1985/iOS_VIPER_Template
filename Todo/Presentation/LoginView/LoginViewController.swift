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
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.isEnabled = false
        }
    }

    @IBOutlet weak var createUserButton: UIButton!
    
    @IBOutlet weak var emailInputFieldView: InputFieldView! {
        didSet {
            emailInputFieldView.inputTextField.keyboardType = .emailAddress
        }
    }

    @IBOutlet weak var passInputFieldView: InputFieldView! {
        didSet {
            passInputFieldView.inputTextField.keyboardType = .alphabet
            passInputFieldView.inputTextField.isSecureTextEntry = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setUp()
        setBind()
    }
    
    private func setBind() {
        presenter.isEnableLoginButtonRelay
            .drive(loginButton.rx.isEnabled)
            .disposed(by: bag)
        
        emailInputFieldView.inputTextField.rx.text.orEmpty
            .bind(to: presenter.emailRelay)
            .disposed(by: bag)
        
        passInputFieldView.inputTextField.rx.text.orEmpty
            .bind(to: presenter.passwordRelay)
            .disposed(by: bag)
        
        loginButton.rx.tap
            .bind(to: presenter.loginRelay)
            .disposed(by: bag)
        
        createUserButton.rx.tap
            .bind(to: presenter.toCreateUserViewRelay)
            .disposed(by: bag)
        
        presenter.showAPIErrorPopupRelay
            .emit(onNext: { [weak self] error in
                self?.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
