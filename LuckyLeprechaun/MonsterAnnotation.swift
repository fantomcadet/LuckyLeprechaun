//
//  MonsterAnnotation.swift
//  LuckyLeprechaun
//
//  Created by Dee Dee Rich on 4/30/17.
//  Copyright © 2017 Dee Dee Rich. All rights reserved.
//

import UIKit
import MapKit

class MonsterAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var monster: Monsters
    
    init(coordinate: CLLocationCoordinate2D, monster: Monsters) {
        self.coordinate = coordinate
        self.monster = monster
    }

}
