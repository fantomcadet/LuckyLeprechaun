//
//  BattleVC.swift
//  LuckyLeprechaun
//
//  Created by Dee Dee Rich on 5/1/17.
//  Copyright © 2017 Dee Dee Rich. All rights reserved.
//

import UIKit
import SpriteKit

class BattleVC: UIViewController {
    
    var monster: Monsters!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //load BattleScene in VC
        let scene = BattleScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        self.view = SKView()
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        
        scene.monster = self.monster
        
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.returnToMapController), name: NSNotification.Name("closeBattle"), object: nil)
    }
    
    func returnToMapController() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
