//
//  CarsTraffic.swift
//  Mr.Pig
//
//  Created by Artem Sherbachuk (UKRAINE) artemsherbachuk@gmail.com on 11/12/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import SceneKit

final class CarsTraffic {
    
    let rootNode: SCNNode!
    
    private let trafficDriveLeftInfinityAction: SCNAction!
    private let trafficDriveRightInfinityAction: SCNAction!
    
    init(rootNode: SCNNode) {
        self.rootNode = rootNode
        trafficDriveLeftInfinityAction = SCNAction.repeatForever(SCNAction.moveBy(x: -2, y: 0, z: 0, duration: 1))
        trafficDriveRightInfinityAction = SCNAction.repeatForever(SCNAction.moveBy(x: 2, y: 0, z: 0, duration: 1))
    }
    
    func startMovingTraffic() {
        rootNode.childNodes.forEach { car in
            let isBus = car.name == "Bus"
            trafficDriveLeftInfinityAction.speed = isBus ? 0.5 : 1
            trafficDriveRightInfinityAction.speed = isBus ? 0.5 : 1
            
            let isCarRidingLeft = car.eulerAngles.y > 0
            car.runAction(isCarRidingLeft ? trafficDriveLeftInfinityAction : trafficDriveRightInfinityAction)
        }
    }
    
    func updateTraffic() {
        rootNode.childNodes.forEach { car in
            let leftTrafficCarIsOut = car.position.x > 25
            let rightTrafficCarIsOut = car.position.x < -25
            if leftTrafficCarIsOut {
                car.position.x = -25
            } else if rightTrafficCarIsOut {
                car.position.x = 25
            }
        }
    }
    
}
