//
//  CustomError.swift
//  Todo
//
//  Created by yosuke.nakayama on 2020/12/04.
//

import Foundation

enum CustomError: Error {
    case selfIsNil
    case noUser
    case unknown
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .selfIsNil: return "unknown error happened"
        case .noUser: return "no user"
        case .unknown: return "unknown error happened"
        }
    }
}
