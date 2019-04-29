//
//  MyLocker.swift
//  Locky
//
//  Created by Orlando Sabogal Rojas on 3/16/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit



class MyLocker: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableView: UITableView!

    
    
    var imagen :UIImageView? = nil

    let imagenAccessoryView = UIImage(named: "ruta")
    let vacio = ReservaHistorial(locker_id: 0, usuario_id: 0, precio_total: 0, tiempo_fin: "", tiempo_inicio: "", tiempo_retorno: "", nombre_lugar: "No tienes reservas activas")
    var reservas: [ReservaHistorial] = []
    let net : NetworkManager = NetworkManager()
    let preferences = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        reservas  = [vacio]
        /*
        let net : NetworkManager = NetworkManager()
        net.getHistorialReservas(byId: "1") {(reservas) in
            if let respuesta = reservas?.first {
                print(respuesta)
            } else {
                print("gg")
            }
        }*/
        
        
        
        super.viewDidLoad()
        self.TableView.delegate = self
        self.TableView.dataSource = self
        //getReservas()
        //self.inicializarLockers(pLugarLockers: "Parque Germania")
        //self.agregarReservacionLocker(pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321)
        //self.agregarReservacionUsuario(pIdUsuario: "EstebanR1099", pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321, pPrecioTotal: 5000.0)
        //self.agregarReservacionReservaciones(pIdUsuario: "EstebanR1099", pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321, pPrecioTotal: 5000.0)
        
        // Do any additional setup after loading the view.
        //self.inicializarReservasUsuario(pUsuarioConsulta: "EstebanR1099")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Aca pasan cosas")
        getReservas()
    }
    
    //Jugano con firebase.
    
    @IBAction func refreshButton(_ sender: Any) {
        getReservas()
    }
    
    
    func getReservas(){
        var user_id:String = "1"
        if preferences.object(forKey: "idPerfil") == nil {
            //  Doesn't exist
            print("Perrito no encontro nada con esa key")
        } else {
            user_id = "\((preferences.object(forKey: "idPerfil") as? Int)!)"
        }
        net.getReservasActuales(byId: user_id) { (response) in
            print("Hay \(response?.count) reservas")
            if (response?.count)! > 0{
                self.reservas = response!
            }
            else{
                self.reservas = [self.vacio]
            }
            self.TableView.reloadData()
        }
    }
    
    //--- leer las reservas de un usuario
/*
    func inicializarReservasUsuario(pUsuarioConsulta :String) {
        descargarReservasUsuario(pUsuario: pUsuarioConsulta) {arreglo in
            self.reservas = arreglo
            if self.reservas.count > 1 {
                self.reservas.remove(at: 0)
            }
            self.TableView.reloadData()
        }
    }
    
    
    func descargarReservasUsuario(pUsuario :String, completion: @escaping ([Reserva]) -> Void) {
        var reservaArray :[Reserva] = [Reserva(pId: "Aun no tiene reservas", pIdLocker: "", pIdUsuario: "", pLugarReserva: "", pPrecioTotal: 0.0, pTiempoFin: 0, pTiempoInicio: 0, pTiempoRetorno: 0)]
        ref.child("Usuarios").child(pUsuario).queryOrderedByKey().observe( .value, with: { (snapshot) in
            if let snap = snapshot.value as? [String : AnyObject] {
                if let reservas = snap["Reservaciones"] as? [String : AnyObject] {
                    for reserva in reservas {
                        let idReserva = reserva.key
                        if var infoReserva = reserva.value as? [String : AnyObject] {
                            let idLocker = infoReserva["idLocker"] as? String
                            let idUsuario = infoReserva["idUsuario"] as? String
                            let lugarReserva = infoReserva["lugarReserva"] as? String
                            let precioTotal = infoReserva["precioTotal"] as? Double
                            let tiempoFin = infoReserva["tiempoFin"] as? Int
                            let tiempoInicio = infoReserva["tiempoInicio"] as? Int
                            let tiempoRetorno = infoReserva["tiempoRetorno"] as? Int
                            
                            let reservaAgregar = Reserva(pId: idReserva, pIdLocker: idLocker!, pIdUsuario: idUsuario!, pLugarReserva: lugarReserva!, pPrecioTotal: precioTotal!, pTiempoFin: tiempoFin!, pTiempoInicio: tiempoInicio!, pTiempoRetorno: tiempoRetorno!)
                            print("\(reservaAgregar.id)")
                            if self.estaYaEsaReserva(array: reservaArray, idReserva: idReserva) == false {
                                reservaArray.append(reservaAgregar)
                            }
                        }
                    }
                }
            }else{
                print("No entro ----")
            }
            self.TableView.reloadData()
            completion (reservaArray)
        }) { (error) in
            print("Hubo un error cargardo el locker -----")
        }
    }
 
 */
    func estaYaEsaReserva (array :[Reserva], idReserva :String) -> Bool {
        for reserva in array {
            if reserva.id == idReserva {
                return true
            }
        }
        return false
    }
    //Crear la tableView de perfil
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell\(indexPath.row)")
        cell.textLabel?.text = self.reservas[indexPath.row].nombre_lugar
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        imagen = UIImageView(image: UIImage(named: "locker"))
        let templateImagen = imagen!.image?.withRenderingMode(.alwaysTemplate)
        imagen!.image = templateImagen
        imagen!.tintColor = UIColor.blue
        cell.imageView?.image = imagen!.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "MyLocker", bundle: nil)
        let dVc = storyBoard.instantiateViewController(withIdentifier: "DetailMyLockerController") as! DetailMyLockerController
        dVc.reserva = self.reservas[indexPath.row]
        self.navigationController?.pushViewController(dVc, animated: true )
        
    }
    
}

