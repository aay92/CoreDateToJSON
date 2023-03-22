//
//  Purchase+CoreDataClass.swift
//  CoreDateToJSON
//
//  Created by Aleksey Alyonin on 22.03.2023.
//
//

import Foundation
import CoreData

@objc(Purchase)
public class Purchase: NSManagedObject, Codable {
    
    required convenience public init(from decoder: Decoder) throws {
/// first we need to extract managed object context to initialise
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
//        Decoding Item
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = try value.decode(UUID.self, forKey: .id)
        dataOfPurchase = try value.decode(Date.self, forKey: .dataOfPurchase)
        title = try value.decode(String.self, forKey: .title)
        amountSpent = try value.decode(Double.self, forKey: .amountSpent)
    }
//    conforming encoding
    public func encode(to encoder: Encoder) throws {
        ///encoding item
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(dataOfPurchase, forKey: .dataOfPurchase)
        try values.encode(title, forKey: .title)
        try values.encode(amountSpent, forKey: .amountSpent)
    }
    
    enum CodingKeys: CodingKey {
        case amountSpent, dataOfPurchase, id, title
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum ContextError: Error {
    case NoContextFound
}

