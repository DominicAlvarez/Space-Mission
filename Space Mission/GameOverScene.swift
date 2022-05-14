//
//  GameOverScene.swift
//  Space Mission
//
//  Created by Dominic Alvarez on 5/14/22.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    let restartButton = SKLabelNode(fontNamed: "Cafe Matcha")
    override func didMove(to view: SKView) {
        let backGround = SKSpriteNode(imageNamed: "background")
        backGround.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        let gameOverText = SKLabelNode(fontNamed: "Cafe Matcha")
        gameOverText.text = "Game Over!"
        gameOverText.fontSize = 175
        gameOverText.fontColor = SKColor.white
        gameOverText.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverText.zPosition = 1
        self.addChild(gameOverText)
        
        let score = SKLabelNode(fontNamed: "Cafe Matcha")
        score.text = "Score: \(gameScore)"
        score.fontSize = 125
        score.fontColor = SKColor.white
        score.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.55)
        self.zPosition = 1
        self.addChild(score)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            
        }
        let highScoreLabel = SKLabelNode(fontNamed: "Cafe Matcha")
        highScoreLabel.text = "High Score \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        self.addChild(highScoreLabel)
        
        restartButton.text = "Restart"
        restartButton.fontSize = 90
        restartButton.fontColor = SKColor.white
        restartButton.zPosition = 1
        restartButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        self.addChild(restartButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if restartButton.contains(pointOfTouch){
                let sceneMoveTo = GameScene(size: self.size)
                sceneMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneMoveTo, transition: myTransition)
            }
    }
}

} // end gameOver
