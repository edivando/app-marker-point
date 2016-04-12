//
//  MailApi.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/22/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import Foundation
import Alamofire

class MailApi {
    
    private static let key = "key-f9349fc87173e19c53867e641125391c" //"key-12319d671287729839092d7d3a7c3cf7"
    private static let url = "https://api.mailgun.net/v3/sandbox2732fa37af0c4d0e8c2bf0ece51f99b9.mailgun.org/messages"
    // "https://api.mailgun.net/v3/sandbox6ffeacdc0e3848f4bd95054054e9815b.mailgun.org/messages"
    
    private static let emailFrom = "App Marker Point<postmaster@sandbox2732fa37af0c4d0e8c2bf0ece51f99b9.mailgun.org>"
    private static let emailTo = "ecreativce@gmail.com"      // Email do Lincon Alcantarino
//    private static let emailTo = "j7system@gmail.com"
    
    static func templateNewUser(name: String, email: String) -> String{
        return "[Marker Point] Novo Usuário Registrado <br/><br/><br/> Nome: \(name) <br/> Email: \(email)"
    }
    
    static func templateNewBudget(place: Place, user: User, totalPoints: Int) -> String{
        let empresa = "<strong>Formalizar Orçamento:</strong><br/> Empresa: \(place.nome) <br/> Nome Contato: \(place.contato) <br/> Endereço: \(place.endereco) <br/> Bairro: \(place.bairro) <br/> Cidade: \(place.cidade) <br/> CEP: \(place.cep) <br/> Telefone: \(place.telefone) <br/><br/>"
        
        let usuario = "<strong>Usuário:</strong><br/> Nome: \(user.nome) <br/> Email: \(user.email) <br/><br/>"
        
        var areasString = "<strong>Áreas:</strong><br/>"
        for area in Data.shared.areas{
            if let points = Point.findByPlace(place.id, areaId: area.id){
                var count = 0
                for point in points {
                    count += point.points
                }
                areasString += "\(area.nome): \(count) <br/>"
            }
        }
        areasString += "<strong>Total de Pontos:</strong> \(totalPoints)"
        
        
        return   "\(empresa)\(usuario)\(areasString)"
    }
    
    static func sendEmailNewUser(name: String, email: String){
        send([ "from": emailFrom,
                "to": emailTo,
                "subject": "[Marker Point] Novo Usuário Registrado",
                "html": templateNewUser(name, email: email)
            ])
    }
    
    static func sendEmailNewBudget(place: Place, user: User, totalPoints: Int){
        send([ "from": emailFrom,
                "to": emailTo,
                "subject": "[Marker Point] Formalizar Orçamento: \(place.nome)",
                "html": templateNewBudget(place, user: user, totalPoints: totalPoints)
            ])
    }
    
    private static func send(param: [String: String]){
        Alamofire.request(.POST, url , parameters:param).authenticate(user: "api", password: key).response { (request, response, data, error) in
            if let error = error{
                print(error)
                // If error salvar e enviar depois
            }
        }
    }
    
    
    
    
}

//[Marker Point] Novo Usuário Registrado
//
//Nome: Fulano de Tal
//Email: fulano@email.com
//
//------------------------------------------------------
//[Marker Point] Novo Orçamento na empresa: XXXXXX,
//
//Endereço: Rua Virgilio Tavora
//Bairro: Aldeota
//Cidade: Fortaleza
//
//Usuário: Francisco Pereira
//Email: franciscopereira@gmail.com
//
//Quantidade de pontos: 30
