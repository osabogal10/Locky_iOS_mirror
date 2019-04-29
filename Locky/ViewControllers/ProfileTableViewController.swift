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
    
    var reservas: [ReservaHistorial] = []
    let net : NetworkManager = NetworkManager()
  
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

    let preferences = UserDefaults.standard

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.TableView.delegate = self
        self.TableView.dataSource = self
        self.ref = Database.database().reference()
        
        let preferences = UserDefaults.standard
        
      
        
        if preferences.object(forKey: "urlImagenPerfil") == nil {
            //  Doesn't exist
            print("Perrito no encontro nada con esa key")
        } else {
            self.urlImagen = preferences.object(forKey: "urlImagenPerfil") as? String
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
        if (self.urlImagen != "nada") {
            get_image(self.urlImagen!, self.imagenProfile)
        } else {
            self.imagenProfile!.image = UIImage(named: "user_male")
            let templateImagen = self.imagenProfile!.image?.withRenderingMode(.alwaysTemplate)
            self.imagenProfile!.image = templateImagen
            self.imagenProfile!.tintColor = UIColor.blue
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Entro a seleccionar una celda del tableView de profile")
        let index = indexPath.row
        print("El index es: \(index)")
        switch index {
        case 0:
            print("Entro 0")
            let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
            let dVc = storyBoard.instantiateViewController(withIdentifier: "FuncionaLockyController") as! FuncionaLockyController
            self.navigationController?.pushViewController(dVc, animated: true )
        case 1:
            getReservas()
        case 2:
            
            let preferences = UserDefaults.standard
            
            
            preferences.set("nada", forKey: "urlImagenPerfil")
            preferences.set("nada", forKey: "emailPerfil")
            preferences.set("nada", forKey: "namePerfil")
            
            
            //  Save to disk
            let didSave = preferences.synchronize()
            
            if !didSave {
                //  Couldn't save (I've never seen this happen in real world testing)
                print("No guardo en las preferencias")
            }
            
            
            if preferences.object(forKey: "manera") as? String == "facebook" {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let dVc = storyBoard.instantiateViewController(withIdentifier: "MainController") as! LaunchController
                dVc.cerrarFacebook()
            } else {
                
            }
            preferences.set("nada", forKey: "manera")
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let dVc = storyBoard.instantiateViewController(withIdentifier: "MainController") as! LaunchController
            self.present(dVc, animated: true, completion: nil)
            
        default:
            return
        }
    }
    
    func getReservas(){
        var user_id:String = "1"
        if preferences.object(forKey: "idPerfil") == nil {
            //  Doesn't exist
            print("Perrito no encontro nada con esa key")
        } else {
            user_id = "\((preferences.object(forKey: "idPerfil") as? Int)!)"
        }
        net.getHistorialReservas(byId: user_id) { (response) in
            print("Hay \(response?.count) reservas en el historial")
            if (response?.count)! > 0{
                self.reservas = response!
                print(self.reservas[0].nombre_lugar)
            }
            else{
                let vacio = ReservaHistorial(locker_id: 0, usuario_id: 0, precio_total: 0, tiempo_fin: "", tiempo_inicio: "", tiempo_retorno: "", nombre_lugar: "No tienes reservas activas")
                self.reservas = [vacio]
            }
            let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
            let dVc = storyBoard.instantiateViewController(withIdentifier: "HistorialReservaController") as! HistorialReservaController
            dVc.listaCeldas = self.reservas
            self.navigationController?.pushViewController(dVc, animated: true )
        }
    }

}
