//
//  UsuarioBack.swift
//  Locky
//
//  Created by Orlando Sabogal Rojas on 4/28/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import Foundation

class UsuarioBack: NSObject, Codable {
    var id:Int
    var nombre:String
    var celular: String
    var genero: String
    var fechaNacimiento:String
    var ocupacion:String
    var email:String
    var photoUrl:String
}
