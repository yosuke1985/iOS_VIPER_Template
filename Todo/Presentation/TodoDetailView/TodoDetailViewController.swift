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
        
        setBind()
    }
    
    private func setBind() {
        presenter.todoRelay
            .compactMap { $0?.description }
            .bind(to: descriptionTextField.rx.text)
            .disposed(by: bag)
    }
}
