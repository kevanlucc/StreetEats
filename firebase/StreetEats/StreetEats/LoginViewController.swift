//
//  LoginViewController.swift
//  StreetEats
//
//  Created by Victor Nguyen on 9/29/18.
//  Copyright © 2018 StreetEats. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID =  FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        setupGoogleButton()
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
        }
    }
    fileprivate func setupGoogleButton() {
        // Add google signin
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self as GIDSignInUIDelegate
    }
    
    func sign(_ _signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
        
        print("Successfully logged into Google: ", user)
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            
            guard let uid = user?.uid else { return }
            print("Sucessfully logged into Firebase with Google", user?.uid)
            self.performSegue(withIdentifier: "mapViewPage", sender: nil)
        })
        
    }
}
