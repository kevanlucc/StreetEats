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

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        performSegue(withIdentifier: "mapViewPage", sender: nil)
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
