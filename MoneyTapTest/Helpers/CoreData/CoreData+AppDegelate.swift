//
//  CoreData+AppDegelate.swift
//  MoneyTapTest
//
//  Created by Divum on 09/09/18.
//  Copyright © 2018 Murali. All rights reserved.
//

import Foundation
import CoreData

extension AppDelegate {
    func addSearchItem(item:SearchItem) {
        let managedContext = self.persistentContainer.viewContext
        
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let entity = NSEntityDescription.entity(forEntityName: "Recents",
                                                in: managedContext)!
        
        let recent = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        recent.setValue(item.itemId, forKeyPath: "itemId")
        recent.setValue(item.title, forKeyPath: "title")
        recent.setValue(item.desc, forKeyPath: "desc")
        recent.setValue(item.thumbnail, forKeyPath: "thumbnail")
      
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    func getRecentSearches() -> [SearchItem]{
        var recents: [SearchItem] = []
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recents")
        do {
            let recentsMO = try managedContext.fetch(fetchRequest)
            for recentMO:NSManagedObject in recentsMO {
                let recent = self.getSeaarchItemFromManagedObject(recentMO: recentMO);
                recents.append(recent)
            }
            return recents
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }

    

    func getSeaarchItemFromManagedObject(recentMO:NSManagedObject) -> SearchItem{
        let recent = SearchItem();
        recent.itemId = recentMO.value(forKey: "itemId") as! Int;
        recent.title = recentMO.value(forKey: "title") as! String;
        recent.desc = recentMO.value(forKey: "desc") as! String;
        recent.thumbnail = recentMO.value(forKey: "thumbnail") as! String;
        return recent
    }

   
}
