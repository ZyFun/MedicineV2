//
//  Medicine+CoreDataProperties.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.11.2021.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var number: Int64
    @NSManaged public var title: String?
    @NSManaged public var firstAidKit: FirstAidKit?

}

extension Medicine : Identifiable {

}
