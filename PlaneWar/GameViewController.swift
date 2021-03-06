//
//  GameViewController.swift
//  PlaneShooter
//
//  Created by 罗晗璐 on 2016/11/30.
//  Copyright © 2016年 FloodSurge. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        
        let path = Bundle.main.path(forResource: file as String, ofType: "sks")
        
        do {
            let sceneData: Data = try Data(contentsOf: URL(fileURLWithPath: path!), options: NSData.ReadingOptions.mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
            
        } catch {
            
        }
        return nil
    }
}

class GameViewController: UIViewController {

    var restartButton:UIButton!
    var pauseButton:UIButton!
    var continueButton:UIButton!

    var isbackgroundView = false
    var backgroundView:UIView!

    var backButton:UIButton!
    var score:Int!
    var levelupLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView


            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            scene.size = view.frame.size
            
            skView.presentScene(scene)
            
            // add button
            initView()
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.gameOver), name: NSNotification.Name(rawValue: "gameOverNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.levelupAlert), name: NSNotification.Name(rawValue: "LevelUpNotification"), object: nil)
            
        }
    }
    
    func initView(){
        let buttonImage = UIImage(named:"BurstAircraftPause")!
        
        pauseButton = UIButton()
        pauseButton.frame = CGRect(x: 10, y: 25, width: buttonImage.size.width, height: buttonImage.size.height)
        pauseButton.setBackgroundImage(buttonImage, for: UIControlState())
        pauseButton.addTarget(self, action: #selector(GameViewController.pause), for: .touchUpInside)
        view.addSubview(pauseButton)
        
        backButton = UIButton()
        backButton.bounds = CGRect(x: 0, y: 0, width: 200, height: 30)
        backButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2 - 50)
        backButton.isHidden = true
        backButton.setTitle("Home", for: UIControlState())
        backButton.setTitleColor(UIColor.yellow, for: UIControlState())
        backButton.titleLabel?.font = UIFont(name:"ChalkboardSE-Bold", size:20)
        backButton.layer.borderWidth = 2.0
        backButton.layer.cornerRadius = 15.0
        backButton.layer.borderColor = UIColor.gray.cgColor
        backButton.addTarget(self, action: #selector(GameViewController.backHome), for: .touchUpInside)
        view.addSubview(backButton)
        
        restartButton = UIButton()
        restartButton.bounds = CGRect(x: 0, y: 0, width: 200, height: 30)
        restartButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2 + 50)
        restartButton.isHidden = true
        restartButton.setTitle("Restart", for: UIControlState())
        restartButton.setTitleColor(UIColor.yellow, for: UIControlState())
        restartButton.titleLabel?.font = UIFont(name:"ChalkboardSE-Bold", size:20)
        restartButton.layer.borderWidth = 2.0
        restartButton.layer.cornerRadius = 15.0
        restartButton.layer.borderColor = UIColor.gray.cgColor
        restartButton.addTarget(self, action: #selector(GameViewController.restart(_:)), for: .touchUpInside)
        view.addSubview(restartButton)
        
        continueButton = UIButton()
        continueButton.bounds = CGRect(x: 0, y: 0, width: 200, height: 30)
        continueButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2 )
        continueButton.isHidden = true
        continueButton.setTitle("Continue", for: UIControlState())
        continueButton.setTitleColor(UIColor.yellow, for: UIControlState())
        continueButton.titleLabel?.font = UIFont(name:"ChalkboardSE-Bold", size:20)
        continueButton.layer.borderWidth = 2.0
        continueButton.layer.cornerRadius = 15.0
        continueButton.layer.borderColor = UIColor.gray.cgColor
        continueButton.addTarget(self, action: #selector(GameViewController.continueGame(_:)), for: .touchUpInside)
        view.addSubview(continueButton)
        
        levelupLabel = UILabel()
        levelupLabel.bounds = CGRect(x: 0, y: 0, width: 150, height: 120)
        levelupLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2 - 30)
        levelupLabel.isHidden = true
        levelupLabel.text = "Level Up!"
        levelupLabel.textColor = UIColor.yellow
        levelupLabel.font = UIFont(name:"ChalkboardSE-Bold", size:30)
        levelupLabel.layer.borderColor = UIColor.black.cgColor
        view.addSubview(levelupLabel)
        

    }

    func gameOver(){
       if isbackgroundView == false{
        backgroundView = UIView(frame:view.bounds)
        restartButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2 + 20)
        backButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2 + 60)
        restartButton.isHidden = false
        backButton.isHidden = false
        backgroundView.addSubview(restartButton)
        backgroundView.addSubview(backButton)
        backgroundView.center = view.center
        view.addSubview(backgroundView)
        pauseButton.removeFromSuperview()
        continueButton.removeFromSuperview()
        isbackgroundView = true
        }
    }
    
    func levelupAlert()
    {
        levelupLabel.isHidden = false
        self.perform(#selector(dismissAlert), with: levelupLabel, afterDelay: 0.5)
    }
    
    func dismissAlert(leveluplabel: UILabel)
    {
        levelupLabel.isHidden = true
    }
    
    func pause(){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"pauseNotification"),object:nil)
//        (view as! SKScene).isPaused = true
        restartButton.isHidden = false
        continueButton.isHidden = false
        backButton.isHidden = false
    }
    
    func backHome(){
        self.dismiss(animated: true)
    }

    
    func restart(_ button:UIButton){
        restartButton.isHidden = true
        continueButton.isHidden = true
        backButton.isHidden = true
        self.becomeFirstResponder()
        (view as! SKView).isPaused = false
        NotificationCenter.default.post(name: Notification.Name(rawValue: "restartNotification"), object: nil)
        if isbackgroundView == true{
            backgroundView.removeFromSuperview()
            initView()
            isbackgroundView = false
        }
        
    }
    
    func continueGame(_ button:UIButton){
        NotificationCenter.default.post(name: Notification.Name(rawValue:"continueNotification"),object:nil)
        continueButton.isHidden = true
        restartButton.isHidden = true
        backButton.isHidden = true
        
    }
   
    override var shouldAutorotate : Bool {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.portrait
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool
    {
        return true
    }
    
  
    
    
}
