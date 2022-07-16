//
//  PaymentHistory.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/16.
//

import Foundation
import FirebaseFirestore

struct PaymentHistory {
    /// ユーザーID
    let userId: String
    /// 支払い金額
    let amount: Int
    /// 支払日
    let createdAt: FieldValue = FieldValue.serverTimestamp()
    /// 店舗への払い戻しフラグ
    let isRefunded: Bool
    
    func toHash() -> [String: Any] {
        var object: [String: Any] = [:]
        
        object["userId"] = self.userId
        object["amount"] = self.amount
        object["createdAt"] = self.createdAt
        object["isRefunded"] = self.isRefunded
        
        return object
    }
}
