//
//  Place.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/13/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import Foundation
import CoreData


class Place: NSManagedObject {

    static func build() -> Place? {
        let context = AppDelegate.getContext()
        let entity = NSEntityDescription.entityForName("Place", inManagedObjectContext: context)
        if let entity = entity{
            return Place(entity: entity, insertIntoManagedObjectContext: context)
        }
        return nil
    }
    
    static func build(nome: String, endereco: String, bairro: String, cidade: String, telefone: String, date: NSDate) -> Place? {
        if let place = build(){
            place.nome = nome
            place.endereco = endereco
            place.bairro = bairro
            place.cidade = cidade
            place.telefone = telefone
            place.date = date
            return place
        }
        return nil
    }
    
    static func buildNew() -> Place?{
        if let place = Place.build("", endereco: "", bairro: "", cidade: "", telefone: "", date: NSDate()){
            place.id = NSUUID().UUIDString
            return place
        }
        return nil
    }
    
    static func findAll() -> [Place]?{
        do{
            return try AppDelegate.getContext().executeFetchRequest(NSFetchRequest(entityName: "Place")) as? [Place]
        }catch{
            print("Erro: Place -> findAll()")
        }
        return nil
    }


}
