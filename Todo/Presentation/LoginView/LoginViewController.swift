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
    
    @IBOutlet weak var emailInputFieldView: InputFieldView!
    @IBOutlet weak var passInputFieldView: InputFieldView! {
        didSet {
            passInputFieldView.inputTextField.isSecureTextEntry = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getSessionUser()
        setBind()
    }
    
    private func setBind() {
        Observable.combineLatest(emailInputFieldView.inputTextField.rx.text.orEmpty, passInputFieldView.inputTextField.rx.text.orEmpty)
            .compactMap { (emailText, passText) -> Bool in
                if emailText != "", passText != "" {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: bag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.presenter.login(email: weakSelf.emailInputFieldView.inputTextField.text!,
                                         password: weakSelf.passInputFieldView.inputTextField.text!)
                
            })
            .disposed(by: bag)
        
        createUserButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presenter.toCreateUserView()
            })
            .disposed(by: bag)
        
        presenter.showAPIErrorPopupRelay
            .emit(onNext: { [weak self] error in
                self?.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
