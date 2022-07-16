# ミケツ

![](readMe/logo.png)

# 技術スタック

- Swift5 + Combine + VIPER Architecture
- Firebase

# その他

- `GoogleService-Info.plist` はご自分のをお使いください。
- Firestore の暫定設計（命名規約設計と NoSQL 向けの DB 設計してない）

```
Firestore
├── StoreMaster: collection
│   └── <storeMasterDocumentId: FirebaseAuthのuid>
│       ├── name: string
│       ├── address: string
│       ├── geo: GeoPoint
│       │   ├── lat: number
│       │   └── lng: number
│       ├── phoneNumber: string
│       ├── zipCode: string
│       └── PaymentHistory: collection
│           └── <paymentHistoryDocumentId>
│               ├── userId: string
│               ├── amount: number
│               ├── isRefunded: boolean
│               └── createdAt: timestamp
└── UserMaster: collection
    └── <userMasterDocumentId: FirebaseAuthのuid>
        ├── name: string
        ├── address: string
        ├── phoneNumber: string
        └── zipCode: string
```
