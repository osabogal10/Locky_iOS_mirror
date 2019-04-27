//
//  ReservaHora.swift
//  Locky
//
//  Created by Reyes on 3/22/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit

class ReservaHora: NSObject {
    var id :String
    var horaInicio :Int
    var horaFin :Int
    
    init(pId :String, pHoraInicio :Int, pHoraFin :Int) {
        id = pId
        horaInicio = pHoraInicio
        horaFin = pHoraFin
    }
    
}
