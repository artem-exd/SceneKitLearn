//
//  Extentions.swift
//  Mr.Pig
//
//  Created by Artem Sherbachuk (UKRAINE) artemsherbachuk@gmail.com on 11/12/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import SceneKit


extension SCNPhysicsContact {
    
    var isCoinContated: Bool {
        return (self.nodeA.physicsBody!.categoryBitMask == BitMaskCoin) || (self.nodeB.physicsBody!.categoryBitMask == BitMaskCoin)
    }
    
    var isVehicleContacted: Bool {
        return (self.nodeA.physicsBody!.categoryBitMask == BitMaskVehicle) || (self.nodeB.physicsBody!.categoryBitMask == BitMaskVehicle)
    }
    
    var isObstacleContacted: Bool {
        return (self.nodeA.physicsBody!.categoryBitMask == BitMaskObstacle) || (self.nodeB.physicsBody!.categoryBitMask == BitMaskObstacle)
    }
    
    var isHouseContacted: Bool {
        return (self.nodeA.physicsBody!.categoryBitMask == BitMaskHouse) || (self.nodeB.physicsBody!.categoryBitMask == BitMaskHouse)
    }
}
