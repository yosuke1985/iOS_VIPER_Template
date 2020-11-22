//
//  TodoCell.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/11/19.
//

import UIKit

@IBDesignable
class TodoCell: UITableViewCell {
    @IBOutlet weak var todoName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
