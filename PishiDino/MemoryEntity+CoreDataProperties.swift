//
//  MemoryEntity+CoreDataProperties.swift
//  PishiDino
//
//  Created by ala omidfar on 4/11/25.
//
//

import Foundation
import CoreData


extension MemoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoryEntity> {
        return NSFetchRequest<MemoryEntity>(entityName: "MemoryEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var imageName: String?
    @NSManaged public var audioFileName: String?

}

extension MemoryEntity : Identifiable {

}
