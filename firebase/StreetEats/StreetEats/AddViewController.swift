//
//  AddViewController.swift
//  StreetEats
//
//  Created by Adriel Tolentino on 9/26/18.
//  Copyright © 2018 StreetEats. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class AddViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    let locationManager = CLLocationManager()
    var refFood: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refFood = Database.database().reference().child("Food");
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
        
        // Get Current Coordinate
        var currentLocation: CLLocation!
        currentLocation = locationManager.location
        print("Printing current coordinates")
        let longitude = "\(currentLocation.coordinate.longitude)"
        let latitude = "\(currentLocation.coordinate.latitude)"
        
        // Add the following data to Firebase Database
        let key = refFood.childByAutoId().key
        
        let food = [
            "id": key,
            "cartName": cartName,
            "typeFood": typeFood,
            "latitude": latitude,
            "longitude": longitude
        ]
        
        refFood.child(key!).setValue(food)
    }
    
    // Function that displays an alert message to the user
    func displayAlertMessage(myMessage: String) {
        let myAlert = UIAlertController(title: "Alert", message: myMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil)
    }
}
