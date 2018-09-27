//
//  AddViewController.swift
//  StreetEats
//
//  Created by Adriel Tolentino on 9/26/18.
//  Copyright © 2018 StreetEats. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let cartName = nameField.text
        let typeFood = typeField.text
        
        // Checks for empty fields
        if((cartName?.isEmpty)! || (typeFood?.isEmpty)!)
        {
            // Display an alert message
            displayAlertMessage(myMessage: "Fields can't be empty")
            return;
        }
        
        //Add the following data to Firebase Database
    }
    
    // Function that displays an alert message to the user
    func displayAlertMessage(myMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: myMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
}
