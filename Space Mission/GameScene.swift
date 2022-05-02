//
//  GameScene.swift
//  Space Mission
//
//  Created by Dominic Alvarez
//
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var gameScore = 0
    let ScoreLabel = SKLabelNode(fontNamed: "Cafe Matcha")
    
    var LivesNumber = 3
    var LivesLabel = SKLabelNode(fontNamed: "Cafe Matcha")
    
    var levelNumber = 0
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    let bulletSound = SKAction.playSoundFileNamed("mixkit-arcade-retro-jump-223.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("MG2NHPK-explosion.mp3", waitForCompletion: false)
    
    struct physicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 // 1
        static let Bullet: UInt32 = 0b10 // 2
        static let Enemy: UInt32 = 0b100 // 4
    }
    // Functions to randomize
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    
    var gameArea: CGRect
    // Creating a universal max size of the screen no matter which device it is on
    override init(size: CGSize){
        let maxAsepctRation: CGFloat = 16.0/9.0
        let playableWitdh = size.height / maxAsepctRation
        let margin = (size.width - playableWitdh) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWitdh, height: size.height)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Set up our background and player on the screen
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = physicsCategories.Player
        player.physicsBody!.collisionBitMask = physicsCategories.None
        player.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        self.addChild(player)
        
        ScoreLabel.text = "Score: 0"
        ScoreLabel.fontSize = 70
        ScoreLabel.fontColor = SKColor.white
        ScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        ScoreLabel.position = CGPoint(x: self.size.width * 0.20, y: self.size.height * 0.9)
        ScoreLabel.zPosition = 100
        self.addChild(ScoreLabel)
        
        LivesLabel.text = "Lives: 3"
        LivesLabel.fontSize = 70
        LivesLabel.fontColor = SKColor.white
        LivesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        LivesLabel.position = CGPoint(x: self.size.width * 0.80, y: self.size.height * 0.9)
        LivesLabel.zPosition = 100
        self.addChild(LivesLabel)
        
        startNewLevel()
        }
    func loseALife(){
        LivesNumber-=1
        LivesLabel.text = "Lives: \(LivesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        LivesLabel.run(scaleSequence)
    }
    func addScore(){
        gameScore+=1
        ScoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50{
            startNewLevel()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == physicsCategories.Player && body2.categoryBitMask == physicsCategories.Enemy{
            // if player has hit enemy
            if body1.node != nil{
            spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        if body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            // bullet hits enemy
            addScore()
            if body2.node != nil{
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
    }
    
    // Level Function
    func startNewLevel(){
        levelNumber+=1
        
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        var levelDuration = TimeInterval()
        switch levelNumber{
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Can not find level info")
            
            
        }
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }
    // A function to fire the bullet from the spaceship.
    // The bullet will be shooting from the base of the spaceship
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 2
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = physicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = physicsCategories.None
        bullet.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: (self.size.height + bullet.size.height), duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
        
    }
    // A function to spawn the enemy ships
    // The ships will attack from random angles on the display
    func spawnEnemy(){
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = physicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = physicsCategories.None
        enemy.physicsBody!.contactTestBitMask = physicsCategories.Player | physicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let lostLife = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, lostLife])
        enemy.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let rotateAmount = atan2(dy, dx)
        enemy.zRotation = rotateAmount
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            player.position.x += amountDragged
            
            if player.position.x > gameArea.maxX - player.size.width / 2 {
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            if player.position.x < gameArea.minX + player.size.width / 2{
                player.position.x = gameArea.minX + player.size.width / 2
            }
            
        }// end for
        
    }
    
    

}// end GameScene
