//
//  APIError.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/12/05.
//

import Foundation

enum APIError: Error {
    case response(description: String)
}
