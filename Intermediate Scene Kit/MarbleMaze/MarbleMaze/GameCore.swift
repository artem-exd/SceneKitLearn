//
//  GameCore.swift
//  MarbleMaze
//
//  Created by Artem Sherbachuk (UKRAINE) on 11/7/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//
import SceneKit


enum PhysicsMask: Int {
    case ball = 1
    case stone = 2
    case pillar = 4
    case crate = 8
    case pearl = 16
    
    func categoryMask() -> Int {
        return self.rawValue
    }
    
    func contactMask() -> Int {
        switch self {
        case .ball:
            return PhysicsMask.pillar.rawValue | PhysicsMask.crate.rawValue | PhysicsMask.pearl.rawValue
        default:
            return 1
        }
    }
    
    func collisionMask() -> Int {
        switch self {
        case .ball:
            return PhysicsMask.pillar.rawValue | PhysicsMask.crate.rawValue | PhysicsMask.stone.rawValue
        case .pearl:
            return -1
        default:
            return 1
        }
    }
}


final class GameCore: NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let contactedNode = contact.nodeA.name == "ball" ? contact.nodeA : contact.nodeB
        
        if isPearlContacted(contactedNode) {
            contactedNode.isHidden = true
            contactedNode.runAction(SCNAction.waitForDurationThenRunBlock(30) { node in
              node.isHidden = false
            })
        }
        
        if isBarrierContacted(contactedNode) {
            
        }
    }
    
    private func isPearlContacted(_ contactedNode: SCNNode) -> Bool {
        return contactedNode.physicsBody?.categoryBitMask == PhysicsMask.pearl.categoryMask()
    }
    private func isBarrierContacted(_ contactedNode: SCNNode) -> Bool {
        return contactedNode.physicsBody?.categoryBitMask == PhysicsMask.pillar.categoryMask() ||
        contactedNode.physicsBody?.categoryBitMask == PhysicsMask.crate.categoryMask()
    }
}
