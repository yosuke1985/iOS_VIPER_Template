//
//  APIError.swift
//  Todo
//
//  Created by Yosuke Nakayama on 2020/12/05.
//

import Foundation

enum APIError: Error {
    case response(description: String)
    case appError(description: String)
}

extension APIError {
    var localizedDescription: String {
        switch self {
        case let .response(description: description):
            return "API error: \(description)"
        case let .appError(description: description): return "Application Error: \(description)"
        }
    }
}
