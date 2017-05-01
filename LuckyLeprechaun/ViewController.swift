//
//  ViewController.swift
//  LuckyLeprechaun
//
//  Created by Dee Dee Rich on 4/30/17.
//  Copyright © 2017 Dee Dee Rich. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var update = 0
    var monsters: [Monsters] = []
    var items: [Items] = []
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.delegate = self
        self.manager.delegate = self
        
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        monsters = bringAllMonsters()
        items = setUpShop()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        //Setting location authorization status
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUpMap()
            
        } else {
            self.manager.requestWhenInUseAuthorization()
        }

    }
    
    func setUpMap() {
        self.mapView.showsUserLocation = true
        self.manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //Spawning annotations which will soon be monsters and items
            if let coordinate = self.manager.location?.coordinate {
                
                let randomMonster = Int(arc4random_uniform(UInt32(self.monsters.count)))
                let monster = self.monsters[randomMonster]
                
                let annotation = MonsterAnnotation(coordinate: coordinate, monster: monster)
                annotation.coordinate = coordinate
                
                //To make it a little more random instead of just following the user's location
                annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                
                self.mapView.addAnnotation(annotation)
            }
        })

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            setUpMap()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        } else {
            let monster = (annotation as! MonsterAnnotation).monster
            annotationView.image = UIImage(named: monster.imageName!)
        }
        
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
                self.mapView.setRegion(region, animated: true)
                mapHasCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 150, 150)
        self.mapView.setRegion(region, animated: false)
        
        if let coordinate = self.manager.location?.coordinate {
            if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coordinate)) {
                
                let battle = BattleVC()
                
                let monster = (view.annotation as! MonsterAnnotation).monster
                battle.monster = monster
                self.mapView.removeAnnotation(view.annotation!)
                self.present(battle, animated: true, completion: nil)
                print("Capture Monster")
            } else {
                print("Too far to catch monster")
            }
        }
    }
    
    
    //When button pressed go to user's location
    @IBAction func userLocationUpdatedButtonPressed(_ sender: Any) {
        if let coordinate = self.manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
            self.mapView.setRegion(region, animated: true)
        }

    }//end of userLocUpdateBtnPressed
    

}//end of ViewController

