//
//  Point.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/13/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


class Point: NSManagedObject {

    static func build() -> Point? {
        let context = AppDelegate.getContext()
        let entity = NSEntityDescription.entityForName("Point", inManagedObjectContext: context)
        if let entity = entity{
            return Point(entity: entity, insertIntoManagedObjectContext: context)
        }
        return nil
    }
    
    static func build(placeId: String, nome: String, latitude: NSNumber, longitude: NSNumber) -> Point? {
        if let point = build(){
            point.placeId = placeId
            point.nome = nome
            point.latitude = latitude
            point.longitude = longitude
            return point
        }
        return nil
    }
    
    static func buildNew(placeId: String) -> Point?{
        if let point = Point.build(placeId, nome: "", latitude: 0.0, longitude: 0.0){
            point.id = NSUUID().UUIDString
            return point
        }
        return nil
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest {
        let request = NSFetchRequest(entityName:"Point")
        request.predicate = predicate
        return request
    }
    
    static func findByPlace(placeId: String, areaId: String) -> [Point]?{
        let request = fetchRequest(NSPredicate(format: "placeId = %@ && areaId = %@", placeId, areaId))
        do{
            return try AppDelegate.getContext().executeFetchRequest(request) as? [Point]
        }catch{
            print("Erro: Point -> findByPlace(placeId)")
        }
        return nil
    }
    
    static func findByPlace(placeId: String) -> [Point]?{
        let request = fetchRequest(NSPredicate(format: "placeId = %@", placeId))
        do{
            return try AppDelegate.getContext().executeFetchRequest(request) as? [Point]
        }catch{
            print("Erro: Point -> findByPlace(placeId)")
        }
        return nil
    }
    
    var location: CLLocation {
        return CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    func distance(lct: CLLocation) -> Double{
        return location.distanceFromLocation(lct)
    }

}
