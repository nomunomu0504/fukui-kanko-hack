//
//  UserInfoModels.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/16.
//

import Foundation

// MARK: - UserInfo
struct UserInfo: Codable, Equatable {
    /// ユーザー名
    let name: String
    /// ユーザーID
    let uid: String
}
