//
//  HistorialReservaController.swift
//  Locky
//
//  Created by Reyes on 4/28/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit


class HistorialReservaController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var listaCeldas : [ReservaHistorial] = []
    
    
    @IBOutlet weak var TableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.delegate = self
        self.TableView.dataSource = self
        
        print("La lista de celdas quedo con este numero de elementos: \(listaCeldas.count)")
        print("el primer element es: \(listaCeldas[0].nombre_lugar!)")
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCeldas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell\(indexPath.row)")
        cell.textLabel?.text = self.listaCeldas[indexPath.row].nombre_lugar!

        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Entro a una celda del historial de reservas")
        let storyBoard = UIStoryboard(name: "Detalle", bundle: nil)
        let dVc = storyBoard.instantiateViewController(withIdentifier: "DetalleHistorial") as! DetalleHistorial
        dVc.reserva = self.listaCeldas[indexPath.row]
        print("locker_id es ",dVc.reserva.locker_id)
        if(dVc.reserva.locker_id != 0){
            print("Pushea porque no es 0")
            self.navigationController?.pushViewController(dVc, animated: true )
        }
        
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
