//
//  ViewController.swift
//  newmultiMap
//
//  Created by Adriel Tolentino on 9/24/18.
//  Copyright © 2018 StreetEats. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase
import GoogleSignIn

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var AddButtonOnLogin: UIButton!
    @IBOutlet weak var loginTitle: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var refHandle: UInt!
    var newref: DatabaseReference!
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userTrackingMode = .follow
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        //checks if user is logged in to Firebase
        if Auth.auth().currentUser != nil {
            loginTitle.setTitle("Logout", for: .normal)
            AddButtonOnLogin.isHidden = false
        }
        else {
            AddButtonOnLogin.isHidden = true
        }
        self.mapView.delegate = self
        //createAnnotation(locations: annoLocation)
        
        // Reference Database starting from 'Users' parent
        ref = Database.database().reference().child("Users")
        
        // Grabs all the carts from all the user
        refHandle = ref.observe(.value,
                                with: { (snapshot) in
                                    for i in snapshot.children {
                                        let snap = i as! DataSnapshot
                                        self.items.append(snap.key)
                                    }
                                    for item in self.items {
                                        self.ref.child(item).observe(.childAdded, with: { (snapshot) in
                                            let latitude = (snapshot.value as AnyObject?)!["latitude"] as! String
                                            let longitude = (snapshot.value as AnyObject?)!["longitude"] as! String
                                            let cartName = (snapshot.value as AnyObject?)!["cartName"] as! String
                                            let typeFood = (snapshot.value as AnyObject?)!["typeFood"] as! String
                                            //let hours = (snapshot.value as AnyObject?)!["hour"] as! Int
                                            //let minutes = (snapshot.value as AnyObject?)!["minutes"] as! Int
                                            let time = (snapshot.value as AnyObject?)!["time"] as! String
                                            let locate = CLLocationCoordinate2DMake((Double(latitude)!), (Double(longitude)!))
                                            
                                            // Draw out marker on map
                                            let annotations = MKPointAnnotation()
                                            annotations.coordinate = locate
                                            annotations.title = cartName
                                            annotations.subtitle = "Menu: \(typeFood) \nLast seen at \(time)"
                                            self.mapView.addAnnotation(annotations)
                                        })
                                    }
        })
        
        /*
        ref.child("Users").observe(.value, with: { (snapshot) in
            ref.child(snapshot).observe(.childAdded, with: { (snapshot) in
                let latitude = (snapshot.value as AnyObject?)!["latitude"] as! String
                let longitude = (snapshot.value as AnyObject?)!["longitude"] as! String
                let cartName = (snapshot.value as AnyObject?)!["cartName"] as! String
                let typeFood = (snapshot.value as AnyObject?)!["typeFood"] as! String
                //let hours = (snapshot.value as AnyObject?)!["hour"] as! Int
                //let minutes = (snapshot.value as AnyObject?)!["minutes"] as! Int
                let time = (snapshot.value as AnyObject?)!["time"] as! String
                let locate = CLLocationCoordinate2DMake((Double(latitude)!), (Double(longitude)!))
                
                // Draw out marker on map
                let annotations = MKPointAnnotation()
                annotations.coordinate = locate
                annotations.title = cartName
                annotations.subtitle = "Menu: \(typeFood) \nLast seen at \(time)"
                self.mapView.addAnnotation(annotations)
            })}*/
        
        /* Retrieve carts tied to the user ID data inside the "Food" dictionary
        ref.child("Users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            return
              let latitude = (snapshot.value as AnyObject?)!["latitude"] as! String
            let longitude = (snapshot.value as AnyObject?)!["longitude"] as! String
            let cartName = (snapshot.value as AnyObject?)!["cartName"] as! String
            let typeFood = (snapshot.value as AnyObject?)!["typeFood"] as! String
            //let hours = (snapshot.value as AnyObject?)!["hour"] as! Int
            //let minutes = (snapshot.value as AnyObject?)!["minutes"] as! Int
            let time = (snapshot.value as AnyObject?)!["time"] as! String
            let locate = CLLocationCoordinate2DMake((Double(latitude)!), (Double(longitude)!))
            
            // Draw out marker on map 
            let annotations = MKPointAnnotation()
            annotations.coordinate = locate
            annotations.title = cartName
            annotations.subtitle = "Menu: \(typeFood) \nLast seen at \(time)"
            self.mapView.addAnnotation(annotations)
        })*/
    }
    
    
    var deleteButton = UIButton.init(type: .detailDisclosure)
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomerAnnotation")
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        
        annotationView.image = UIImage(named: "cart")
        annotationView.canShowCallout = true
        
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        annotationView.detailCalloutAccessoryView = subtitleView
        annotationView.rightCalloutAccessoryView = deleteButton
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        return
    }
    
    @IBAction func UserLocation(_ sender: UIButton) {
        mapView.userTrackingMode = .follow
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        // if user is logged in
        if Auth.auth().currentUser != nil {
            GIDSignIn.sharedInstance().signOut()
            do {
                try Auth.auth().signOut()
                loginTitle.setTitle("Login", for: .normal)
                AddButtonOnLogin.isHidden = true
            }
            catch {
                print(error)
            }
        } else {
            performSegue(withIdentifier: "loginPage", sender: nil)
            
        }
    }
    
    // function that zooms in to the user's location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
