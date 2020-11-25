//
//  NSObject+Extension.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/11/24.
//

import UIKit

extension NSObject {
    // 型名を文字列として取得
    class var typeString: String {
        return String(describing: self)
    }

    // 値の型を取得してから型名を文字列として取得
    var typeString: String {
        return type(of: self).typeString
    }
}
