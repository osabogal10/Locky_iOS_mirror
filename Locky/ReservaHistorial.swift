

import Foundation


class ReservaHistorial: NSObject, Codable {
    var id :Int?
    var locker_id :Int?
    var usuario_id :Int?
    var precio_total :Int?
    var tiempo_fin :String?
    var tiempo_inicio :String?
    var tiempo_retorno :String?
    var nombre_lugar :String?
    
    init(locker_id: Int, usuario_id:Int, precio_total:Int, tiempo_fin:String,tiempo_inicio:String,tiempo_retorno:String, nombre_lugar:String) {
        self.locker_id=locker_id
        self.usuario_id=usuario_id
        self.precio_total=precio_total
        self.tiempo_fin=tiempo_fin
        self.tiempo_inicio=tiempo_inicio
        self.tiempo_retorno=tiempo_retorno
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

