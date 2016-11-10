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
    let hudNode: HUDNode!
    
    init(view: SCNView) {
        self.view = view
        gameScene = SCNScene(named: "/MrPig.scnassets/GameScene.scn")
        introScene = SCNScene(named: "/MrPig.scnassets/IntroScene.scn")
        view.scene = introScene
        
        hudNode = HUDNode(coinsBanked: 0, coinsCollected: 0)
    }

    
    func startGame() {
        sceneTransition(fromScene: introScene, toScene: gameScene)
    }
    
    func introStart() {
        sceneTransition(fromScene: gameScene, toScene: introScene)
    }
    
    private func sceneTransition(fromScene: SCNScene, toScene: SCNScene) {
        fromScene.isPaused = true
        let transition = SKTransition.reveal(with: .up, duration: 1)//SKTransition.doorsOpenVertical(withDuration: 1)
        view.present(toScene, with: transition, incomingPointOfView: nil) { _ in
            toScene.isPaused = false
        }
    }
}

final class HUDNode {
    
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
