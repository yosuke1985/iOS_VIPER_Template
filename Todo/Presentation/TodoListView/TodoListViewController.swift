//
//  TodoListViewController.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/13.
//

import Firebase
import RxCocoa
import RxDataSources
import RxSwift
import UIKit
    
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
        
        setUI()
        presenter.setup()
        setTableViewBind()
        setBind()
    }
    
    deinit {
        presenter.tearDown()
    }
    
    @objc private func logout() {
        presenter.logoutRelay.accept(())
    }
}

extension TodoListViewController {
    private func setUI() {
        let leftButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func setBind() {
        toCreateTodoButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presenter.toCreateTodoViewRelay.accept(())
            }
            .disposed(by: bag)
        
        presenter.showAPIErrorPopupRelay
            .emit(onNext: { [weak self] error in
                self?.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
    }
}

extension TodoListViewController: UITableViewDelegate {
    func setTableViewBind() {
        let dataSource = returnDataSource()
                                
        presenter.todoTableViewRelay
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView.rx.setDelegate(self).disposed(by: bag)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let todo = presenter.todoTableViewRelay.value.first?.items[indexPath.row] {
            presenter.toTodoDetailViewRelay.accept(todo)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func returnDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionTodo> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .left),
            configureCell: { _, tableView, indexPath, todo in
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as! TodoCell
                cell.todoName?.text = "\(todo.title)"
                cell.configure(todo: todo)
                cell.updatedTodoRelay
                    .subscribe(onNext: { [weak self] updatedTodo in
                        self?.presenter.updateIsCheckedRelay.accept(updatedTodo)
                    })
                    .disposed(by: cell.bag)
                return cell
            },
            canEditRowAtIndexPath: { _, _ in
                true
            },
            canMoveRowAtIndexPath: { _, _ in
                true
            }
        )
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, handler in
            
            if let willDeleteTodo = self?.presenter.todoTableViewRelay.value.first?.items[indexPath.row] {
                self?.presenter.willDeleteTodoRelay.accept(willDeleteTodo)
            }
            handler(true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])

        return swipeActions
    }
}
