//
//  Medicine+CoreDataProperties.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 10.12.2021.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var amount: Double
    @NSManaged public var expiryDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var stepCountForStepper: Double
    @NSManaged public var dateCreated: Date?
    @NSManaged public var firstAidKit: FirstAidKit?

}

extension Medicine : Identifiable {

}
