//
//  DetailMyLockerController.swift
//  Locky
//
//  Created by Reyes on 3/26/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit

class DetailMyLockerController: UIViewController {

    var reserva :ReservaHistorial? = nil
    
    @IBOutlet weak var botonAbrir: UIButton!
    @IBOutlet weak var botonDevolver: UIButton!
    @IBOutlet weak var labelIdLocker: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var labelTiempoRestante: UILabel!
    @IBOutlet weak var labelPrecioTotal: UILabel!
    
    let net : NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelIdLocker.text! = "Casillero No: \(reserva!.locker_id ?? 1)"
        labelLugar.text! = reserva!.nombre_lugar!
        labelPrecioTotal.text! = "$\(reserva!.precio_total ?? 0)"
        let dateFormatter = DateFormatter()
        //2019-04-18T18:11
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //let dateInicio = dateFormatter.date(from: (reserva?.tiempo_inicio)!)
        var dateFin = dateFormatter.date(from: (reserva?.tiempo_fin)!)
        
        dateFin = addHours(hours: 5,date:dateFin!)
        let seconds = (dateFin?.timeIntervalSince(Date()))!
        let (h,m) = secondsToHoursMinutes(seconds: Int(seconds))
        if(seconds<0){
            labelTiempoRestante.textColor = UIColor.red
        }
        labelTiempoRestante.text! = "\(h) Horas \(m) minutos"
        
        // Do any additional setup after loading the view.
    }
    @IBAction func entregarLocker(_ sender: Any) {
        print("Id:\(reserva?.id)")
        print("Precio:\(reserva?.precio_total)")
        print("locker:\(reserva?.locker_id)")
        net.postFinReserva(forIdReserva: (reserva?.id)!, precioTotal: (reserva?.precio_total)! ) {(reserva,executed) in
            if let respuesta = reserva?.tiempoRetorno{
                print(respuesta)
                self.navigationController?.popViewController(animated: true)
            } else{
                print("No se pudo devolver Reserva",executed)
                if executed == false {
                    self.genderAlert(message: "No estas conectado a internet. Intenta mas tarde.",title: "Sin conexión")
                }
                else{
                    self.genderAlert(message: "No pudimos terminar tu reserva. Contacta a soporte.", title: "Error")
                }
            }
        }
    }
    
    func secondsToHoursMinutes (seconds: Int) -> (Int,Int){
        return (seconds/3600,(seconds%3600)/60)
    }
    
    func addHours(hours:Int,date:Date) -> Date{
        return (Calendar.current as NSCalendar).date(byAdding: .hour, value: hours, to: date)!
    }
    
    func genderAlert(message: String, title:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    //Jugando con firebase
    
    //Devolver el locker
    
    //Cambiar tiempo retorno en la reservaciones y en la de usuarios. El estado del casillero paso a disponible.
        /*
    self.ref.child("Lugares").child(reserva!.lugarReserva).child("Lockers").child(reserva!.idLocker).child("estado").setValue("Disponible")
        
        let calendar = Calendar.current
        let rightNow = Date()
        let composedDate = calendar.date(from: DateComponents(calendar: calendar, year: 1970, month: 1, day: 1))
        let longTime = calendar.dateComponents([.minute], from: composedDate!, to: rightNow).minute
        let tiempoRetorno = longTime!*60000
        
        self.ref.child("Reservaciones").child(reserva!.id).child("tiempoRetorno").setValue(tiempoRetorno)
        self.ref.child("Usuarios").child(reserva!.idUsuario).child("Reservaciones").child(reserva!.id).child("tiempoRetorno").setValue(tiempoRetorno)
    }
    
    */
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
