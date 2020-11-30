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

struct SectionTodo {
    var header: String
    var items: [Item]
}

// AnimatableSectionModelType
extension SectionTodo: AnimatableSectionModelType {
    typealias Item = Todo
    typealias Identity = String

    var identity: String {
        return header
    }
    
    init(original: SectionTodo, items: [Item]) {
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
        
        let userSession = AuthRepositoryImpl.shared.userRelay.value
        print("userSession", userSession)
        
        let dataSource = returnDataSource()
                
        let sections = [
            SectionTodo(header: "Genre1", items: [
                Todo(id: "id1", name: "todo1", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date()),
                Todo(id: "id1", name: "todo2", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date()),
                Todo(id: "id1", name: "todo3", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date()),
                Todo(id: "id1", name: "todo4", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date()),
                Todo(id: "id1", name: "todo5", description: "description1", isCompleted: true, createdAt: Date(), updatedAt: Date())
            ])
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
    
    func returnDataSource() -> RxTableViewSectionedAnimatedDataSource<SectionTodo> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .left),
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as! TodoCell
                cell.todoName?.text = "\(item.name)"
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            // TODO:
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}
