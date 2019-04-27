//
//  ReservarCasilleroControllerViewController.swift
//  Locky
//
//  Created by Reyes on 3/19/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit
import Firebase

class ReservarCasilleroControllerViewController: UIViewController {
    
    var ref: DatabaseReference!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var initTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    var reserva:Reserva?
    
    var cont = 0
    
    var datePicker: UIDatePicker?
    var initTimePicker: UIDatePicker?
    var endTimePicker: UIDatePicker?
    let sizes = ["Grande","Mediano","Pequeño"]
    var selectedSize:String?
    let dateFormatter = DateFormatter()
    
    
    var place = "Un lugar"
    var lockerLibre :Locker = Locker(pId: "PRUEBA", pNumero: 0, pTamano: "", pPrecio: 0.0, pEstado: "", pLugar: "", pReservas: [ReservaHora]())
    var data :[Locker] = [Locker(pId: "PRUEBA", pNumero: 0, pTamano: "", pPrecio: 0.0, pEstado: "", pLugar: "", pReservas: [ReservaHora]())]


    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        createSizePicker()
        
        sizeTextField.text = sizes[0]
        //Crea una referencia a la base de datos.
        self.ref = Database.database().reference()
        print("estoy en Reservar")

        
        // Do any additional setup after loading the view.
        self.title=place
        self.navigationItem.title = place
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReservarCasilleroControllerViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ReservarCasilleroControllerViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker?.minimumDate = Date()
        dateTextField.inputView = datePicker
        dateTextField.text = dateFormatter.string(from: Date())
        
        initTimePicker=UIDatePicker()
        initTimePicker?.datePickerMode = .time
        initTimePicker?.addTarget(self, action: #selector(initTimeChanged(datePicker:)), for: .valueChanged)
        initTimePicker?.minimumDate = Date()
        initTime.inputView = initTimePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        initTime.text = formatter.string(from: Date())
        
        endTimePicker=UIDatePicker()
        endTimePicker?.datePickerMode = .time
        endTimePicker?.addTarget(self, action: #selector(endTimeChanged(datePicker:)), for: .valueChanged)
        endTimePicker?.minimumDate = Date().addingTimeInterval(3600)
        endTime.inputView = endTimePicker
        endTime.text = formatter.string(from: Date().addingTimeInterval(3600))
        
    }
    
    @IBAction func reservarCasillero(_ sender: UIButton) {
        
        //inicializarLockers(pLugarLockers: place)
        //getHistorial()
        postReserva()
        //print("voy al tab 2")
        //tabBarController?.selectedIndex = 1
    }
    
    func postReserva(){
        let urlString = "https://locky-back.herokuapp.com/api/reservas/terminar"
        
        guard let url = URL(string: urlString) else
        {return}
        var request = URLRequest(url: url)
        request.httpMethod="POST"
        do{
            let jsonEncoder = JSONEncoder()
            struct reservaPost: Codable {
                var tiempoRetorno:String
                var precioTotal:Int
                var idReserva:Int
            }
            let jsonData = try jsonEncoder.encode(reservaPost(tiempoRetorno: "2019-04-26 04:20", precioTotal: 10000, idReserva: 3))
            print(jsonData)
            request.httpBody=jsonData
        }
        catch let jsonEncodeError{
            print(jsonEncodeError)
        }
        
        URLSession.shared.dataTask(with: request){
            (data,response,error) in
            guard let data = data, error == nil else
            {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            // let dataAsString = String(data: data, encoding: .utf8)
            // print(dataAsString)
            
            do {
                let reserva:ReservaBack = try
                    JSONDecoder().decode(ReservaBack.self, from: data)
                print("Reserva: ",reserva.tiempoRetorno)
                
            } catch let jsonErr {
                print("El error es: ",jsonErr)
            }
            
            
            }.resume()
    }
        
    
    
    func createSizePicker(){
        let sizePicker = UIPickerView()
        sizePicker.delegate = self
        
        sizeTextField.inputView = sizePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func initTimeChanged(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        initTime.text = formatter.string(from: datePicker.date)
    }
    
    @objc func endTimeChanged(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        endTime.text = formatter.string(from: datePicker.date)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    //Agregar una reserva al sistema
    func agregarReservacionAlSistema(idUsuario :String, lugar :String, locker :String, idReserva :String, tiempoInicio :Int, tiempoFin :Int, precioTotal :Double) {
        print("Va a agregar una reservacion al sistemas")
        
        self.agregarReservacionLocker(pLugar: lugar, pLocker: locker, pIdReserva: idReserva, pTiempoInicio: tiempoInicio, pTiempoFin: tiempoFin)
        self.agregarReservacionUsuario(pIdUsuario: idUsuario, pLugar: lugar, pLocker: locker, pIdReserva: idReserva, pTiempoInicio: tiempoInicio, pTiempoFin: tiempoFin, pPrecioTotal: precioTotal)
        self.agregarReservacionReservaciones(pIdUsuario: idUsuario, pLugar: lugar, pLocker: locker, pIdReserva: idReserva, pTiempoInicio: tiempoInicio, pTiempoFin: tiempoFin, pPrecioTotal: precioTotal)
        
        print("Agrego una reservacion al sistema")
        self.genderAlertReserva()
        /*let storyBoard = UIStoryboard(name: "ReservarCasillero", bundle: nil)
        let dVc = storyBoard.instantiateViewController(withIdentifier: "DetailMyLockerController") as! DetailMyLockerController
        dVc.reserva = self.reserva
        if var topVC = UIApplication.shared.keyWindow?.rootViewController{
            while let presented = topVC.presentedViewController{
                topVC = presentedViewController!
                print(topVC.classForCoder)
            }
        }
        self.navigationController?.pushViewController(dVc, animated: true )*/
        
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
        if self.cont==0{
            descargarLockersLugar(pLugar: pLugarLockers){arreglo in
                self.data = arreglo
                print("\(self.data[0].tamano)")
                print("\(self.data[1].tamano)")
                print("\(self.data.count) numero elementos data OUT")
                
                print("\(self.lockerLibre.id) ---- el id del locker que se encuentra libre")
            
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy 'at' h:mm a"
                let inicioString = self.dateTextField!.text! + " at " + self.initTime.text!
                let finString = self.dateTextField!.text! + " at " + self.endTime.text!
                let tInicio = Int((formatter.date(from: inicioString)?.timeIntervalSince1970)!*1000)
                let tFin = Int((formatter.date(from: finString)?.timeIntervalSince1970)!*1000)
                
                self.filtarLocker(pTamano: self.sizeTextField.text! , pTiempoInicio: tInicio, pTiempoFin: tFin)
                if(self.lockerLibre.id == "PRUEBA"){
                    self.genderAlert()
                }
                //Hacer las funciones para filtrar
            }
        }
        self.cont+=1
        
    }
    
    func descargarLockersLugar(pLugar :String, completion: @escaping ([Locker]) -> Void) {
        var lockerArray = [Locker] ()
        ref.child("Lugares").child("\(pLugar)").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
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
            //self.TableView.reloadData()
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
                            if(self.lockerLibre.id=="PRUEBA"){
                                //Alerta
                                print("No se pudo.")
                                genderAlert()
                            }
                            else{
                                let numHoras = (pTiempoFin-pTiempoInicio)/3600000
                                let pTotal = self.lockerLibre.precio*Double(numHoras)
                                print("locker\(self.lockerLibre.precio) horas: \(numHoras) precioTotal \(pTotal)")
                                let idR = self.ref.childByAutoId().key!
                                self.reserva = Reserva(pId: idR, pIdLocker: self.lockerLibre.id, pIdUsuario: "EstebanR1099", pLugarReserva: self.place, pPrecioTotal: pTotal, pTiempoFin: pTiempoFin, pTiempoInicio: pTiempoInicio, pTiempoRetorno: 0)
                                self.agregarReservacionAlSistema(idUsuario: "EstebanR1099", lugar: self.place, locker: self.lockerLibre.id, idReserva: idR, tiempoInicio: pTiempoInicio, tiempoFin: pTiempoFin, precioTotal: pTotal)
                            }
                            
                            break
                        }
                    }
                }
            }
        }
    }

    
    func genderAlert()
    {
        let alertController = UIAlertController(title: "Error al reservar", message: "No pudimos encontrar un casillero con esas caracteristicas. Intenta nuevamente", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func genderAlertReserva()
    {
        let alertController = UIAlertController(title: "Genero reserva", message: "Se genero una reserva a un locker con id: \(self.lockerLibre.id) puede verla en sus reservas", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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

extension ReservarCasilleroControllerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSize = sizes[row]
        sizeTextField.text = selectedSize
    }
    
    
}
