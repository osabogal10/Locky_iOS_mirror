//
//  FuncionaLockyController.swift
//  Locky
//
//  Created by Reyes on 4/28/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit

class FuncionaLockyController: UIViewController {

    @IBOutlet weak var LabAcercaReservas: UILabel!
    @IBOutlet weak var LabComoFunciona: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpButtonLlamar()
        // Do any additional setup after loading the view.
    }
    
    func setUpButtonLlamar() {
        let callButton = UIButton(type: .system)
        callButton.backgroundColor = .blue
        callButton.frame = CGRect(x: 16, y: 580, width: (view.frame.width - 32), height: 50)
        callButton.setTitle("CONTACTAR", for: .normal)
        callButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        callButton.setTitleColor(.white, for: .normal)
        view.addSubview(callButton)
        callButton.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
    }
    
    @IBAction func Contact(_ sender: Any) {
        handleCall()
    }
    
    
    @objc func handleCall() {
        guard let url = URL(string: "telprompt://3103430796") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)

    }
    
    override var prefersStatusBarHidden: Bool{
        return true
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
