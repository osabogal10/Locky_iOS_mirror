//
//  Usuarios.swift
//  Locky
//
//  Created by Reyes on 3/19/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit

class Uuario: NSObject {
    var id :String
    var nombre :String
    var telefono :String
    var genero :String
    var nacimiento :Date
    var ocupacion :String
    var locky :String
    var reservas :[String]
    
    init(pId :String, pNombre :String, pTelefono :String, pGenero :String, pNacimiento :Date, pOcupacion :String, pLocky :String, pReservas :[String]) {
        id = pId
        nombre = pNombre
        telefono = pTelefono
        genero = pGenero
        nacimiento = pNacimiento
        ocupacion = pOcupacion
        locky = pLocky
        reservas = pReservas
    }

}
