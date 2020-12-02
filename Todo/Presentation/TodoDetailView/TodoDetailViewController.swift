//
//  TodoDetailViewController.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import RxCocoa
import RxSwift
import UIKit

class TodoDetailViewController: UIViewController {
    var presenter: TodoDetailPresenter!
    var bag = DisposeBag()
    
    @IBOutlet weak var descriptionTextField: DescriptionTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setUp()
        setUI()
        setBind()
    }
    
    private func setUI() {
        if let title = presenter.todoRelay.value?.title {
            self.title = title
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setBind() {
        presenter.todoRelay
            .compactMap { $0?.description }
            .bind(to: descriptionTextField.rx.text)
            .disposed(by: bag)
        
        descriptionTextField.rx.text
            .compactMap { $0 }
            .bind(to: presenter.todoDescriptionDidChangeRelay)
            .disposed(by: bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Yes Takasu")
        presenter.didBackToDetailRelay.accept(())
    }
}
