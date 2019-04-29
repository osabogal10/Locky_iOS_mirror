//
//  LaunchController.swift
//  Locky
//
//  Created by Orlando Sabogal Rojas on 3/24/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseUI



class LaunchController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, FUIAuthDelegate, GIDSignInDelegate {
    
    var networkManager: NetworkManager = NetworkManager()
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Faild to login  with google", err)
        }
        
        print("Successfully logged into google", user)
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credentials , completion: { (user, error) in
            if  error != nil {
                print("Something went wrong with google user in Firebase: ", error)
                return
            }
            
            print("Successfully logged in Firebase with google user: ", user?.uid)
            let url = user?.photoURL?.absoluteString
            let email = user?.email
            let name = user?.displayName
            let preferences = UserDefaults.standard
            
            let key = "urlImagenPerfil"
            
            preferences.set(url!, forKey: key)
            preferences.set(email!, forKey: "emailPerfil")
            preferences.set(name!, forKey: "namePerfil")
            preferences.set("google", forKey: "manera")
            
            self.networkManager.getUsuario(byEmail: email!, completion: { (user) in
                if let id = user?.id{
                    preferences.set(id, forKey: "idPerfil")
                    print("guardando en UserData",id)
                }
            })
            
            //  Save to disk
            let didSave = preferences.synchronize()
            
            if !didSave {
                //  Couldn't save (I've never seen this happen in real world testing)
                print("No guardo en las preferencias")
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {self.performSegue(withIdentifier: "Splash", sender: nil)})
    }
    
    
    
    @IBOutlet weak var ImagenInicio: UIImageView!
    let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
    lazy var destinationFileUrl:URL = documentsUrl.appendingPathComponent("MapaFirebase.geojson")
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
         downloadMap()
        

        //--- imagen inicio
        /*
        ImagenInicio!.image = UIImage(named: "lockerOrig")
        let templateImagen = ImagenInicio!.image?.withRenderingMode(.alwaysTemplate)
        ImagenInicio!.image = templateImagen
        ImagenInicio!.tintColor = UIColor.blue
        */
        setUpFacebookButtons()
        setUpGoogleButtons()
        setUpEmailButtons()
        
        let preferences = UserDefaults.standard
        
        let key = "manera"
        
        print("Guardado en manera ---- \(preferences.object(forKey: key) as? String)")
        if preferences.object(forKey: key) == nil || preferences.object(forKey: key) as? String == "nada" {
            
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {self.performSegue(withIdentifier: "Splash", sender: nil)})
        }
        
        
        
        //downloadMap()
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {self.performSegue(withIdentifier: "Splash", sender: nil)})
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setUpEmailButtons() {
    
        //--- agregar el boton de login con email
    let emailButton = UIButton(type: .system)
        emailButton.backgroundColor = .red
        emailButton.frame = CGRect(x: 16, y: 540, width: (view.frame.width - 32), height: 50)
        emailButton.setTitle("Acceder con correo", for: .normal)
        emailButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        emailButton.setTitleColor(.white, for: .normal)
        view.addSubview(emailButton)
        emailButton.addTarget(self, action: #selector(handleCustomEmailLogin), for: .touchUpInside)
        
    
    }
    
    fileprivate func setUpGoogleButtons() {
        //--- agregar el boton de login con google
        let googleButton =  GIDSignInButton ()
        googleButton.frame = CGRect(x: 16, y: 610, width: (view.frame.width - 32), height: 50)
        view.addSubview(googleButton )
        
        
        GIDSignIn.sharedInstance() .uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    fileprivate func setUpFacebookButtons() {
        //--- boton login facebook
        
        let loginFacebookButton = FBSDKLoginButton ()
        
        //--- agregar el boton a la vista
        view.addSubview(loginFacebookButton)
        loginFacebookButton.frame = CGRect(x: 16, y: 470, width: (view.frame.width - 32), height: 50)
        
        loginFacebookButton.delegate = self
        loginFacebookButton.readPermissions = ["email" , "public_profile"]
        //--- boton de facebook presonalizado
        let customFBButton = UIButton(type: .system)
        customFBButton.backgroundColor = .blue
        customFBButton.frame = CGRect(x: 16, y: 540, width: (view.frame.width - 32), height: 50)
        customFBButton.setTitle("Acceder con Facebook", for: .normal )
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customFBButton.setTitleColor(.white, for: .normal)
        //view.addSubview(customFBButton)
        
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    @objc func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email" , "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("CustomFB Faild:", err)
                return
            }
            
            self.getEmailAdsress()
        }
    }
    
    @objc func handleCustomEmailLogin() {
        //Get the default auth ui object
        
        let authUI = FUIAuth.defaultAuthUI()
        
        
        
        guard authUI != nil else {
            return
        }
        
        //Set the delegate
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        authUI!.providers = providers
        authUI?.delegate = self
        
       authUI!.signIn(withProviderUI: FUIEmailAuth(), presenting: self, defaultValue: "Prueba")
        //get a reference to the auth UI view controller
        
        let authViewController = authUI!.authViewController()
        
        //show it
        present(authViewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
        
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth()
        ]
        
        
        authUI!.providers = providers
        
        if let authUser = Auth.auth().currentUser, let email = authUser.email {
            print(email)
        } else {
            let authVC = authUI!.authViewController()
            present(authVC, animated: true, completion: nil)
        }
        
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if error != nil {
            print("Se putio", error)
            return
        }
        
        //authDataResult?.user.uid
        //Mandar a home
        let preferences = UserDefaults.standard
        
        let key = "urlImagenPerfil"
        
        preferences.set("nada", forKey: key)
        preferences.set(authDataResult?.user.email!, forKey: "emailPerfil")
        preferences.set(authDataResult?.user.displayName!, forKey: "namePerfil")
        preferences.set("correoNormal", forKey: "manera")
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save (I've never seen this happen in real world testing)
            print("No guardo en las preferencias")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {self.performSegue(withIdentifier: "Splash", sender: nil)})
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
         print("did log out of facebook")
    }

    func cerrarFacebook() {
       
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        //print("Successfully logged in with facebook ... ")
        getEmailAdsress()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {self.performSegue(withIdentifier: "Splash", sender: nil)})
    }
    
    func  getEmailAdsress(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenToString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenToString)
        Auth.auth().signIn(with: credentials , completion: { (user, error) in
            if  error != nil {
                print("Something went wrong with FB user: ", error)
                return
            }
            
            print("Successfully logged in with our user: ", user)
        })
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":  "id, name, email, picture.type(large)"])?.start(completionHandler: { ( connection, result, err) in
            //print(123)
            if err != nil {
                print("Faild to satar the graph request:", err)
                return
            }
            
            
            if let userInfo = result as? NSDictionary, let email = userInfo["email"] as? String, let name = userInfo["name"] as? String, let picture = userInfo["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                print("\(url) --- imagen en launch")
                let preferences = UserDefaults.standard
                
                let key = "urlImagenPerfil"
                
                preferences.set(url, forKey: key)
                preferences.set(email, forKey: "emailPerfil")
                preferences.set(name, forKey: "namePerfil")
                preferences.set("facebook", forKey: "manera")
                
                //  Save to disk
                let didSave = preferences.synchronize()
                
                if !didSave {
                    //  Couldn't save (I've never seen this happen in real world testing)
                    print("No guardo en las preferencias")
                }
                /*let storyBoard = UIStoryboard(name: "Profile", bundle: nil)
                let dVc = storyBoard.instantiateViewController(withIdentifier: "ProfileTableViewController") as! ProfileTableViewController
                dVc.setUrlImage(urlImagen: url)*/
            }
        
            
        })
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
    
    func copyItem(at srcURL: URL, to dstURL: URL) {
        do {
            try fileManager.copyItem(at: srcURL, to: dstURL)
        } catch let error as NSError {
            if error.code == NSFileWriteFileExistsError {
                print("File exists. Trying to replace")
                replaceItem(at: dstURL, with: srcURL)
            }
        }
    }
    
    func replaceItem(at dstURL: URL, with srcURL: URL) {
        do {
            try fileManager.removeItem(at: dstURL)
            copyItem(at: srcURL, to: dstURL)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func downloadMap(){
        // Create destination URL
        //var destinationFileUrl = documentsUrl.appendingPathComponent("Mapa.json")
        
        //Create URL to the source file you want to download
        let fileURL = URL(string: "https://proyectomoviles-64a71.firebaseio.com/Mapa.json")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
//                if FileManager.default.fileExists(atPath: self.destinationFileUrl){
//                    do{
//                        try FileManager.default.removeItem(atPath: self.destinationFileUrl)
//                    }catch let error {
//                        print("error occurred, here are the details:\n \(error)")
//                    }
//                }
                
                self.copyItem(at: tempLocalUrl, to: self.destinationFileUrl)
                
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
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
