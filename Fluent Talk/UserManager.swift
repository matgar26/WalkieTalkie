//
//  UserManager.swift
//  Fluent Talk
//
//  Created by Matt Gardner on 10/18/21.
//

import Foundation

class UserManager: NSObject {
    static let shared = UserManager()

    var userName: String = "farbrother0"
    var isAdmin: Bool = true
}
