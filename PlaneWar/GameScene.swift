//
//  GameScene.swift
//  PlaneShooter
//
//  Copyright © 2016年 FloodSurge. All rights reserved.
//

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var heroPlane:HeroPlane!
    var scoreLabel:SKLabelNode!
    var pauseButton:SKSpriteNode!
    var gameLevel:SKLabelNode!
    
    
    var smallPlaneHitAction:SKAction!
    var smallPlaneBlowUpAction:SKAction!
    var mediumPlaneHitAction:SKAction!
    var mediumPlaneBlowUpAction:SKAction!
    var largePlaneHitAction:SKAction!
    var largePlaneBlowUpAction:SKAction!
    var heroPlaneBlowUpAction:SKAction!
    
    enum RoleCategory:UInt32{
        case bullet = 1
        case heroPlane = 2
        case enemyPlane = 4
        case suply = 8
    }
    
    override func didMove(to view: SKView) {
        initBackground()
        initActions()
        initHeroPlane()
        initEnemyPlane()
        initScoreLabel()
        initGameLevel()
        initSupply()
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.restart), name: NSNotification.Name(rawValue: "restartNotification"), object: nil)
    }
    
    func restart(){
        removeAllChildren()
        removeAllActions()
        
        initBackground()
        initScoreLabel()
        initGameLevel()
        initHeroPlane()
        initEnemyPlane()
        initSupply()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let anyTouch : AnyObject! = (touches as NSSet).anyObject() as AnyObject!
        let location = anyTouch.location(in: self)
        heroPlane.run(SKAction.move(to: location, duration: 0.1))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let anyTouch : AnyObject! = (touches as NSSet).anyObject() as AnyObject!
        let location = anyTouch.location(in: self)
        heroPlane.run(SKAction.move(to: location, duration: 0))
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func initBackground()
    {
        // init texture
        let backgroundTexture = SKTexture(imageNamed:"background.png")
        backgroundTexture.filteringMode = .nearest
        
        // set action
        

        let moveBackgroundSprite = SKAction.moveBy(x: 0, y:-backgroundTexture.size().height, duration: 8)
        let resetBackgroundSprite = SKAction.moveBy(x: 0, y:backgroundTexture.size().height, duration: 0)
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackgroundSprite,resetBackgroundSprite]))
        
        // init background sprite
        
        for index in 0..<2 {
   
            let backgroundSprite = SKSpriteNode(texture:backgroundTexture)
            backgroundSprite.position = CGPoint(x: size.width/2,y: size.height / 2 + CGFloat(index) * backgroundSprite.size.height)
            backgroundSprite.zPosition = 0
            backgroundSprite.run(moveBackgroundForever)
            addChild(backgroundSprite)
        }
        
        // play background music

        run(SKAction.repeatForever(SKAction.playSoundFileNamed("game_music.mp3", waitForCompletion: true)))
        
        // set physics world
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    func initActions()
    {
        // small hit action
        // nil
        
        
        
        // small blow up action
        var smallPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            smallPlaneBlowUpTexture.append(SKTexture(imageNamed:"enemy1_blowup_\(i)"))
        }
        smallPlaneBlowUpAction = SKAction.sequence([SKAction.animate(with: smallPlaneBlowUpTexture, timePerFrame: 0.03),SKAction.removeFromParent()])
        
        // medium hit action
        var mediumPlaneHitTexture = [SKTexture]()
        mediumPlaneHitTexture.append(SKTexture(imageNamed:"enemy3_hit_1"))
        mediumPlaneHitTexture.append(SKTexture(imageNamed:"enemy3_fly_1"))
        mediumPlaneHitAction = SKAction.animate(with: mediumPlaneHitTexture, timePerFrame: 0.1)
        
        // medium blow up action
        var mediumPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            mediumPlaneBlowUpTexture.append(SKTexture(imageNamed:"enemy3_blowup_\(i)"))
        }
        mediumPlaneBlowUpAction = SKAction.sequence([SKAction.animate(with: mediumPlaneBlowUpTexture, timePerFrame: 0.05),SKAction.removeFromParent()])
        
        // large hit action
        var largePlaneHitTexture = [SKTexture]()
        largePlaneHitTexture.append(SKTexture(imageNamed:"enemy2_hit_1"))
        largePlaneHitTexture.append(SKTexture(imageNamed:"enemy2_fly_2"))
        largePlaneHitAction = SKAction.animate(with: largePlaneHitTexture, timePerFrame: 0.1)
        
        // large blow up action
        var largePlaneBlowUpTexture = [SKTexture]()
        for i in 1...7 {
            largePlaneBlowUpTexture.append(SKTexture(imageNamed:"enemy2_blowup_\(i)"))
        }
        largePlaneBlowUpAction = SKAction.sequence([SKAction.animate(with: largePlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        // hero plane blow up action
        var heroPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            heroPlaneBlowUpTexture.append(SKTexture(imageNamed:"hero_blowup_\(i)"))
        }
        heroPlaneBlowUpAction = SKAction.sequence([SKAction.animate(with: heroPlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
    }
    
    func initScoreLabel()
    {
        scoreLabel = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        scoreLabel.text = "0000"
        scoreLabel.zPosition = 2
        scoreLabel.fontColor = SKColor.black
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 50, y: size.height - 52)
        addChild(scoreLabel)
        
//        let scoreLabelText = SKLabelNode(fontNamed:"MarkerFelt-Thin")
//        scoreLabelText.text = "Score:"
//        scoreLabelText.zPosition = 2
//        scoreLabelText.fontColor = SKColor.gray
//        scoreLabelText.horizontalAlignmentMode = .left
//        scoreLabelText.position = CGPoint(x:50, y: size.height - 52)
//        addChild(scoreLabelText)

        

    }
    
    func changeScore(_ type:EnemyPlaneType)
    {
        var score:Int
        switch type {
        case .large:
            score = 600
        case .medium:
            score = 300
        case .small:
            score = 100
        }
        
        scoreLabel.run(SKAction.run({() in
            self.scoreLabel.text = "\(Int(self.scoreLabel.text!)! + score)"
        }))
        
    }
    func initGameLevel()
    {
        gameLevel = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        gameLevel.text = "1"
        gameLevel.zPosition = 2
        gameLevel.fontColor = SKColor.black
        gameLevel.horizontalAlignmentMode = .right
        gameLevel.position = CGPoint(x: size.width-10, y: size.height - 52)
        addChild(gameLevel)
        
        let gameLevelText = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        gameLevelText.text = "Level:"
        gameLevelText.zPosition = 2
        gameLevelText.fontColor = SKColor.gray
        gameLevelText.horizontalAlignmentMode = .right
        gameLevelText.position = CGPoint(x: size.width-37, y: size.height - 52)
        addChild(gameLevelText)
        
    }

    func changeGameLevel()
    {
        let curScore = Int(scoreLabel.text!)
        var level:Int = 1
        if let s = curScore {
        switch  curScore!{
        case 0..<50000:
             level = 1
        case 50000..<150000:
             level = 2
        case 150000..<300000:
             level = 3
        default:
             level = 4
        }
        }
        gameLevel.run(SKAction.run({() in
            self.gameLevel.text = "\(level)"
        }))
        
    }
    
    func initHeroPlane()
    {
        self.heroPlane = HeroPlane.createHeroPlane()
        heroPlane.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
        
//        heroPlane.physicsBody = SKPhysicsBody(texture:heroPlane.heroPlaneTexture1,size:heroPlane.size)
        heroPlane.zPosition = 1
        heroPlane.physicsBody?.isDynamic = true
        heroPlane.physicsBody?.allowsRotation = false
        heroPlane.physicsBody?.categoryBitMask = RoleCategory.heroPlane.rawValue
        heroPlane.physicsBody?.collisionBitMask = RoleCategory.enemyPlane.rawValue | RoleCategory.suply.rawValue
        heroPlane.physicsBody?.contactTestBitMask = RoleCategory.enemyPlane.rawValue | RoleCategory.suply.rawValue        
        addChild(heroPlane)
        
        // fire bullets
        let spawn = SKAction.run{() in
            self.createBullet()}
        let wait = SKAction.wait(forDuration: 0.3/Double(self.heroPlane.weaponLevel))

        heroPlane.run(SKAction.repeatForever(SKAction.sequence([spawn,wait])))
        
    }
    
    func createBullet()
    {   
        let bulletTexture = SKTexture(imageNamed:"bullet\(self.heroPlane.weaponLevel)")
        let bullet = SKSpriteNode(texture:bulletTexture)
        bullet.setScale(0.5)
        bullet.position = CGPoint(x: heroPlane.position.x, y: heroPlane.position.y + heroPlane.size.height/2 + bullet.size.height/2)
        bullet.zPosition = 1
        let bulletMove = SKAction.moveBy(x: 0, y: size.height, duration: 0.8)
        let bulletRemove = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([bulletMove,bulletRemove]))
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        //bullet.physicsBody = SKPhysicsBody(texture:bulletTexture,size:bullet.size)
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.categoryBitMask = RoleCategory.bullet.rawValue
        bullet.physicsBody?.collisionBitMask = RoleCategory.enemyPlane.rawValue
        bullet.physicsBody?.contactTestBitMask = RoleCategory.enemyPlane.rawValue
        
        addChild(bullet)
        
        // play bullet music
        
        run(SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false))
        
    }
    
    func initEnemyPlane()
    {
        let spawn = SKAction.run{() in
            self.createEnemyPlane()}
        let wait = SKAction.wait(forDuration: 0.4)
        run(SKAction.repeatForever(SKAction.sequence([spawn,wait])))
    }
    
    func createEnemyPlane(){
        let choose = arc4random() % 100
        var type:EnemyPlaneType
        var speed:Float
        var enemyPlane:EnemyPlane
        switch choose
        {
        case 0..<75:
            type = .small
            speed = Float(arc4random() % 3) + 5.0-Float(Int(self.gameLevel.text!)!)
            enemyPlane = EnemyPlane.createSmallPlane()
            enemyPlane.hp = Int(self.gameLevel.text!)!
            
        case 75..<97:
            type = .medium
            speed = Float(arc4random() % 3) + 6.0-Float(Int(self.gameLevel.text!)!)
            enemyPlane = EnemyPlane.createMediumPlane()
            enemyPlane.hp = 2+Int(self.gameLevel.text!)!
        default:
            type = .large
            speed = Float(arc4random() % 3) + 8.0-Float(Int(self.gameLevel.text!)!)
            enemyPlane = EnemyPlane.createLargePlane()
            enemyPlane.hp = 5+Int(self.gameLevel.text!)!
            run(SKAction.playSoundFileNamed("enemy2_out.mp3", waitForCompletion: false))
        }
        
        enemyPlane.zPosition = 1
        enemyPlane.physicsBody?.isDynamic = false
        enemyPlane.physicsBody?.allowsRotation = false
        enemyPlane.physicsBody?.categoryBitMask = RoleCategory.enemyPlane.rawValue
        enemyPlane.physicsBody?.collisionBitMask = RoleCategory.bullet.rawValue | RoleCategory.heroPlane.rawValue
        enemyPlane.physicsBody?.contactTestBitMask = RoleCategory.bullet.rawValue | RoleCategory.heroPlane.rawValue
        
        let x = (arc4random() % 270) + 30
        enemyPlane.position = CGPoint(x: CGFloat(x), y: size.height + enemyPlane.size.height/2)
        
        let moveAction = SKAction.moveTo(y: 0, duration: TimeInterval(speed))
        let remove = SKAction.removeFromParent()
        enemyPlane.run(SKAction.sequence([moveAction,remove]))
        
        addChild(enemyPlane)
        
        
    }
    func initSupply(){
        let spawn = SKAction.run{() in
            self.createSuply()}
        let wait = SKAction.wait(forDuration: 20)
        run(SKAction.repeatForever(SKAction.sequence([spawn,wait])))
    }
    func createSuply(){
        let choose = arc4random() % 2
        var type:SuplyType
        var speed:Float
        var suply:Suply
        //var enemyPlane:EnemyPlane
        switch choose
        {
        case 0:
            type = .bulletSuply
            speed = Float(arc4random() % 3) + 6.0-Float(Int(self.gameLevel.text!)!)
            suply = Suply.createBulletSuply()
        default:
            type = .hpSuply
            speed = Float(arc4random() % 3) + 6.0-Float(Int(self.gameLevel.text!)!)
            suply = Suply.createHpSuply()
        }
        
        suply.zPosition = 1
        suply.physicsBody?.isDynamic = true
        suply.physicsBody?.allowsRotation = false
        suply.physicsBody?.categoryBitMask = RoleCategory.suply.rawValue
        suply.physicsBody?.collisionBitMask = RoleCategory.heroPlane.rawValue
        suply.physicsBody?.contactTestBitMask = RoleCategory.heroPlane.rawValue
        
        let x = (arc4random() % 270) + 30
        suply.position = CGPoint(x: CGFloat(x), y: size.height + suply.size.height/2)
        
        let moveAction = SKAction.moveTo(y: 0, duration: TimeInterval(speed))
        let remove = SKAction.removeFromParent()
        suply.run(SKAction.sequence([moveAction,remove]))
        
        addChild(suply)
    }

    func didBegin(_ contact: SKPhysicsContact)
    {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == RoleCategory.enemyPlane.rawValue | RoleCategory.bullet.rawValue
        {
            let enemyPlane = (contact.bodyA.categoryBitMask & RoleCategory.enemyPlane.rawValue) == RoleCategory.enemyPlane.rawValue
                ? (contact.bodyA.node as! EnemyPlane) : (contact.bodyB.node as! EnemyPlane)
            
            // hit bullet
            let bullet = contact.bodyA.categoryBitMask & RoleCategory.bullet.rawValue == RoleCategory.bullet.rawValue ? contact.bodyA.node as! SKSpriteNode : contact.bodyB.node as! SKSpriteNode
            
            bullet.run(SKAction.removeFromParent())
            enemyPlaneCollision(enemyPlane)
            
        }
        else if collision == RoleCategory.enemyPlane.rawValue | RoleCategory.heroPlane.rawValue
        {
            let enemyPlane = (contact.bodyA.categoryBitMask & RoleCategory.enemyPlane.rawValue) == RoleCategory.enemyPlane.rawValue
                ? (contact.bodyA.node as! EnemyPlane) : (contact.bodyB.node as! EnemyPlane)
            
            // hit hero plane
            let heroPlane = contact.bodyA.categoryBitMask & RoleCategory.heroPlane.rawValue == RoleCategory.heroPlane.rawValue ? contact.bodyA.node as! HeroPlane : contact.bodyB.node as! HeroPlane
            heroPlanePlaneCollision(heroPlane)
            enemyPlaneCollision(enemyPlane)
        
        }
        else if collision == RoleCategory.suply.rawValue | RoleCategory.heroPlane.rawValue
        {
            let suply = (contact.bodyA.categoryBitMask & RoleCategory.suply.rawValue) == RoleCategory.suply.rawValue
                ? (contact.bodyA.node as! Suply) : (contact.bodyB.node as! Suply)
            let heroPlane = contact.bodyA.categoryBitMask & RoleCategory.heroPlane.rawValue == RoleCategory.heroPlane.rawValue ? contact.bodyA.node as! HeroPlane : contact.bodyB.node as! HeroPlane
            
            if suply.type.rawValue == SuplyType.bulletSuply.rawValue {
                upgradeHeroPlaneBullet(heroPlane)
            }
            else if suply.type.rawValue == SuplyType.hpSuply.rawValue {
                upgradeHeroPlaneHp(heroPlane)
            }
            suply.run(SKAction.removeFromParent())
            
            
            
        }
    }
    
    func enemyPlaneCollision(_ enemyPlane:EnemyPlane)
    {
        enemyPlane.hp -= 1
        if enemyPlane.hp < 0 {
            enemyPlane.hp = 0
        }
        if enemyPlane.hp > 0 {
            switch enemyPlane.type{
            case .small:
                 print("no small hit image")
            case .large:
                enemyPlane.run(largePlaneHitAction)
            case .medium:
                enemyPlane.run(mediumPlaneHitAction)
            }
            
        } else {
            switch enemyPlane.type{
            case .small:
                changeScore(.small)
                enemyPlane.run(smallPlaneBlowUpAction)
                run(SKAction.playSoundFileNamed("enemy1_down.mp3", waitForCompletion: false))
                changeGameLevel()
                enemyPlane.run(SKAction.removeFromParent())
            case .large:
                changeScore(.large)
                enemyPlane.run(largePlaneBlowUpAction)
                run(SKAction.playSoundFileNamed("enemy2_down.mp3", waitForCompletion: false))
                changeGameLevel()
                enemyPlane.run(SKAction.removeFromParent())
            case .medium:
                changeScore(.medium)
                enemyPlane.run(mediumPlaneBlowUpAction)
                run(SKAction.playSoundFileNamed("enemy3_down.mp3", waitForCompletion: false))
                changeGameLevel()
                enemyPlane.run(SKAction.removeFromParent())
            }
        }
    }
    func upgradeHeroPlaneBullet(_ heroPlane:HeroPlane){
        heroPlane.weaponLevel += 1
    }
    func upgradeHeroPlaneHp(_ heroPlane:HeroPlane){
        heroPlane.hp += 1
    }
    func heroPlanePlaneCollision(_ heroPlane:HeroPlane)
    {
        heroPlane.hp -= 1
        if heroPlane.hp < 0 {
            heroPlane.hp = 0
        }
        if heroPlane.hp == 0{
            print("hit plane")
            var finalscore = Int(self.scoreLabel.text!)!
            if finalscore > score1
            {
                score5 = score4
                score4 = score3
                score3 = score2
                score2 = score1
                score1 = finalscore
            }
            else if (finalscore > score2 && finalscore < score1 )
            {
                score5 = score4
                score4 = score3
                score3 = score2
                score2 = finalscore
            }
            else if (finalscore > score3 && finalscore < score2 )
            {
                score5 = score4
                score4 = score3
                score3 = finalscore
            }
            else if (finalscore > score4 && finalscore < score3 )
            {
                score5 = score4
                score4 = finalscore
            }
            else if (finalscore > score5 && finalscore < score4 )

            {
                score5 = finalscore
            }
            
            heroPlane.run(heroPlaneBlowUpAction,completion:{() in
                self.run(SKAction.sequence([
                    SKAction.playSoundFileNamed("game_over.mp3", waitForCompletion: true),
                    SKAction.run({() in
                        let label = SKLabelNode(fontNamed:"MarkerFelt-Thin")
                        label.text = "GameOver"
                        label.zPosition = 2
                        label.fontColor = SKColor.black
                        label.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 20)
                        self.addChild(label)
                    })
                    ])
                    ,completion:{() in
                        self.resignFirstResponder()
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "gameOverNotification"), object: nil)
                }
                )}
            )
        }
    }
}
