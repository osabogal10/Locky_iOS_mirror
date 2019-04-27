//
//  AppDelegate.swift
//  Locky
//
//  Created by Orlando Sabogal Rojas on 3/14/19.
//  Copyright © 2019 Orlando Sabogal Rojas. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import FirebaseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
   

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.tintColor = UIColor.white
        navBarAppearance.barTintColor = UIColor(red: 0, green: 81/255, blue: 1, alpha: 1)
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UIApplication.shared.statusBarStyle  = UIStatusBarStyle.lightContent
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
//        print(self.window!.rootViewController?.classForCoder)
//        print(self.window!.rootViewController?.)
//        if let tabBarController = self.window!.rootViewController as? UITabBarController {
//            tabBarController.selectedIndex = 2
//        }
        
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
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
            
            //  Save to disk
            let didSave = preferences.synchronize()
            
            if !didSave {
                //  Couldn't save (I've never seen this happen in real world testing)
                print("No guardo en las preferencias")
            }
        })
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, sourceApplication: options [UIApplication.OpenURLOptionsKey.sourceApplication] as! String!, annotation: [UIApplication.OpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return handled!
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

