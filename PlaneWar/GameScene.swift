//
//  GameScene.swift
//  PlaneShooter
//
//  Copyright © 2016年 FloodSurge. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var heroPlane:HeroPlane!
    var scoreLabel:SKLabelNode!
    var pauseButton:SKSpriteNode!
    var gameLevel:SKLabelNode!
    var backgroundMusic:AVAudioPlayer!

    
    var smallPlaneHitAction:SKAction!
    var smallPlaneBlowUpAction:SKAction!
    var mediumPlaneHitAction:SKAction!
    var mediumPlaneBlowUpAction:SKAction!
    var largePlaneHitAction:SKAction!
    var largePlaneBlowUpAction:SKAction!
    var heroPlaneBlowUpAction:SKAction!
    var curlevel:Int = 1
    
    var lifeSprite = [SKSpriteNode]()
    
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
        initGameLife(0)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.restart), name: NSNotification.Name(rawValue: "restartNotification"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(GameScene.pause), name: NSNotification.Name(rawValue: "pauseNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.continuegame), name: NSNotification.Name(rawValue: "continueNotification"), object: nil)
    }
    
    func restart(){
        removeAllChildren()
        removeAllActions()
        backgroundMusic.stop()
        
        self.isPaused = false
        initBackground()
        initActions()
        initScoreLabel()
        initGameLevel()
        initHeroPlane()
        initEnemyPlane()
        initSupply()
        initGameLife(0)
        
        
    }
    func pause(){
        backgroundMusic.pause()
        self.isPaused = true
    }
    func continuegame(){
        self.isPaused = false
        backgroundMusic.play()
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
    
    
    func initGameLife(_ lifetype: Int){
        //0 is init , 1 is add hp , 2 is minus hp
        
        switch lifetype {
        case 0:
            let lifeTexture = SKTexture(imageNamed:"hero_fly_1")
            lifeSprite.append(SKSpriteNode(texture:lifeTexture))
            lifeSprite[heroPlane.hp-1].setScale(0.2)
            lifeSprite[heroPlane.hp-1].name = "\(heroPlane.hp-1)"
            lifeSprite[heroPlane.hp-1].position = CGPoint(x: 350 - (heroPlane.hp-1) * 30, y: 32 )
            addChild(lifeSprite[heroPlane.hp-1])
        case 1:
            let lifeTexture = SKTexture(imageNamed:"hero_fly_1")
            lifeSprite.append(SKSpriteNode(texture:lifeTexture))
            lifeSprite[heroPlane.hp-1].setScale(0.2)
            lifeSprite[heroPlane.hp-1].name = "\(heroPlane.hp-1)"
            lifeSprite[heroPlane.hp-1].position = CGPoint(x: 350 - (heroPlane.hp-1) * 30, y: 32 )
            addChild(lifeSprite[heroPlane.hp-1])
        case 2:
            lifeSprite.removeLast()
            var tmp = [SKSpriteNode]()
            tmp.append(childNode(withName: "\(heroPlane.hp)") as! SKSpriteNode)
            removeChildren(in: tmp)
        default:
            print("default")
        }
    }
    
    func initBackground()
    {
        // init texture
        let backgroundTexture = SKTexture(imageNamed:"background.png")
        backgroundTexture.filteringMode = .nearest
        // set action
        let moveBackgroundSprite = SKAction.moveBy(x: 0, y:-backgroundTexture.size().height-10, duration: 15)
        let resetBackgroundSprite = SKAction.moveBy(x: 0, y:backgroundTexture.size().height, duration: 0)
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackgroundSprite,resetBackgroundSprite]))
        // init background sprite
        
        for index in 0..<2 {
            let backgroundSprite = SKSpriteNode(texture:backgroundTexture)
            backgroundSprite.position = CGPoint(x: size.width/2,y: size.height / 2 + CGFloat(index) * backgroundSprite.size.height)
            backgroundSprite.zPosition = 0
            backgroundSprite.run(moveBackgroundForever,withKey:"movebackground")
            addChild(backgroundSprite)
            
        }
        // play background music
        let path = Bundle.main.path(forResource: "game_music.mp3", ofType:nil)!
        let backgroundMusicURL = URL(fileURLWithPath: path)
        do
        {
          backgroundMusic = try AVAudioPlayer.init(contentsOf: backgroundMusicURL)
        }
        catch
        _{
            print("no background music")
        }
        backgroundMusic.play()
        
//        backgroundSprite.isPaused = true
        // set physics world
        
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
    }
    
    func initActions()
    {
        // small hit action
        // nil
        
        
        
        //small hit action
        var smallPlaneHitTexture = [SKTexture]()
        smallPlaneHitTexture.append(SKTexture(imageNamed:"enemy1_hit_1.png"))
        smallPlaneHitTexture.append(SKTexture(imageNamed:"enemy1_fly_1.png"))
        smallPlaneHitAction = SKAction.animate(with: smallPlaneHitTexture, timePerFrame: 0.2)
        
        // medium hit action
        var mediumPlaneHitTexture = [SKTexture]()
        mediumPlaneHitTexture.append(SKTexture(imageNamed:"enemy3_hit_1.png"))
        mediumPlaneHitTexture.append(SKTexture(imageNamed:"enemy3_fly_1.png"))
        mediumPlaneHitAction = SKAction.animate(with: mediumPlaneHitTexture, timePerFrame: 0.2)
        
        // large hit action
        var largePlaneHitTexture = [SKTexture]()
        largePlaneHitTexture.append(SKTexture(imageNamed:"enemy2_hit_1.png"))
        largePlaneHitTexture.append(SKTexture(imageNamed:"enemy2_fly_2.png"))
        largePlaneHitAction = SKAction.animate(with: largePlaneHitTexture, timePerFrame: 0.2)
        
        // small blow up action
        var smallPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            smallPlaneBlowUpTexture.append(SKTexture(imageNamed:"enemy1_blowup_\(i).png"))
        }
        smallPlaneBlowUpAction = SKAction.sequence([SKAction.animate(with: smallPlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        
        // medium blow up action
        var mediumPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            print(i)
            mediumPlaneBlowUpTexture.append(SKTexture(imageNamed:"enemy3_blowup_\(i).png"))
        }
        mediumPlaneBlowUpAction = SKAction.sequence([SKAction.animate(with: mediumPlaneBlowUpTexture, timePerFrame: 0.2),SKAction.removeFromParent()])
        
        
        // large blow up action
        var largePlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            largePlaneBlowUpTexture.append(SKTexture(imageNamed:"enemy2_blowup_\(i).png"))
        }
        largePlaneBlowUpAction = SKAction.sequence([SKAction.animate(with: largePlaneBlowUpTexture, timePerFrame: 0.2),SKAction.removeFromParent()])
        
        // hero plane blow up action
        var heroPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            heroPlaneBlowUpTexture.append(SKTexture(imageNamed:"hero_blowup_\(i).png"))
        }
        heroPlaneBlowUpAction = SKAction.sequence([SKAction.animate(with: heroPlaneBlowUpTexture, timePerFrame: 0.2),SKAction.removeFromParent()])
        
    }
    
    func initScoreLabel()
    {
        scoreLabel = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        scoreLabel.text = "0000"
        scoreLabel.zPosition = 2
        scoreLabel.fontColor = SKColor.yellow
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 50, y: size.height - 52)
        addChild(scoreLabel)
        
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
        gameLevel.fontColor = SKColor.yellow
        gameLevel.horizontalAlignmentMode = .right
        gameLevel.position = CGPoint(x: size.width-10, y: size.height - 52)
        addChild(gameLevel)
        
        let gameLevelText = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        gameLevelText.text = "Level:"
        gameLevelText.zPosition = 2
        gameLevelText.fontColor = SKColor.cyan
        gameLevelText.horizontalAlignmentMode = .right
        gameLevelText.position = CGPoint(x: size.width-37, y: size.height - 52)
        addChild(gameLevelText)
        
    }
    
    func changeGameLevel()
    {
        let curScore = Int(scoreLabel.text!)
        if curScore != nil {
            if( curScore! > 50000 && curScore! < 150000 && curlevel < 2)
            {
                curlevel = 2
                self.levelup()
            }
            else if( curScore! > 150000 && curScore! < 300000 && curlevel < 3)
            {
                curlevel = 3
                self.levelup()
            }
            else if(curScore! > 150000 && curlevel < 4)
            {
                curlevel = 4
                self.levelup()
            }
            /*switch  curScore!{
             case 0..<50000:
             level = 1
             case 50000..<100000:
             level = 2
             case 100000..<150000:
             level = 3
             default:
             level = 4
             }*/
        }
        gameLevel.run(SKAction.run({() in
            self.gameLevel.text = "\(self.curlevel)"
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
        print(heroPlane.hp)
        addChild(heroPlane)
        
        // fire bullets
        let spawn = SKAction.run{() in
            self.createBullet()}
        let wait = SKAction.wait(forDuration: 0.3/Double(self.heroPlane.weaponLevel))
        
        heroPlane.run(SKAction.repeatForever(SKAction.sequence([spawn,wait])))
        
    }
    
    func createBullet()
    {
        var bulletTexture:SKTexture
        if(heroPlane.weaponLevel > 4)
        {
            bulletTexture = SKTexture(imageNamed:"bullet4")
        }
        else{
            bulletTexture = SKTexture(imageNamed:"bullet\(self.heroPlane.weaponLevel)")
        }
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
        bullet.run(SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false))
        addChild(bullet)
        // play bullet music
        
//        run(SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false))
        
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
            //            run(SKAction.playSoundFileNamed("enemy2_out.mp3", waitForCompletion: false))
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
            enemyPlaneHit(enemyPlane)
            heroPlanePlaneCollision(heroPlane)
            
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
    
    func levelup()  {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LevelUpNotification"), object: nil)
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
                enemyPlane.run(smallPlaneHitAction)
            case .large:
                enemyPlane.run(largePlaneHitAction)
            case .medium:
                enemyPlane.run(mediumPlaneHitAction)
            }
            
        } else
        {   enemyPlane.physicsBody?.categoryBitMask = 0
            switch enemyPlane.type{
            case .small:
                changeScore(.small)
                enemyPlane.run(smallPlaneBlowUpAction)
                run(SKAction.playSoundFileNamed("enemy1_down.mp3", waitForCompletion: false))
                changeGameLevel()
            case .large:
                changeScore(.large)
                enemyPlane.run(largePlaneBlowUpAction)
                run(SKAction.playSoundFileNamed("enemy2_down.mp3", waitForCompletion: false))
                changeGameLevel()
            case .medium:
                changeScore(.medium)
                enemyPlane.run(mediumPlaneBlowUpAction)
                run(SKAction.playSoundFileNamed("enemy3_down.mp3", waitForCompletion: false))
                changeGameLevel()
            }
        }
    }
    func enemyPlaneHit(_ enemyPlane:EnemyPlane)
    {
        enemyPlane.physicsBody?.categoryBitMask = 0
        switch enemyPlane.type{
        case .small:
            changeScore(.small)
            enemyPlane.run(smallPlaneBlowUpAction)
            run(SKAction.playSoundFileNamed("enemy1_down.mp3", waitForCompletion: false))
            changeGameLevel()
        case .large:
            changeScore(.large)
            enemyPlane.run(largePlaneBlowUpAction)
            run(SKAction.playSoundFileNamed("enemy2_down.mp3", waitForCompletion: false))
            changeGameLevel()
        case .medium:
            changeScore(.medium)
            enemyPlane.run(mediumPlaneBlowUpAction)
            run(SKAction.playSoundFileNamed("enemy3_down.mp3", waitForCompletion: false))
            changeGameLevel()
        }
    }
    func upgradeHeroPlaneBullet(_ heroPlane:HeroPlane){
        heroPlane.weaponLevel += 1
    }
    func upgradeHeroPlaneHp(_ heroPlane:HeroPlane){
        heroPlane.hp += 1
        //add a life button
        initGameLife(1)
        
    }
    func heroPlanePlaneCollision(_ heroPlane:HeroPlane)
    {   print(heroPlane.hp)
        heroPlane.hp -= 1
        initGameLife(2)
        if heroPlane.hp < 0 {
            heroPlane.hp = 0
        }
        if heroPlane.hp == 0{
            heroPlane.physicsBody?.categoryBitMask = 0
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
                        label.fontColor = SKColor.red
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
