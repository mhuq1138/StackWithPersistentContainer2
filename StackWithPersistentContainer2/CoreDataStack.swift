//
//  CoreDataStack.swift
//  StackFromScratch
//
//  Created by Mazharul Huq on 2/8/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import CoreData

class CoreDataStack{
    let modelName:String
    
    init(modelName:String){
        self.modelName = modelName
    }
    
    //Create the data model instance
    lazy var managedObjectModel:NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName,
                                             withExtension: "momd") else{
                                                fatalError("Unable to find data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else{
            fatalError("Unable to load data model")
        }
        return mom
    }()
    
     lazy var storeContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Container", managedObjectModel: self.managedObjectModel)
        container.loadPersistentStores{ (storeDescription, error)
            in
            if let error = error as NSError?{
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext ()->Bool {
        guard managedObjectContext.hasChanges else { return false }
        do {
            try managedObjectContext.save()
            return true
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return false
        }
    }
}
