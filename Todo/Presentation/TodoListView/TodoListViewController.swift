//
//  TodoListViewController.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import RxCocoa
import RxSwift
import UIKit
    
class TodoListViewController: UIViewController {
    var presenter: TodoListPresenter!
    var bag = DisposeBag()
    
    @IBOutlet weak var backToLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(toLogin))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func toLogin() {
        presenter.toLoginView()
    }
}
