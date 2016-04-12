//
//  Area.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 4/8/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import Foundation
import CoreData


class Area: NSManagedObject {
    
    static func build() -> Area? {
        let context = AppDelegate.getContext()
        let entity = NSEntityDescription.entityForName("Area", inManagedObjectContext: context)
        if let entity = entity{
            return Area(entity: entity, insertIntoManagedObjectContext: context)
        }
        return nil
    }
    
    static func build(nome: String, placeId: String) -> Area? {
        if let area = build(){
            area.nome = nome
            area.placeId = placeId
            return area
        }
        return nil
    }
    
    static func buildNew(placeId: String) -> Area?{
        if let area = Area.build("", placeId: placeId){
            area.id = NSUUID().UUIDString
            return area
        }
        return nil
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest {
        let request = NSFetchRequest(entityName:"Area")
        request.predicate = predicate
        return request
    }
    
    static func findByPlace(placeId: String) -> [Area]?{
        let request = fetchRequest(NSPredicate(format: "placeId = %@", placeId))
        do{
            return try AppDelegate.getContext().executeFetchRequest(request) as? [Area]
        }catch{
            print("Erro: Area -> findByArea(placeId)")
        }
        return nil
    }
    
    
}
