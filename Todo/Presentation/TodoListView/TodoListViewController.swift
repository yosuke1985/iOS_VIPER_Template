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
        
        let db = Firestore.firestore()
        
        if let userId = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection("users/\(userId)/todos")
                .document("CU9EZIlyr0O63t7mmJSg").updateData(
                    ["title": "exampleうあああああ"],
                    completion: { error in
                        if let error = error {
                            print("TODO更新失敗: " + error.localizedDescription)
     
                        } else {
                            print("TODO更新成功")
                        }
                    }
                )
        }
        
//        if let userId = Auth.auth().currentUser?.uid {
//            let data: [String: Any] = [:]
//            let title = "example title"
//            let description: String? = nil
//
//            Firestore.firestore().collection("users/\(userId)/todos").document().setData([
//                "title": title,
//                "description": description
//            ], completion: { error in
//                if let error = error {
//                    // 失敗した場合
//
//                } else {
//                    // 成功の場合
//                }
//            })
//        }
//
//            Firestore.firestore().collection("users/\(userId)/todos").document().setData([
//                //                "name": "usersID JHPbsCmkpSQpvIb5zA3cBtR2p9h2",
        ////                "test": true
//                "test2": 1
//            ], completion: { error in
//                if let error = error {
//                    // ②が失敗した場合
        ////                                    print("Firestore 新規登録失敗 " + error.localizedDescription)
        ////                                    let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
        ////                                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        ////                                    self.present(dialog, animated: true, completion: nil)
//                } else {
        ////                                    print("ユーザー作成完了 name:" + name)
//                    // ③成功した場合はTodo一覧画面に画面遷移を行う
        ////                                    let storyboard: UIStoryboard = self.storyboard!
        ////                                    let next = storyboard.instantiateViewController(withIdentifier: "TodoListViewController")
        ////                                    self.present(next, animated: true, completion: nil)
//                }
//            })
//        }
        
//        if let userId = Auth.auth().currentUser?.uid {
//            Firestore.firestore().collection("users/\(userId)/todos")
//                .document("FJUVPI93UUNEeEWMWpgB")
//                .updateData(
//                    ["isChecked": true],
//                    completion: { error in
//                        if let error = error {
//                            print("TODO更新失敗: " + error.localizedDescription)
//                            let dialog = UIAlertController(title: "TODO更新失敗", message: error.localizedDescription, preferredStyle: .alert)
//                            dialog.addAction(UIAlertAction(title: "OK", style: .default))
//                            self.present(dialog, animated: true, completion: nil)
//                        } else {
//                            print("TODO更新成功")
        ////                            self.getTodoDataForFirestore()
//                        }
//                    }
//                )
//        }
        
        ////        var ref: DocumentReference?
//        if let userId = Auth.auth().currentUser?.uid {
//            db.collection("users").document().setData([
//                "first": "Yosuken",
//                "last": "Nakayama",
//                "born": 1815
//            ]) { err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Document added with ID: \(ref!.documentID)")
//                }
//            }
//        }

        let userSession = AuthRepositoryImpl.shared.userRelay.value
        print("userSession", userSession)
        
        setUI()
        setTableViewBind()
        presenter.setup()
    }
    
    @objc private func logout() {
        presenter.logout()
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
                self?.presenter.toCreateTodoView()
            }
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
                cell.todoName?.text = "\(item.title)"
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
