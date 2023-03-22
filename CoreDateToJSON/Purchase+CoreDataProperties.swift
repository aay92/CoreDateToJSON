//
//  Purchase+CoreDataProperties.swift
//  CoreDateToJSON
//
//  Created by Aleksey Alyonin on 22.03.2023.
//
//

import Foundation
import CoreData


extension Purchase {
    

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Purchase> {
        return NSFetchRequest<Purchase>(entityName: "Purchase")
    }

    @NSManaged public var amountSpent: Double
    @NSManaged public var dataOfPurchase: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension Purchase : Identifiable {

}
