//
//  HeroPlane.swift
//  PlaneWar
//
//  Created by neo on 03/12/2016.
//  Copyright © 2016 FloodSurge. All rights reserved.
//

import Foundation
import SpriteKit
class HeroPlane:SKSpriteNode {
    var hp:Int = 1
    var weaponLevel:Int = 1
    class func createHeroPlane() ->HeroPlane {
        let heroPlaneTexture1 = SKTexture(imageNamed:"hero_fly_1")
        let heroPlaneTexture2 = SKTexture(imageNamed:"hero_fly_2")
        let heroPlane = HeroPlane(texture:heroPlaneTexture1)
        heroPlane.setScale(0.5)
        let heroPlaneAction = SKAction.animate(with: [heroPlaneTexture1,heroPlaneTexture2], timePerFrame: 0.1)
        heroPlane.run(SKAction.repeatForever(heroPlaneAction))
        print(heroPlane.size)
        heroPlane.physicsBody = SKPhysicsBody(rectangleOf: heroPlane.size)
    return heroPlane
    }




}
