//
//  NetworkManager.swift
//  Locky
//
//  Created by Orlando Sabogal Rojas on 4/26/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import Alamofire

class NetworkManager: NSObject {
    
    private enum NetworkPath: String {
        case finReserva = "reservas/terminar"
        case reservas = "reservas/"
        case crearReserva = "reservas/crear"
        case usuarios = "usuarios/"
        
        static let baseURL = "https://locky-back.herokuapp.com/api/"
        //static let baseURL = "http://localhost:3000/api/"
        
        var url: String {
            return NetworkPath.baseURL + self.rawValue
        }
    }
    
    func getUsuario(byEmail: String, completion: @escaping(UsuarioBack?) -> Void) {
        let urlString = NetworkPath.usuarios.url+byEmail
        Alamofire.request(urlString).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let usuario = try decoder.decode(UsuarioBack.self, from: data)
                
                completion(usuario)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
    
    // MARK:- ReservaBack services
    func getHistorialReservas(byId ReservaBackId: String, completion: @escaping ([ReservaHistorial]?) -> Void) {
        let urlString = NetworkPath.reservas.url + ReservaBackId + "/historial"
        Alamofire.request(urlString).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let reservas = try decoder.decode([ReservaHistorial].self, from: data)
                
                completion(reservas)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
    
    func getReservasActuales(byId ReservaBackId: String, completion: @escaping ([ReservaHistorial]?) -> Void) {
        let urlString = NetworkPath.reservas.url + ReservaBackId + "/actuales"
        Alamofire.request(urlString).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let reservas = try decoder.decode([ReservaHistorial].self, from: data)
                
                completion(reservas)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }
    
    //Fin reserva
    func postFinReserva(forIdReserva idReserva: Int, precioTotal: Int, completion: @escaping (ReservaBack?, Bool) -> Void) {
        if(Connectivity.isConnected){
            let urlString = NetworkPath.finReserva.url
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            //2019-04-18 18:11:55
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let parameters: Parameters = [
                "idReserva": idReserva,
                "precioTotal": precioTotal,
                "tiempoRetorno": dateFormatter.string(from: currentDate)
            ]
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
                print("Request: \(response.request)")
                print("Response: \(response.response)")
                print("Error: \(response.error)")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let reserva = try decoder.decode(ReservaBack.self, from: data)
                    completion(reserva,true)
                } catch let error {
                    print(error)
                    completion(nil,true)
                }
            }
        }
        else{
            completion(nil,false)
        }
        
    }
    
    func postCrearReserva(tInicio: Date, tFin: Date, precioTotal:Int, tamano:String,nombreLugar:String,usuario_id:Int , completion: @escaping (ReservaBack?, Bool) -> Void) {
        if(Connectivity.isConnected){
            let urlString = NetworkPath.crearReserva.url
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            //2019-04-18 18:11:55
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let parameters: Parameters = [
                "tiempoInicio": dateFormatter.string(from: tInicio),
                "tiempoFin": dateFormatter.string(from: tFin),
                "precioTotal": precioTotal,
                "tamano": tamano,
                "nombreLugar": nombreLugar,
                "usuario_id": usuario_id
            ]
            
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
                print("Request: \(response.request)")
                print("Response: \(response.response)")
                print("Error: \(response.error)")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let reserva = try decoder.decode(ReservaBack.self, from: data)
                    completion(reserva,true)
                } catch let error {
                    print(error)
                    completion(nil,true)
                }
            }
        }
        else{
            completion(nil,false)
        }
    }
    
}

class Connectivity {
    class var isConnected:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

