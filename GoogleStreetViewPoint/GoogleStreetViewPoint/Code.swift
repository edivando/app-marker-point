//
//  Code.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 3/22/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import Foundation

class Code{
    
//    Code: C[dia]R[ano]-T[mês]V
//    [dia]     -> Dia do mês [hoje]
//    [mês]   -> Mês atual
//    [ano]	    -> Ano Atual
//    
//    Exemplo: hoje é 22/03/2016
//    C22R16-T03V
    
    
    static func getCode() -> String{
        var day = ""
        var month = ""
        var year = ""
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd"
        day = formatter.stringFromDate(NSDate())
        
        formatter.dateFormat = "MM"
        month = formatter.stringFromDate(NSDate())
        
        formatter.dateFormat = "yy"
        year = formatter.stringFromDate(NSDate())
        
        return "C\(day)R\(year)-T\(month)V"
    }
    
}
