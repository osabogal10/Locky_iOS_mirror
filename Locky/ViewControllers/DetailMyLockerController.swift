//
//  DetailMyLockerController.swift
//  Locky
//
//  Created by Reyes on 3/26/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit
import Firebase

class DetailMyLockerController: UIViewController {
    var ref :DatabaseReference!
    var reserva :Reserva? = nil
    
    @IBOutlet weak var botonAbrir: UIButton!
    @IBOutlet weak var botonDevolver: UIButton!
    @IBOutlet weak var labelIdLocker: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var labelTiempoRestante: UILabel!
    @IBOutlet weak var labelPrecioTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        labelIdLocker.text! = reserva!.idLocker
        labelLugar.text! = reserva!.lugarReserva
        labelPrecioTotal.text! = String(reserva!.precioTotal)
        let calendar = Calendar.current
        let rightNow = Date()
        let composedDate = calendar.date(from: DateComponents(calendar: calendar, year: 1970, month: 1, day: 1))
        let longTime = calendar.dateComponents([.minute], from: composedDate!, to: rightNow).minute
        let tiempoActual = longTime!*60000
        let tiempoRestante = ((reserva!.tiempoFin) - (tiempoActual))
        labelTiempoRestante.text! = "\((tiempoRestante/60000)) min"
        self.imprimirFechaMilis()
        // Do any additional setup after loading the view.
    }
    @IBAction func entregarLocker(_ sender: Any) {
        self.devolverLockers()
    }
    //Como funciona la hora en swift
    func imprimirFechaMilis() {
        let calendar = Calendar.current
        let rightNow = Date()
        let composedDate = calendar.date(from: DateComponents(calendar: calendar, year: 1970, month: 1, day: 1))
        let longTime = calendar.dateComponents([.minute], from: composedDate!, to: rightNow).minute
        
        print("\(longTime!*60000)")
    }
    //Jugando con firebase
    
    //Devolver el locker
    
    //Cambiar tiempo retorno en la reservaciones y en la de usuarios. El estado del casillero paso a disponible.
    func devolverLockers() {
    self.ref.child("Lugares").child(reserva!.lugarReserva).child("Lockers").child(reserva!.idLocker).child("estado").setValue("Disponible")
        
        let calendar = Calendar.current
        let rightNow = Date()
        let composedDate = calendar.date(from: DateComponents(calendar: calendar, year: 1970, month: 1, day: 1))
        let longTime = calendar.dateComponents([.minute], from: composedDate!, to: rightNow).minute
        let tiempoRetorno = longTime!*60000
        
        self.ref.child("Reservaciones").child(reserva!.id).child("tiempoRetorno").setValue(tiempoRetorno)
        self.ref.child("Usuarios").child(reserva!.idUsuario).child("Reservaciones").child(reserva!.id).child("tiempoRetorno").setValue(tiempoRetorno)
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
