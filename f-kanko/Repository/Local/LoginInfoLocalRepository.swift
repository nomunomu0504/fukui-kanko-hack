//
//  LoginInfoLocalRepository.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation

protocol LoginInfoLocalRepository: AnyObject {
    func get() -> LoginInfo?
    func save(uid: String, email: String)
    func save(loginInfo: LoginInfo)
    func delete()
}

final class LoginInfoLocalRepositoryImpl: LoginInfoLocalRepository {
    private let key: String = "loginInfo"
    
    init() {}
    
    /// ログイン情報取得
    func get() -> LoginInfo? {
        let jsonDecoder = JSONDecoder()
        guard
            let data = UserDefaults.standard.data(forKey: self.key),
            let loginInfo = try? jsonDecoder.decode(LoginInfo.self, from: data)
        else {
            return nil
        }
        
        return loginInfo
    }
    
    /// ログイン情報保存
    func save(uid: String, email: String) {
        self.save(loginInfo: LoginInfo(uid: uid, email: email))
    }
    
    func save(loginInfo: LoginInfo) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(loginInfo) else { return }
        UserDefaults.standard.set(data, forKey: self.key)
    }
    
    /// ログイン情報削除
    func delete() {
        UserDefaults.standard.removeObject(forKey: self.key)
    }
}
