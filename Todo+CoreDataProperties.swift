//
//  Todo+CoreDataProperties.swift
//  sampleCoreData002
//
//  Created by Eriko Ichinohe on 2017/03/30.
//  Copyright © 2017年 Eriko Ichinohe. All rights reserved.
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo");
    }

    @NSManaged public var title: String?
    @NSManaged public var saveDate: NSDate?

}
