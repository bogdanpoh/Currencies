//
//  Currency+CoreDataProperties.swift
//  Currencies
//
//  Created by Bogdan Pohidnya on 07.05.2020.
//  Copyright © 2020 Bogdan Pohidnya. All rights reserved.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var buy: String?
    @NSManaged public var sale: String?
    @NSManaged public var date: String?
    @NSManaged public var source: String?
    @NSManaged public var name: String?

}
