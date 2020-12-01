//
//  CreateTodoViewController.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import RxCocoa
import RxSwift
import UIKit

class CreateTodoViewController: UIViewController {
    var presenter: CreateTodoPresenter!
    var bag = DisposeBag()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: DescriptionTextView!
    @IBOutlet weak var createButton: UIButton! {
        didSet {
            createButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBind()
        presenter.setBind()
    }
    
    private func setBind() {
        titleTextField.rx.text
            .map { text in
                if text != nil, text != "" {
                    return false
                } else {
                    return true
                }
            }
            .bind(to: createButton.rx.isHidden)
            .disposed(by: bag)
        
        createButton.rx.tap
            .bind(to: presenter.requestCreateTodoRelay)
            .disposed(by: bag)
        
        titleTextField.rx.text.orEmpty
            .bind(to: presenter.titleInputtedText)
            .disposed(by: bag)
        
        descriptionTextField.rx.text.orEmpty
            .bind(to: presenter.descriptionInputtedText)
            .disposed(by: bag)
        
        presenter.showAPIErrorPopupRelay
            .emit(onNext: { [weak self] error in
                self?.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
