//
//  MainMenuScene.swift
//  Space Mission
//
//  Created by Dominic Alvarez on 5/17/22.
//

import Foundation
import SpriteKit
class MainMenuScene: SKScene{
    override func didMove(to view: SKView) {
        let backGround = SKSpriteNode(imageNamed: "background")
        backGround.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        let developedBy = SKLabelNode(fontNamed: "Cafe Matcha")
        developedBy.text = "Dominic Alvarez's"
        developedBy.fontSize = 50
        developedBy.fontColor = SKColor.white
        developedBy.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.79)
        developedBy.zPosition = 1
        self.addChild(developedBy)
        
        let nameOne = SKLabelNode(fontNamed: "Cafe Matcha")
        nameOne.text = "SPACE"
        nameOne.fontSize = 200
        nameOne.fontColor = SKColor.white
        nameOne.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        nameOne.zPosition = 1
        self.addChild(nameOne)
        
        let nameTwo = SKLabelNode(fontNamed: "Cafe Matcha")
        nameTwo.text = "MISSION"
        nameTwo.fontSize = 200
        nameTwo.fontColor = SKColor.white
        nameTwo.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.625)
        nameTwo.zPosition = 1
        self.addChild(nameTwo)
        
        let startGameButton = SKLabelNode(fontNamed: "Cafe Matcha")
        startGameButton.text = "START GAME"
        startGameButton.fontSize = 150
        startGameButton.fontColor = SKColor.white
        startGameButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        startGameButton.zPosition = 1
        startGameButton.name = "startButton"
        self.addChild(startGameButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let nodeTouched = atPoint(pointOfTouch)
            if nodeTouched.name == "startButton"{
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
