//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Artem Sherbachuk (UKRAINE) on 11/9/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import SceneKit

final class GameScene {

    let scene: SCNScene!
    let ballNode: SCNNode!
    let cameraNode: SCNNode!
    let cameraFollowNode: SCNNode!
    let lightFollowNode: SCNNode!
    
    init(view: SCNView) {
        scene = SCNScene(named: "art.scnassets/game.scn")
        view.scene = scene
        
        ballNode = scene.rootNode.childNode(withName: "ball", recursively: true)!
        
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
        let constraint = SCNLookAtConstraint(target: ballNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        cameraNode.addChildNode(GameHelper.sharedInstance.hudNode)
        
        cameraFollowNode = scene.rootNode.childNode(withName: "folow_camera", recursively: true)!
        lightFollowNode = scene.rootNode.childNode(withName: "follow_light", recursively: true)!
    }
    
    func playGame() {
        cameraFollowNode.eulerAngles.y = 0
        cameraFollowNode.position = SCNVector3Zero
        replanishLife()
    }
    
    func resetGame() {
        //GameHelper.sharedInstance.playSound(ballNode, name: "Reset")
        ballNode.physicsBody!.velocity = SCNVector3Zero
        ballNode.position = SCNVector3(x:0, y:10, z:0)
        cameraFollowNode.position = ballNode.position
        lightFollowNode.position = ballNode.position
        GameHelper.sharedInstance.reset()
    }
    
    func isBallOut() -> Bool {
        return ballNode.presentation.position.y < -5
    }
    
    func updateCameraAndLight(forState state: GameStateType) {
        let camPosX = (ballNode.position.x - cameraFollowNode.position.x) * 0.01
        let camPosY = (ballNode.position.y - cameraFollowNode.position.y) * 0.01
        let camPosZ = (ballNode.position.z - cameraFollowNode.position.z) * 0.01
        cameraFollowNode.position.x += camPosX
        cameraFollowNode.position.y += camPosY
        cameraFollowNode.position.z += camPosZ
        lightFollowNode.position = cameraFollowNode.position
        if state == .tapToPlay {
            cameraFollowNode.eulerAngles.y += 0.005
        }
    }
    
    func replanishLife() {
        let firstMaterial = ballNode.geometry!.firstMaterial!
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        firstMaterial.emission.intensity = 1.0
        SCNTransaction.commit()
        
        GameHelper.sharedInstance.score += 1
        GameHelper.sharedInstance.playSound(ballNode, name: "Powerup")
    }
    
    func diminishLife() {
        let firstMaterial = ballNode.geometry!.firstMaterial!
        if firstMaterial.emission.intensity > 0 {
            firstMaterial.emission.intensity -= 0.001
        } else {
            //TODO Delegate to reset game
        }
    }
}
