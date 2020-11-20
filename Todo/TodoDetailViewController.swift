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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
