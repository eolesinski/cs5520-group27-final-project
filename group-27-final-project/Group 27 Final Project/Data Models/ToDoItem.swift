//
//  ToDoItem.swift
//  Group 27 Final Project
//
//
//

import Foundation
import FirebaseFirestore

struct ToDoItem {
    let id: String
    let title: String
    let details: String
    var isPurchased: Bool
    var purchasedPrice: Double?
    var purchasedBy: String?
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.title = dictionary["title"] as? String ?? ""
        self.details = dictionary["details"] as? String ?? ""
        self.isPurchased = dictionary["isPurchased"] as? Bool ?? false
        self.purchasedPrice = dictionary["purchasedPrice"] as? Double
        self.purchasedBy = dictionary["purchasedBy"] as? String
    }
    
    var toDictionary: [String: Any] {
        return [
            "id": id,
            "title": title,
            "details": details,
            "isPurchased": isPurchased,
            "purchasedPrice": purchasedPrice as Any,
            "purchasedBy": purchasedBy as Any
        ]
    }
}
