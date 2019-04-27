//
//  Lugar.swift
//  Locky
//
//  Created by Reyes on 3/19/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit

class Lugar: NSObject {
    var id :String
    var latitud :Double
    var longitud :Double
    var descripcion :String
    var foto :String
    var tipo :String
    var localidad:String
    var locker :[String]
    
    init(pId :String, pLatitud :Double, pLongitud :Double, pDescripcion :String, pFoto :String, pTipo :String, pLocalidad :String, pLocker : [String]) {
        id = pId
        latitud = pLatitud
        longitud = pLongitud
        descripcion = pDescripcion
        foto = pFoto
        tipo = pTipo
        localidad = pLocalidad
        locker = pLocker
    }
    
}
