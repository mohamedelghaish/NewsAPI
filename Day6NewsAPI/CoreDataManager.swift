//
//  CoreDataManager.swift
//  Day6NewsAPI
//
//  Created by Mohamed Kotb Saied Kotb on 30/04/2024.
//

import Foundation
import CoreData
import UIKit


class CoreDataHelper {
    static let shared = CoreDataHelper()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Day6NewsAPI")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    
    func saveNew(new:New) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NewEntity", in: context)
        
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        newEntity.setValue(new.title, forKey: "title")
        newEntity.setValue(new.imageUrl, forKey: "imageUrl")
        newEntity.setValue(new.desription, forKey: "desription")
        newEntity.setValue(new.url, forKey: "url")
        newEntity.setValue(new.publishedAt, forKey: "publishedAt")
        do{
            try context.save()
            print("saved")
        } catch let error {
            print(error.localizedDescription)
        }
       
    }
    
    func deleteNew(new: New) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NewEntity")
        request.predicate = NSPredicate(format: "title == %@", new.title ?? "nd data")
        
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object as! NSManagedObject)
            }
            try context.save()
            print("Article deleted from Core Data")
        } catch {
            print("Error deleting article from Core Data: \(error.localizedDescription)")
        }
    }
    
    func isArticleFavorited(new: New) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NewEntity")
        request.predicate = NSPredicate(format: "title == %@", new.title ?? "no data")
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking if article is favorited: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchSavedNews() -> [New] {
        var savedNews: [New] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NewEntity> = NewEntity.fetchRequest()
        
        do {
            let fetchedEntities = try context.fetch(fetchRequest)
            for entity in fetchedEntities {
                let new = New()
                new.author = entity.author ?? ""
                new.title =  entity.title ?? ""
                new.desription =  entity.desription ?? ""
                new.imageUrl =  entity.imageUrl ?? ""
                new.url = entity.url ?? ""
                new.publishedAt = entity.publishedAt ?? ""
                
                savedNews.append(new)
            }
        } catch {
            print("Error fetching saved news: \(error)")
        }
        
        return savedNews
    }
    
    
    func saveHomeNew(new:New) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Home", in: context)
        
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        newEntity.setValue(new.author, forKey: "author")
        newEntity.setValue(new.title, forKey: "title")
        newEntity.setValue(new.imageUrl, forKey: "imageUrl")
        newEntity.setValue(new.desription, forKey: "desription")
        newEntity.setValue(new.url, forKey: "url")
        newEntity.setValue(new.publishedAt, forKey: "publishedAt")
        do{
            try context.save()
            print("saved Home")
        } catch let error {
            print(error.localizedDescription)
        }
       
    }
    
    func deleteHomeNew(new: New) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Home")
        request.predicate = NSPredicate(format: "title == %@", new.title ?? "nd data")
        
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object as! NSManagedObject)
            }
            try context.save()
            print("New Home deleted from Core Data")
        } catch {
            print("Error deleting aNew Home from Core Data: \(error.localizedDescription)")
        }
    }
    

    
    func fetchSavedHomeNews() -> [New]? {
        var savedNews: [New] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Home> = Home.fetchRequest()
        
        do {
            let fetchedEntities = try context.fetch(fetchRequest)
            for entity in fetchedEntities {
                let new = New()
                new.author = entity.author ?? ""
                new.title =  entity.title ?? ""
                new.desription =  entity.desription ?? ""
                new.imageUrl =  entity.imageUrl ?? ""
                new.url = entity.url ?? ""
                new.publishedAt = entity.publishedAt ?? ""
                
                savedNews.append(new)
            }
        } catch {
            print("Error fetching saved home news: \(error)")
        }
        
        return savedNews
    }


}

