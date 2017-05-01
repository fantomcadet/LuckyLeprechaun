//
//  BattleScene.swift
//  LuckyLeprechaun
//
//  Created by Dee Dee Rich on 5/1/17.
//  Copyright © 2017 Dee Dee Rich. All rights reserved.
//

import SpriteKit
import UIKit

class BattleScene: SKScene, SKPhysicsContactDelegate {
    
    /*Need to add the Player info so that the battle can be accomplished with
     health values and also need to have the gold value label and gold
     values set.
     
     then need to be able to access and purchase things on the store.
     
     And defeated monsters/found items need to be removed from the map.
     
     Also want to access the camera and make it augmented reality at some time.
    */
    
    var monster: Monsters!
    var monsterSprite: SKSpriteNode!
    var hand: SKSpriteNode!
    var monsterHealth: Int16 = 0
    
    //constants
    let kMonsterSize = CGSize(width: 100, height: 100)
    let kMonsterName = "Monster"
    let kHandSize = CGSize(width: 70, height: 70)
    
    //bit categories
    let kMonsterCategory: UInt32 = 0x1 << 0
    let kHandCategory: UInt32 = 0x1 << 1
    let kEdgeCategory: UInt32 = 0x1 << 2
    
    var velocity: CGPoint = CGPoint.zero
    var touchPoint: CGPoint = CGPoint()
    var canHitMonster: Bool = false
    
    var startCount = true
    var maxTime = 30
    var myTime = 30
    var timeLabel = SKLabelNode(fontNamed: "Ring of Kerry")
    
    var monsterDefeated = false
    
    
    override func didMove(to view: SKView) {
        print("Welcome to Battle!")
        //set background randomly from the three images
        
        var bgRandom = (Double(arc4random_uniform(2)))
        var battleBG = SKSpriteNode()
        
        if bgRandom == 0 {
            battleBG = SKSpriteNode(imageNamed: "castle")
        } else if bgRandom == 1 {
            battleBG = SKSpriteNode(imageNamed: "bridge")
        } else {
            battleBG = SKSpriteNode(imageNamed: "forest")
        }
        
        battleBG.size = self.size
        battleBG.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        battleBG.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        battleBG.zPosition = -1
        
        self.addChild(battleBG)
        
        self.makeMessageWith(imageName: "battle")
        
        self.perform(#selector(monsterSetUp), with: nil, afterDelay: 1.0)
        self.perform(#selector(handSetUp), with: nil, afterDelay: 1.0)
        
        //physics setup for scene
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = kEdgeCategory
        self.physicsWorld.contactDelegate = self
        
        //setup time label
        self.timeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
        self.addChild(timeLabel)
        
    }//end didMove
    
    func monsterSetUp() {
        self.monsterSprite = SKSpriteNode(imageNamed: monster.imageName!)
        self.monsterSprite.size = kMonsterSize
        self.monsterSprite.name = monster.name
        self.monsterSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        //monsterHealth not being setup properly...
        self.monsterHealth = monster.health
        
        //Monster Physics
        self.monsterSprite.physicsBody = SKPhysicsBody(rectangleOf: kMonsterSize)
        self.monsterSprite.physicsBody!.isDynamic = false
        self.monsterSprite.physicsBody!.affectedByGravity = false
        self.monsterSprite.physicsBody!.mass = 1.0
        
        //bit masks
        self.monsterSprite.physicsBody!.categoryBitMask = kMonsterCategory
        self.monsterSprite.physicsBody!.contactTestBitMask = kHandCategory
        self.monsterSprite.physicsBody!.collisionBitMask = kEdgeCategory
        
        //Actions
        let moveRight = SKAction.moveBy(x: 150, y: 0, duration: 3.0)
        let sequence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        
        self.monsterSprite.run(SKAction.repeatForever(sequence))
        self.addChild(monsterSprite)
    }
    
    func handSetUp() {
        self.hand = SKSpriteNode(imageNamed: "fist")
        self.hand.size = kHandSize
        self.hand.name = monster.name
        self.hand.position = CGPoint(x: self.size.width/2, y: 50)
        
        //Hand Physics
        self.hand.physicsBody = SKPhysicsBody(circleOfRadius: self.hand.frame.size.width/2)
        self.hand.physicsBody!.isDynamic = true
        self.hand.physicsBody!.affectedByGravity = true
        self.hand.physicsBody!.mass = 0.1
        
        //bit masks
        self.hand.physicsBody!.categoryBitMask = kHandCategory
        self.hand.physicsBody!.contactTestBitMask = kMonsterCategory
        self.hand.physicsBody!.collisionBitMask = kMonsterCategory | kEdgeCategory
        
        self.addChild(hand)

    }
    
    //Two functions to determine when the user first touches the hand and then releases it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        if self.hand.frame.contains(location!) {
            self.canHitMonster = true
            self.touchPoint = location!
        }
    }//end touchesBegan
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        self.touchPoint = location!
        
        if self.canHitMonster {
            hitMonster()
        }
        
    }//end touchesEnded
    
    func hitMonster() {
        self.canHitMonster = false
        
        let deltaTime: CGFloat  = 1.0/50
        let distance = CGVector(dx: self.touchPoint.x - self.monsterSprite.position.x, dy: self.touchPoint.y - self.monsterSprite.position.y)
        
        let velocity = CGVector(dx: distance.dx / deltaTime, dy: distance.dy / deltaTime)
        self.hand.physicsBody!.velocity = velocity
    }//end hitMonster
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case kMonsterCategory | kHandCategory:
            //decrement monster health
            print(monsterHealth)
            monsterHealth -= 5
            //ensure when you mess with something in the dB you use
            //(UIApplication.shared.delegate as! AppDelegate).saveContext() or else
            //it won't save to the dB
            print("Monster hit")
            //check monster health for <= 0
            if (monsterHealth <= 0) {
                self.monsterDefeated = true
                endGame()
            }
        default:
            return
        }
    }//end didBegin
    
    override func update(_ currentTime: TimeInterval) {
        if self.startCount {
            self.maxTime = Int(currentTime) + self.maxTime
            self.startCount = false
        }
        
        self.myTime = self.maxTime - Int(currentTime)
        self.timeLabel.text = "\(self.myTime)"
        
        if self.myTime <= 0 {
            endGame()
        }
    }//end (mini) endGame
    
    func endBattle() {
        NotificationCenter.default.post(name: NSNotification.Name("closeBattle"), object: nil)
    }
    
    func endGame() {
        self.hand.removeFromParent()
        self.monsterSprite.removeFromParent()
        
        if monsterDefeated {
            self.makeMessageWith(imageName: "defeatedMonster")
            //update gold value for the player and show in label
        } else {
            //also need to check if our health is 0 need another if statement then END END game
            self.makeMessageWith(imageName: "timesUp")
        }
        
        self.perform(#selector(self.endBattle), with: nil, afterDelay: 1.0)
        
    }//end endBattle
    
    func makeMessageWith(imageName: String) {
        let message = SKSpriteNode(imageNamed: imageName)
        message.size = CGSize(width: 150, height: 150)
        message.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(message)
        
        message.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
    }
    
}//end of BattleScene
