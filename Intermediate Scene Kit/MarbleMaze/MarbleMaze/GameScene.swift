//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Artem Sherbachuk (UKRAINE) on 11/8/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import SceneKit

class GameScene: SCNScene {
    
    private(set) var ballNode: SCNNode!
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNodes()
    }
    
    private func setupNodes() {
        ballNode = self.rootNode.childNode(withName: "ball", recursively: true)!
        ballNode.physicsBody?.contactTestBitMask = PhysicsMask.ball.contactMask()
        ballNode.physicsBody?.collisionBitMask = PhysicsMask.ball.collisionMask()
        ballNode.physicsBody?.categoryBitMask = PhysicsMask.ball.categoryMask()
    }
}
