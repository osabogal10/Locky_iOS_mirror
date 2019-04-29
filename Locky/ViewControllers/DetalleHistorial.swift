//
//  DetalleHistorial.swift
//  Locky
//
//  Created by Reyes on 4/28/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit

class DetalleHistorial: UIViewController {
    var reserva : ReservaHistorial = ReservaHistorial(locker_id: 0, usuario_id: 0, precio_total: 0, tiempo_fin: "nada", tiempo_inicio: "nada", tiempo_retorno: "nada", nombre_lugar: "nada")
    
    @IBOutlet weak var labPrecio: UILabel!
    @IBOutlet weak var labFin: UILabel!
    @IBOutlet weak var labInicio: UILabel!
    @IBOutlet weak var labId: UILabel!
    @IBOutlet weak var labLugar: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        labPrecio.text = "\(reserva.precio_total!)"
        labId.text = "\(reserva.locker_id!)"
        labLugar.text = reserva.nombre_lugar!
        labFin.text = reserva.tiempo_retorno!
        labInicio.text = reserva.tiempo_inicio!
        // Do any additional setup after loading the view.
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
