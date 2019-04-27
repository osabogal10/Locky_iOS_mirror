//
//  Locker.swift
//  Locky
//
//  Created by Reyes on 3/19/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//
import Foundation
import UIKit

class Locker: NSObject {
    var id :String
    var numero :Int
    var tamano :String
    var precio :Double
    var estado :String
    var lugar :String
    var reservas :[ReservaHora]
    
    init(pId:String, pNumero :Int, pTamano :String, pPrecio :Double, pEstado :String, pLugar :String, pReservas :[ReservaHora]) {
        id = pId
        numero = pNumero
        tamano = pTamano
        precio = pPrecio
        estado = pEstado
        lugar = pLugar
        reservas = pReservas
    }
    
}
