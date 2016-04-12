//
//  User.swift
//  
//
//  Created by Edivando Alves on 3/22/16.
//
//

import Foundation
import CoreData


class User: NSManagedObject {

    
    static func build() -> User? {
        let context = AppDelegate.getContext()
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        if let entity = entity{
            return User(entity: entity, insertIntoManagedObjectContext: context)
        }
        return nil
    }
    
    static func build(nome: String, email: String) -> User? {
        if let user = build(){
            user.nome = nome
            user.email = email
            return user
        }
        return nil
    }
    
    static func findAll() -> [User]?{
        do{
            return try AppDelegate.getContext().executeFetchRequest(NSFetchRequest(entityName: "User")) as? [User]
        }catch{
            print("Erro: User -> findAll()")
        }
        return nil
    }
}
