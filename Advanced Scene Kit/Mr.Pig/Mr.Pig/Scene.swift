//
//  Scene.swift
//  Mr.Pig
//
//  Created by Artem Sherbachuk (UKRAINE) on 11/10/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import SceneKit
import SpriteKit

final class Scene {
    
    let view: SCNView!
    let gameScene: SCNScene!
    let introScene: SCNScene!
    let statusBar: StatusBar!
    
    let mainCharacter: MainCharacter!
    let camera: SCNNode!
    let cameraFollowNode: SCNNode
    let lightFollowNode: SCNNode!
    let carsTraffic: CarsTraffic!
    
    init(view: SCNView) {
        self.view = view
        gameScene = SCNScene(named: "/MrPig.scnassets/GameScene.scn")
        introScene = SCNScene(named: "/MrPig.scnassets/IntroScene.scn")
        view.scene = introScene
        
        statusBar = StatusBar(coinsBanked: 0, coinsCollected: 0)
        
        let mrPig = gameScene.rootNode.childNode(withName: "MrPig", recursively: true)!
        let mrPigCollision = gameScene.rootNode.childNode(withName: "Collision", recursively: true)!
        mainCharacter = MainCharacter(characterNode: mrPig, collisionNode: mrPigCollision)
        mainCharacter.setViewForGestureRecognizers(view: view)
        
        camera = gameScene.rootNode.childNode(withName: "camera", recursively: true)!
        camera.addChildNode(statusBar.rootNode)
        cameraFollowNode = gameScene.rootNode.childNode(withName: "FollowCamera", recursively: true)!
        lightFollowNode = gameScene.rootNode.childNode(withName: "FollowLight", recursively: true)!
        carsTraffic = CarsTraffic(rootNode: gameScene.rootNode.childNode(withName: "Traffic", recursively: true)!)
    }

    
    //MARK: - Scene States
    //---------------------------------------------------------------------------------//
    
    func startGame() {
        sceneTransition(fromScene: introScene, toScene: gameScene)
        carsTraffic.startMovingTraffic()
        mainCharacter.placedInStartPosition()
    }
    
    func introStart() {
        sceneTransition(fromScene: gameScene, toScene: introScene)
    }
    
    func gameOver() {
        mainCharacter.die { [weak self] in
            self?.introStart()
        }
    }
    
    
    //MARK: - Redraw
    //---------------------------------------------------------------------------------//
    func redraw() {
        updateCamera()
        updateLights()
        mainCharacter.updatePosition()
        carsTraffic.updateTraffic()
    }
    
    //MARK: - Nodes controll
    //---------------------------------------------------------------------------------//
    
    func coinContactActionFrom(contact: SCNPhysicsContact) {
        let coin = contact.nodeA.physicsBody!.categoryBitMask == BitMaskCoin ? contact.nodeA : contact.nodeB
        coin.isHidden = true
        coin.runAction(SCNAction.waitForDurationThenRunBlock(60, block: { coin in
            coin.isHidden = false
        }))
    }
    
    
    private func updateCamera() {
        let camX = (mainCharacter.rootNode.position.x - cameraFollowNode.position.x) * 1.0
        let camY = (mainCharacter.rootNode.position.y - cameraFollowNode.position.y) * 0.1
        let camZ = (mainCharacter.rootNode.position.z - cameraFollowNode.position.z) * 1.0
        cameraFollowNode.position.x += camX
        cameraFollowNode.position.z += camZ
        cameraFollowNode.position.y += camY
    }
    private func updateLights() {
        lightFollowNode.position = cameraFollowNode.position
    }
    
    
    private func sceneTransition(fromScene: SCNScene, toScene: SCNScene) {
        fromScene.isPaused = true
        let transition = SKTransition.push(with: .down, duration: 1)
        view.present(toScene, with: transition, incomingPointOfView: nil) { _ in
            toScene.isPaused = false
        }
    }
}

final class StatusBar {
    
    let rootNode: SCNNode!
    let labelNode: SKLabelNode!
    
    init(coinsBanked: Int, coinsCollected: Int) {
        
        let skScene = SKScene(size: CGSize(width: 500, height: 100))
        skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        
        labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
        labelNode.fontSize = 20
        labelNode.position.y = 50
        labelNode.position.x = 250
        skScene.addChild(labelNode)
        
        let plane = SCNPlane(width: 5, height: 1)
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane.materials = [material]
        
        rootNode = SCNNode(geometry: plane)
        rootNode.name = "HUD"
        rootNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: 3.14159265)
        rootNode.position = SCNVector3(x:0, y: 1.8, z: -5)
        
        update(coinsBanked: coinsBanked, coinsCollected: coinsCollected)
    }
    
    func update(coinsBanked: Int, coinsCollected: Int) {
        let coinsBankedFormatted = String(format: "%0\(4)d", coinsBanked)
        let coinsCollectedFormatted = String(format: "%0\(4)d", coinsCollected)
        labelNode.text = "🐽\(coinsCollectedFormatted) | 🏡\(coinsBankedFormatted)"
    }
}
