//
//  CDHelper.swift
//  LuckyLeprechaun
//
//  Created by Dee Dee Rich on 4/30/17.
//  Copyright © 2017 Dee Dee Rich. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//Monster dB
func makeAllMonsters() {
    
    makeMonster(name: "Banshee", withThe: "banshee", health: 100, attackValue: 5)
    makeMonster(name: "Mad Leprechaun", withThe: "angryLeprechaun_m", health: 2000, attackValue: 30)
    makeMonster(name: "Drunken Leprechaun", withThe: "drunkenLeprechaun_f", health: 1000, attackValue: 15)
    makeMonster(name: "Kelpie", withThe: "kelpie", health: 500, attackValue: 25)
    makeMonster(name: "Nessie", withThe: "nessie", health: 10000, attackValue: 100)
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}

//Single monster maker
func makeMonster(name: String, withThe imageName: String, health: Int, attackValue: Int) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let monster = Monsters(context: context)
    monster.name = name
    monster.imageName = imageName
    monster.health = Int16(health)
    monster.attackValue = Int16(attackValue)
}

//fetches the coredata and sets it up in the dB
func bringAllMonsters() -> [Monsters] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        let monsters = try context.fetch(Monsters.fetchRequest()) as! [Monsters]
        
        if monsters.count == 0 {
            makeAllMonsters()
            return bringAllMonsters()
        }
        return monsters
    } catch {
        print("No monsters found in CoreData")
    }
    
    return []
}

//Items dB
func makeAllItems() {
    //print("making items")
    makeItem(name: "Four Leaf Clover", withThe: "four_leaf_clover", goldValue: 25)
    makeItem(name: "Pot of Gold", withThe: "pot_o_gold", goldValue: 100)
    makeItem(name: "Treasure Rainbow", withThe: "rainbow", goldValue: 50)
}

func makeItem(name: String, withThe imageName: String, goldValue: Int) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let item = Items(context: context)
    item.name = name
    item.imageName = imageName
    item.goldValue = Int16(goldValue)
}

func setUpShop() -> [Items] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
        let items = try context.fetch(Items.fetchRequest()) as! [Items]
        
        if items.count == 0 {
            makeAllItems()
            return setUpShop()
        }
        return items
    } catch {
        print("No items found for the shop in the dB")
    }
    return []
}
