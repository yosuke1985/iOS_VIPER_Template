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
        
        createUserButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.presenter.toLoginView()
            })
            .disposed(by: bag)
    }
}
