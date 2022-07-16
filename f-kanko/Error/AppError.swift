//
//  AppError.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation

enum AppError: Error {
    /// 想定外エラー
    case unknown
    /// 支払いエラー（ユーザー情報なし）
    case userInfoIsNotSet
}
