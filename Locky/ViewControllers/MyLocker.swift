//
//  MyLocker.swift
//  Locky
//
//  Created by Orlando Sabogal Rojas on 3/16/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit
import Firebase


class MyLocker: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TableView: UITableView!
    var ref :DatabaseReference!
    var imagen :UIImageView? = nil
    let listaCeldas = ["Reserva 1", "Reserva 2", "Reserva 3"]
    let imagenAccessoryView = UIImage(named: "ruta")
    var lockerLibre :Locker = Locker(pId: "PRUEBA", pNumero: 0, pTamano: "", pPrecio: 0.0, pEstado: "", pLugar: "", pReservas: [ReservaHora]())
    var data :[Locker] = [Locker(pId: "PRUEBA", pNumero: 0, pTamano: "", pPrecio: 0.0, pEstado: "", pLugar: "", pReservas: [ReservaHora]())]
    var reservas :[Reserva] = [Reserva(pId: "Aun no tiene reservas", pIdLocker: "", pIdUsuario: "", pLugarReserva: "", pPrecioTotal: 0.0, pTiempoFin: 0, pTiempoInicio: 0, pTiempoRetorno: 0)]
    
    
    
    override func viewDidLoad() {
        /*
        let net : NetworkManager = NetworkManager()
        net.getHistorialReservas(byId: "1") {(reservas) in
            if let respuesta = reservas?.first {
                print(respuesta)
            } else {
                print("gg")
            }
        }*/
        let net : NetworkManager = NetworkManager()
        net.postFinReserva(forIdReserva: 4, precioTotal: 10000 ) {(reserva) in
            if let respuesta = reserva?.tiempoRetorno{
                print(respuesta)
            } else {
                print("gg")
            }
        }
        
        super.viewDidLoad()
        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.ref = Database.database().reference()
        //self.inicializarLockers(pLugarLockers: "Parque Germania")
        //self.agregarReservacionLocker(pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321)
        //self.agregarReservacionUsuario(pIdUsuario: "EstebanR1099", pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321, pPrecioTotal: 5000.0)
        //self.agregarReservacionReservaciones(pIdUsuario: "EstebanR1099", pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321, pPrecioTotal: 5000.0)
        
        // Do any additional setup after loading the view.
        self.inicializarReservasUsuario(pUsuarioConsulta: "EstebanR1099")
        
    }
    
    //Jugano con firebase.
    
    //Agregar un usuario -- toca mejorarlo segunda entrega
    func agregarUsuario() {
        self.ref.child("Usuarios/EstebanR1099/nombre").setValue("Esto es una prueba")
    }
    
    //Agregar una reserva al sistema
    func agregarReservacionAlSistema(idUsuario :String, lugar :String, locker :String, idReserva :String, tiempoInicio :Int, tiempoFin :Int, precioTotal :Double) {
        print("Va a agregar una reservacion al sistemas")
        
        self.agregarReservacionLocker(pLugar: lugar, pLocker: locker, pIdReserva: idReserva, pTiempoInicio: tiempoInicio, pTiempoFin: tiempoFin)
        self.agregarReservacionUsuario(pIdUsuario: idUsuario, pLugar: lugar, pLocker: locker, pIdReserva: idReserva, pTiempoInicio: tiempoInicio, pTiempoFin: tiempoFin, pPrecioTotal: precioTotal)
        self.agregarReservacionReservaciones(pIdUsuario: idUsuario, pLugar: lugar, pLocker: locker, pIdReserva: idReserva, pTiempoInicio: tiempoInicio, pTiempoFin: tiempoFin, pPrecioTotal: precioTotal)
        
        print("Agrego una reservacion al sistema")
    }
    
    //Agregar una reservacion al locker.
    func agregarReservacionLocker(pLugar :String, pLocker :String, pIdReserva :String, pTiempoInicio :Int, pTiempoFin :Int) {
        print("Va a agregar una reservacion a un locker")
        self.ref.child("Lugares").child(pLugar).child("Lockers").child(pLocker).child("Reservaciones").child(pIdReserva).setValue(["id":pIdReserva, "tiempoFin":pTiempoFin, "tiempoInicio":pTiempoInicio])
        
        self.ref.child("Lugares").child(pLugar).child("Lockers").child(pLocker).child("estado").setValue("Reservado")
        
        print("Agrego una reservacion a un locker")
    }
    //Agregar una reservacion al usuario.
    func agregarReservacionUsuario(pIdUsuario :String, pLugar :String, pLocker :String, pIdReserva :String, pTiempoInicio :Int, pTiempoFin :Int, pPrecioTotal :Double) {
        print("Va a agregar una reservacion a un usuario")
        self.ref.child("Usuarios").child(pIdUsuario).child("Reservaciones").child(pIdReserva).setValue(["id":pIdReserva, "idLocker":pLocker, "idUsuario":pIdUsuario, "lugarReserva":pLugar, "precioTotal":pPrecioTotal, "tiempoFin":pTiempoFin, "tiempoInicio":pTiempoInicio, "tiempoRetorno":0])
        
        print("Agrego una reservacion a un usuario")
    }
    //Agrega una reservacion a las reservaciones
    func agregarReservacionReservaciones(pIdUsuario :String, pLugar :String, pLocker :String, pIdReserva :String, pTiempoInicio :Int, pTiempoFin :Int, pPrecioTotal :Double) {
        print("Va a agregar una reservacion a reservas")
        self.ref.child("Reservaciones").child(pIdReserva).setValue(["id":pIdReserva, "idLocker":pLocker, "idUsuario":pIdUsuario, "lugarReserva":pLugar, "precioTotal":pPrecioTotal, "tiempoFin":pTiempoFin, "tiempoInicio":pTiempoInicio, "tiempoRetorno":0])
        
        print("Agrego una reservacion a un reservas")
    }
    
    //--- leer los lockers de un lugar
    func inicializarLockers(pLugarLockers :String) {
        descargarLockersLugar(pLugar: pLugarLockers){arreglo in
            self.data = arreglo
            self.TableView.reloadData()
            print("\(self.data.count) numero elementos data OUT")
            self.filtarLocker(pTamano: "Grande", pTiempoInicio: 123456789, pTiempoFin: 987654321)
            print("\(self.lockerLibre.id) ---- el id del locker que se encuentra libre")
            //Hacer las funciones para filtrar
        }
    }
    
    
    func descargarLockersLugar(pLugar :String, completion: @escaping ([Locker]) -> Void) {
        var lockerArray = [Locker] ()
        ref.child("Lugares").child("\(pLugar)").queryOrderedByKey().observe( .value, with: { (snapshot) in
            // Get locker value
            if var snap = snapshot.value as? [String : AnyObject] {
                let lugar = snapshot.key
                print("\(lugar)--------------------------lugar")
                if let lockers = snap["Lockers"] as? [String : AnyObject] {
                    for locker in lockers {
                        if var infoLocker = locker.value as? [String : AnyObject] {
                            let idLocker = locker.key
                            let numero = infoLocker["numero"] as? Int
                            let estado = infoLocker["estado"] as? String
                            let precio = infoLocker["precioHora"] as? Double
                            let tamano = infoLocker["tamano"] as? String
                            print("\(idLocker)--------------------------id locker")
                            print("\(numero!)--------------------------numero")
                            print("\(estado!)--------------------------estado")
                            print("\(precio!)--------------------------precio")
                            print("\(tamano!)--------------------------tamano")
                            var listaReservasLocker :[ReservaHora] = []
                            var reservaLocker :ReservaHora? = nil
                            if let reservas = infoLocker["Reservaciones"] as? [String : AnyObject] {
                                for reserva in reservas {
                                    print("Reservaciones")
                                    if var infoReserva = reserva.value as? [String : AnyObject] {
                                        let idReserva = reserva.key
                                        let horaInicio = infoReserva["tiempoInicio"] as? Int
                                        let horaFin = infoReserva["tiempoFin"] as? Int
                                        print("\(idReserva)--------------------------id reserva")
                                        print("\(horaInicio!)--------------------------hora inicio")
                                        print("\(horaFin!)--------------------------hora fin")
                                        reservaLocker = ReservaHora(pId: idReserva, pHoraInicio: horaInicio!, pHoraFin: horaFin!)
                                        listaReservasLocker.append(reservaLocker!)
                                    }
                                }
                            }
                            let locker :Locker = Locker(pId: idLocker, pNumero: numero!, pTamano: tamano!, pPrecio: precio!, pEstado: estado!, pLugar: lugar, pReservas: listaReservasLocker)
                            print("\(locker)-------------------------- Locker")
                            lockerArray.append(locker)
                        }
                    }
                }
            }
            self.TableView.reloadData()
            completion (lockerArray)
        }) { (error) in
            print("Hubo un error cargardo el locker -----")
        }
    }
    
    //Filtar el primer locker libre que cumpla con el tamano y
    func filtarLocker(pTamano :String, pTiempoInicio :Int, pTiempoFin :Int) {
        if self.data.isEmpty == false {
            var tamano :String
            var tiempoInicio :Int
            var estaSinReserva :Bool = true
            var tiempoFin :Int
            for locker in self.data {
                if locker.estado == "Disponible" {
                    tamano = locker.tamano
                    if tamano == pTamano {
                        for reserva in locker.reservas {
                            tiempoInicio = reserva.horaInicio
                            tiempoFin = reserva.horaFin
                            if (tiempoInicio < pTiempoInicio && tiempoFin < pTiempoInicio) || (tiempoInicio > pTiempoInicio && tiempoFin > pTiempoFin){
                                estaSinReserva = true
                            } else{
                                estaSinReserva = false
                                break
                            }
                        }
                        if estaSinReserva == true {
                            self.lockerLibre = locker
                            break
                        }
                    }
                }
            }
        }
    }
    
    //--- leer las reservas de un usuario
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
        cell.textLabel?.text = self.reservas[indexPath.row].lugarReserva
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

