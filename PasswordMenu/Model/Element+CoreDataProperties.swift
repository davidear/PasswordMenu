//
//  Element+CoreDataProperties.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/18.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Element {

    @NSManaged var leftText: String?
    @NSManaged var rightText: String?
    @NSManaged var type: NSNumber?
    @NSManaged var item: Entity?

}
