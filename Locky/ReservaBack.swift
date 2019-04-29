//
//  ReservaBack.swift
//  Locky
//
//  Created by Orlando Sabogal Rojas on 4/24/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import Foundation
//
//  Reserva.swift
//  Locky
//
//  Created by Reyes on 3/26/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

class ReservaBack: NSObject, Codable {
    var id :Int?
    var locker_id :Int?
    var usuario_id :Int?
    var lugar_id :Int?
    var precioTotal :Int?
    var tiempoFin :String?
    var tiempoInicio :String?
    var tiempoRetorno :String?
    var nombre_lugar :String?
    
    init(locker_id: Int, usuario_id:Int, lugar_id:Int, precioTotal:Int, tiempoFin:String,tiempoInicio:String,tiempoRetorno:String, nombre_lugar:String) {
        self.locker_id=locker_id
        self.usuario_id=usuario_id
        self.lugar_id=lugar_id
        self.precioTotal=precioTotal
        self.tiempoFin=tiempoFin
        self.tiempoInicio=tiempoInicio
        self.tiempoRetorno=tiempoRetorno
        self.nombre_lugar=nombre_lugar
    }
    
    /*init(pId :String, pIdLocker :String, pIdUsuario :String, pLugarReserva :String, pPrecioTotal :Double, pTiempoFin :Int, pTiempoInicio :Int, pTiempoRetorno :Int) {
     id = pId
     idLocker = pIdLocker
     idUsuario = pIdUsuario
     lugarReserva = pLugarReserva
     precioTotal = pPrecioTotal
     tiempoFin = pTiempoFin
     tiempoInicio = pTiempoInicio
     tiempoRetorno = pTiempoRetorno
     }*/
}

