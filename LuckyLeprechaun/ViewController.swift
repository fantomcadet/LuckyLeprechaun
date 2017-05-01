//
//  ViewController.swift
//  LuckyLeprechaun
//
//  Created by Dee Dee Rich on 4/30/17.
//  Copyright © 2017 Dee Dee Rich. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var update = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.manager.delegate = self
        
        
        //Setting location authorization status
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                //Spawning annotations which will soon be monsters and items
                if let coordinate = self.manager.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    
                    //To make it a little more random instead of just following the user's location
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                    
                    self.mapView.addAnnotation(annotation)
                }
            })
            
        } else {
            self.manager.requestWhenInUseAuthorization()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Zoom in on the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //make location manager more efficient - doesn't update every second all the time
        if update < 4 {
            let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 1000, 1000)
            self.mapView.setRegion(region, animated: true)
            update += 1
        } else {
            self.manager.stopUpdatingLocation()
            update = 0
        }
    }
    
    //When button pressed go to user's location
    @IBAction func userLocationUpdatedButtonPressed(_ sender: Any) {
        let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
        self.mapView.setRegion(region, animated: true)
    }
    

}

