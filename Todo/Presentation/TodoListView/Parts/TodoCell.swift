//
//  TodoCell.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/19.
//

import RxCocoa
import RxSwift
import UIKit

@IBDesignable
class TodoCell: UITableViewCell {
    @IBOutlet weak var todoName: UILabel!
    @IBOutlet weak var checkBoxButton: CheckBoxButton!
    var todo: Todo?
    var bag = DisposeBag()
    var updatedTodoRelay = PublishRelay<Todo>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBind()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(todo: Todo) {
        self.todo = todo
        checkBoxButton.isChecked = todo.isChecked
    }
    
    func setBind() {
        checkBoxButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let weakSelf = self, var udpatedTodo = weakSelf.todo else { return }
                udpatedTodo.isChecked = !weakSelf.checkBoxButton.isChecked!
                print("weakSelf.checkBoxButton.isChecked", udpatedTodo.isChecked)
                weakSelf.updatedTodoRelay.accept(udpatedTodo)
                
            })
            .disposed(by: bag)
    }
}
