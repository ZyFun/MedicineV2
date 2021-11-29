//
//  FirstAidKit+CoreDataProperties.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 29.11.2021.
//
//

import Foundation
import CoreData


extension FirstAidKit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FirstAidKit> {
        return NSFetchRequest<FirstAidKit>(entityName: "FirstAidKit")
    }

    @NSManaged public var title: String?
    @NSManaged public var medicines: NSSet?

}

// MARK: Generated accessors for medicines
extension FirstAidKit {

    @objc(addMedicinesObject:)
    @NSManaged public func addToMedicines(_ value: Medicine)

    @objc(removeMedicinesObject:)
    @NSManaged public func removeFromMedicines(_ value: Medicine)

    @objc(addMedicines:)
    @NSManaged public func addToMedicines(_ values: NSSet)

    @objc(removeMedicines:)
    @NSManaged public func removeFromMedicines(_ values: NSSet)

}

extension FirstAidKit : Identifiable {

}
