//
//  Data.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/12/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import CoreData

private let _DataSharedInstance = Data()

class Data {
    
//MARK: Singleton Data
    class var shared: Data {
        return _DataSharedInstance
    }
    
    var places = [Place]()
    var areas = [Area]()
    var points = [Point]()
    var pointsAll = [Point]()
    
    var user: User?
    
    var place: Place?
    var area: Area?
    var point: Point?
    
    private init(){
        findAllPlaces()
        findAllUsers()
    }
    
//######################################################################################################################
//MARK: User
    func findAllUsers() -> Data{
        if let users = User.findAll() where users.count > 0{
            self.user = users.first
        }else{
            self.user = User.build("", email: "")
        }
        return self
    }
    
    func saveUser() -> Data{
        if let user = user{
            do {
                try user.managedObjectContext?.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return self
    }
    
    
//######################################################################################################################
//MARK: Place
    func findAllPlaces() -> Data{
        if let places = Place.findAll(){
            self.places = places
        }
        return self
    }
    
    func setPlace(place: Place){
        self.place = place
        self.findAllAreas()
        if let a = areas.first{
            self.area = a
        }else{
            area = nil
        }
        self.findAllPoints()
    }
    
    func newPlace() -> Data{
        if let place = Place.buildNew(){
            self.place = place
        }
        points = [Point]()
        return self
    }
    
    func savePlace() -> Data{
        if let place = place{
            do {
                try place.managedObjectContext?.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            setPlace(place)
            findAllPlaces()
        }
        return self
    }
    
    func remove(place: Place) -> Data{
        let context = AppDelegate.getContext()
        findAllPoints()
        findAllAreas()
        for p in pointsAll{
            context.deleteObject(p)
        }
        for a in areas{
            context.deleteObject(a)
        }
        //delete areas
        context.deleteObject(place)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        findAllPlaces()
        return self
    }
    
//######################################################################################################################
//MARK: Area
    func findAllAreas() -> Data{
        if let place = place, let areas = Area.findByPlace(place.id){
            self.areas = areas
        }
        return self
    }
    
    func setArea(area: Area){
        self.area = area
        self.findAllPoints()
    }
    
    func newArea() -> Data{
        if let placeId = place?.id, let area = Area.buildNew(placeId){
            self.area = area
        }
        return self
    }
    
    func saveArea() -> Data{
        if let area = area{
            do {
                try area.managedObjectContext?.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        findAllAreas()
        findAllPoints()
        return self
    }
    
//######################################################################################################################
//MARK: Point
    func findAllPoints() -> Data{
        if let area = area, let place = place, let points = Point.findByPlace(place.id, areaId: area.id), let allPoints = Point.findByPlace(place.id){
            self.points = points
            self.pointsAll = allPoints
        }else{
            self.points = [Point]()
            self.pointsAll = [Point]()
        }
        return self
    }
    
//    func add(point: Point) -> Data{
//        point.id = points.count+1
//        return update(point)
//    }
    
    func setPoint(point: Point){
        self.point = point
    }
    
    func newPoint() -> Data{
        if let placeId = place?.id, let point = Point.buildNew(placeId){
            self.point = point
        }
        return self
    }
    
    func newPoint(nome: String, latitude: NSNumber, longitude: NSNumber) -> Data{
        newPoint()
        point?.nome = nome
        point?.latitude = latitude
        point?.longitude = longitude
        return self
    }
    
    func savePoint() -> Data{
        if let point = point, area = area{
            point.areaId = area.id
            do {
                try point.managedObjectContext?.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        findAllPoints()
        return self
    }
    
    func remove(point: Point) -> Data{
        let context = AppDelegate.getContext()
        context.deleteObject(point)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        findAllPoints()
        return self
    }
    
    func pointsCount() -> Int{
        var c = 0
        for p in points{
            c = c+p.points
        }
        return c
    }
    
    func pointsCountAll() -> Int{
        var c = 0
        for p in pointsAll{
            c = c+p.points
        }
        return c
    }

}

