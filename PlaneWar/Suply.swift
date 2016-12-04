//
//  Suply.swift
//  PlaneWar
//
//  Created by neo on 02/12/2016.
//  Copyright © 2016 FloodSurge. All rights reserved.
//

import Foundation
import SpriteKit
enum SuplyType : Int{
    case bulletSuply = 0
    case hpSuply = 1
}
class Suply:SKSpriteNode{
    var type:SuplyType = .bulletSuply
    class func createBulletSuply() ->Suply{
        let suplyTexture = SKTexture(imageNamed:"enemy5_fly_1")
        let suply = Suply(texture:suplyTexture)
        suply.type = SuplyType.bulletSuply
        suply.setScale(0.5)
        suply.physicsBody = SKPhysicsBody(rectangleOf:suply.size)
        return suply
    }
    class func createHpSuply() ->Suply{
        let suplyTexture = SKTexture(imageNamed:"enemy4_fly_1")
        let suply = Suply(texture:suplyTexture)
        suply.type = SuplyType.hpSuply
        suply.setScale(0.5)
        suply.physicsBody = SKPhysicsBody(rectangleOf:suply.size)
        return suply
    }



}
