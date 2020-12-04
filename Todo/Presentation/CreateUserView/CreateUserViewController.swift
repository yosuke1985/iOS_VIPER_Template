//
//  CreateUserViewController.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/06.
//

import RxCocoa
import RxSwift
import UIKit

class CreateUserViewController: UIViewController {
    var presenter: CreateUserPresenter!
    var bag = DisposeBag()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var createUserButton: UIButton! {
        didSet {
            createUserButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setUp()
        setBind()
    }
    
    private func setBind() {
        Observable.combineLatest(emailTextField.rx.text, passTextField.rx.text)
            .compactMap { (emailText, passText) -> Bool in
                if emailText != nil, emailText != "", passText != nil, passText != "" {
                    return false
                } else {
                    return true
                }
            }
            .bind(to: createUserButton.rx.isHidden)
            .disposed(by: bag)
        
        emailTextField.rx.text
            .bind(to: presenter.emailRelay)
            .disposed(by: bag)
        
        passTextField.rx.text
            .bind(to: presenter.passwordRelay)
            .disposed(by: bag)
        
        createUserButton.rx.tap
            .bind(to: presenter.createUserRelay)
            .disposed(by: bag)
        
        presenter.showAPIErrorPopupRelay
            .emit(onNext: { [weak self] error in
                self?.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
