//
//  CoreDataProperties.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/28/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    @NSManaged var nome: String
    @NSManaged var email: String
    
}

extension Place {
    
    @NSManaged var id: String
    @NSManaged var nome: String
    @NSManaged var endereco: String
    @NSManaged var bairro: String
    @NSManaged var cidade: String
    @NSManaged var telefone: String
    @NSManaged var email: String
    @NSManaged var cep: String
    @NSManaged var contato: String
    @NSManaged var date: NSDate
}

extension Area {
    
    @NSManaged var id: String
    @NSManaged var nome: String
    @NSManaged var placeId: String
    
}

extension Point {
    
    @NSManaged var id: String
    @NSManaged var placeId: String
    @NSManaged var nome: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var porta: Bool
    @NSManaged var areaId: String
    
    var points: Int{
        return porta ? 3 : 1
    }
}
