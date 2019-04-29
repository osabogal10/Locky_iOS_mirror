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
    let preferences = UserDefaults.standard
    
    
    var place = "Un lugar"
    var lockerLibre :Locker = Locker(pId: "PRUEBA", pNumero: 0, pTamano: "", pPrecio: 0.0, pEstado: "", pLugar: "", pReservas: [ReservaHora]())
    var data :[Locker] = [Locker(pId: "PRUEBA", pNumero: 0, pTamano: "", pPrecio: 0.0, pEstado: "", pLugar: "", pReservas: [ReservaHora]())]
    let net : NetworkManager = NetworkManager()

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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy 'at' h:mm a"
        let inicioString = self.dateTextField!.text! + " at " + self.initTime.text!
        let finString = self.dateTextField!.text! + " at " + self.endTime.text!
        let tInicio = formatter.date(from: inicioString)!
        let tFin = formatter.date(from: finString)!
        let tam = self.sizeTextField.text!
        var user_id = 1
        if preferences.object(forKey: "idPerfil") == nil {
            //  Doesn't exist
            print("Perrito no encontro nada con esa key")
        } else {
            user_id = (preferences.object(forKey: "idPerfil") as? Int)!
        }
        net.postCrearReserva(tInicio: tInicio, tFin: tFin, precioTotal: 10000, tamano: tam, nombreLugar: place, usuario_id: user_id) { (reserva,executed) in
            if let respuesta = reserva?.id {
                print(respuesta)
                print("voy al tab 2")
                self.tabBarController?.selectedIndex = 1
            }
            else{
                print("No se pudo crear Reserva",executed)
                if executed == false {
                    self.genderAlertSinConexion()
                }
                else{
                    self.genderAlert()
                }
            }
        }
        
        /*{(reserva) in
            if let respuesta = reserva?.tiempoRetorno{
                print(respuesta)
            } else {
                print("gg")
            }
        }*/
        //inicializarLockers(pLugarLockers: place)
        //getHistorial()
        //postReserva()
        
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
    
    func genderAlert()
    {
        let alertController = UIAlertController(title: "Error al reservar", message: "Ups! No pudimos encontrar un locker con esas caracteristicas. Intenta nuevamente.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func genderAlertSinConexion()
    {
        let alertController = UIAlertController(title: "Sin conexión", message: "No estas conectado a internet. Intenta mas tarde.", preferredStyle: UIAlertController.Style.alert)
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
