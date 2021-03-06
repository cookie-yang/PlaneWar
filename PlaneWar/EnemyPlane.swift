//
//  EnemyPlane.swift
//  PlaneWar
//
//  Copyright © 2016年 FloodSurge. All rights reserved.
//

import SpriteKit

enum EnemyPlaneType:Int{
    case small = 0
    case medium = 1
    case large = 2
}

class EnemyPlane:SKSpriteNode {
    
    var hp:Int = 5
    var type:EnemyPlaneType = .small
    
    class func createSmallPlane()->EnemyPlane{
        let planeTexture = SKTexture(imageNamed:"enemy1_fly_1.png")
        let plane = EnemyPlane(texture:planeTexture)
//        plane.hp = 1
        plane.type = EnemyPlaneType.small
        plane.setScale(0.5)
        
        //plane.physicsBody = SKPhysicsBody(texture:planeTexture,size:plane.size)
        plane.physicsBody = SKPhysicsBody(texture:planeTexture,size:plane.size)
        return plane
    }
    
    class func createMediumPlane()->EnemyPlane{
        let planeTexture = SKTexture(imageNamed:"enemy3_fly_1.png")
        let plane = EnemyPlane(texture:planeTexture)
        plane.type = EnemyPlaneType.medium
        plane.setScale(0.5)
        //plane.physicsBody = SKPhysicsBody(rectangleOfSize: plane.size)
        plane.physicsBody = SKPhysicsBody(texture:planeTexture,size:plane.size)
        return plane
    }
    
    class func createLargePlane()->EnemyPlane{
        let planeTexture = SKTexture(imageNamed:"enemy2_fly_1.png")
        let plane = EnemyPlane(texture:planeTexture)
        plane.type = EnemyPlaneType.large
        plane.setScale(0.5)
        //plane.physicsBody = SKPhysicsBody(rectangleOfSize: plane.size)
        plane.physicsBody = SKPhysicsBody(texture:planeTexture,size:plane.size)
        return plane
    }
    
}


