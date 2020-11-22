//
//  TodoListViewController.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

struct SectionOfTodoData {
    var header: String
    var items: [Item]
}

extension SectionOfTodoData: SectionModelType {
    typealias Item = Todo

    init(original: SectionOfTodoData, items: [Item]) {
        self = original
        self.items = items
    }
}
    
class TodoListViewController: UIViewController {
    var presenter: TodoListPresenter!
    var bag = DisposeBag()
    
    @IBOutlet weak var toCreateTodoButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(TodoCell.nib, forCellReuseIdentifier: TodoCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(toLogin))
        navigationItem.leftBarButtonItem = leftButton
        
        toCreateTodoButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presenter.toCreateTodoView()
            }
            .disposed(by: bag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTodoData>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as! TodoCell
                cell.todoName.text = "\(item.name)"
                return cell
            })
        
        let sections = [
            SectionOfTodoData(header: "Genre1", items: [
                Todo(name: "todo1", deadline: Date(), comment: "comment1", assign: User(id: 0, name: "yo", createdAt: Date()), created: User(id: 0, name: "yo", createdAt: Date()), createdAt: Date(), updatedAt: Date()),
                Todo(name: "todo2", deadline: Date(), comment: "comment2", assign: User(id: 0, name: "yo", createdAt: Date()), created: User(id: 0, name: "yo", createdAt: Date()), createdAt: Date(), updatedAt: Date()),
                Todo(name: "todo3", deadline: Date(), comment: "comment1", assign: User(id: 0, name: "yo", createdAt: Date()), created: User(id: 0, name: "yo", createdAt: Date()), createdAt: Date(), updatedAt: Date()),
            ]),
            SectionOfTodoData(header: "Genre2", items: [
                Todo(name: "todo4", deadline: Date(), comment: "comment1", assign: User(id: 0, name: "yo", createdAt: Date()), created: User(id: 0, name: "yo", createdAt: Date()), createdAt: Date(), updatedAt: Date()),
                Todo(name: "todo5", deadline: Date(), comment: "comment1", assign: User(id: 0, name: "yo", createdAt: Date()), created: User(id: 0, name: "yo", createdAt: Date()), createdAt: Date(), updatedAt: Date()),
                Todo(name: "todo6", deadline: Date(), comment: "comment1", assign: User(id: 0, name: "yo", createdAt: Date()), created: User(id: 0, name: "yo", createdAt: Date()), createdAt: Date(), updatedAt: Date()),
                Todo(name: "todo7", deadline: Date(), comment: "comment1", assign: User(id: 0, name: "yo", createdAt: Date()), created: User(id: 0, name: "yo", createdAt: Date()), createdAt: Date(), updatedAt: Date())
            ]),
        ]
    
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
    
    @objc private func toLogin() {
        presenter.toLoginView()
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.toTodoDetailView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
