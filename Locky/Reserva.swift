//
//  Reserva.swift
//  Locky
//
//  Created by Reyes on 3/26/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit

class Reserva: NSObject {
    var id :String
    var idLocker :String
    var idUsuario :String
    var lugarReserva :String
    var precioTotal :Double
    var tiempoFin :Int
    var tiempoInicio :Int
    var tiempoRetorno :Int
    
    init(pId :String, pIdLocker :String, pIdUsuario :String, pLugarReserva :String, pPrecioTotal :Double, pTiempoFin :Int, pTiempoInicio :Int, pTiempoRetorno :Int) {
        id = pId
        idLocker = pIdLocker
        idUsuario = pIdUsuario
        lugarReserva = pLugarReserva
        precioTotal = pPrecioTotal
        tiempoFin = pTiempoFin
        tiempoInicio = pTiempoInicio
        tiempoRetorno = pTiempoRetorno
    }
}

