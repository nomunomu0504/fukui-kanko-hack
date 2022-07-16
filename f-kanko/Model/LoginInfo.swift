//
//  LoginInfo.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation

struct LoginInfo: Codable, Equatable {
    let uid: String
    let email: String
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
    static func == (lhs: LoginInfo, rhs: LoginInfo) -> Bool {
        return lhs.uid == rhs.uid && lhs.email == rhs.email
    }
}
