//
//  ProfileTableViewController.swift
//  Locky
//
//  Created by Reyes on 3/16/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit
import Firebase


class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var urlImagen :String? = "Paila no cargo"
    var emailPerfil :String? = "Paila no cargo"
    var namePerfil :String? = "Paila no cargo"
  
    @IBOutlet weak var labName: UILabel!
    @IBOutlet weak var labEmail: UILabel!
    @IBOutlet weak var imagenProfile: UIImageView!
    
    @IBOutlet weak var TableView: UITableView!
    var ref :DatabaseReference!
    var imagen :UIImageView? = nil
    let listaCeldas = ["Como funciona locky", "Historial", "Cerrar sesión"]
    let imagenAccessoryView = UIImage(named: "ruta")
    var lockerLibre :Locker = Locker(pId: "PRUEBA", pNumero: 0, pTamano: "", pPrecio: 0.0, pEstado: "", pLugar: "", pReservas: [ReservaHora]())
    var data :[Locker] = [Locker(pId: "PRUEBA", pNumero: 0, pTamano: "", pPrecio: 0.0, pEstado: "", pLugar: "", pReservas: [ReservaHora]())]


    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.ref = Database.database().reference()
        
        let preferences = UserDefaults.standard
        
        let key = "urlImagenPerfil"
        
        if preferences.object(forKey: key) == nil {
            //  Doesn't exist
            print("Perrito no encontro nada con esa key")
        } else {
            self.urlImagen = preferences.object(forKey: key) as? String
        }
        
        if preferences.object(forKey: "emailPerfil") == nil {
            //  Doesn't exist
            print("Perrito no encontro nada con esa key")
        } else {
            self.emailPerfil = preferences.object(forKey: "emailPerfil") as? String
        }
        
        if preferences.object(forKey: "namePerfil") == nil {
            //  Doesn't exist
            print("Perrito no encontro nada con esa key")
        } else {
            self.namePerfil = preferences.object(forKey: "namePerfil") as? String
        }
        
        self.labName!.text = self.emailPerfil!
        self.labEmail!.text = self.namePerfil!
        
        get_image(self.urlImagen!, self.imagenProfile)
        
        //self.inicializarLockers(pLugarLockers: "Parque Germania")
        //self.agregarReservacionLocker(pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321)
        //self.agregarReservacionUsuario(pIdUsuario: "EstebanR1099", pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321, pPrecioTotal: 5000.0)
        //self.agregarReservacionReservaciones(pIdUsuario: "EstebanR1099", pLugar: "Parque de la 93", pLocker: "Parque de la 93 - locker3", pIdReserva: "idReserva", pTiempoInicio: 123456789, pTiempoFin: 987654321, pPrecioTotal: 5000.0)
        
        // Do any additional setup after loading the view.
    }
    
    func setUrlImage (urlImagen : String)
    {
        print("Entro a actualizar la URL de la imagen de perfil")
        self.urlImagen = urlImagen
        print("La url despues de la actualizacion fue: \(self.urlImagen)")
        
    }
    
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {
            (
            data, response, error) in
            
            
            if data != nil
            {
                let image = UIImage(data: data!)
                
                if(image != nil)
                {
                    
                    DispatchQueue.main.async(execute: {
                        
                        imageView.image = image
                        imageView.alpha = 0
                        
                        UIView.animate(withDuration: 2.5, animations: {
                            imageView.alpha = 1.0
                        })
                        
                    })
                    
                }
                
            }
            
            
        })
        
        task.resume()
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
                }
                if estaSinReserva == true {
                    self.lockerLibre = locker
                    break
                }
            }
        }
    }
    
    //Crear la tableView de perfil
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaCeldas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell\(indexPath.row)")
        cell.textLabel?.text = self.listaCeldas[indexPath.row]
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        let idCell = cell.reuseIdentifier!
        switch idCell {
        case "cell0":
            imagen = UIImageView(image: UIImage(named: "profile-cell-funcionamiento"))
            let templateImagen = imagen!.image?.withRenderingMode(.alwaysTemplate)
            imagen!.image = templateImagen
            imagen!.tintColor = UIColor.blue
            cell.imageView?.image = imagen!.image
        case "cell1":
            imagen = UIImageView(image: UIImage(named: "profile-cell-historial"))
            let templateImagen = imagen!.image?.withRenderingMode(.alwaysTemplate)
            imagen!.image = templateImagen
            imagen!.tintColor = UIColor.blue
            cell.imageView?.image = imagen!.image
        case "cell2":
            imagen = UIImageView(image: UIImage(named: "profile-cell-cerrarsesion"))
            let templateImagen = imagen!.image?.withRenderingMode(.alwaysTemplate)
            imagen!.image = templateImagen
            imagen!.tintColor = UIColor.blue
            cell.imageView?.image = imagen!.image
        default:
            return cell
        }
        return cell
    }
    

}
