//
//  GameViewController.swift
//  SceneKitLearn
//
//  Created by Artem Sherbachuk (UKRAINE) on 9/29/16.
//  Copyright © 2016 FSStudio. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    override var shouldAutorotate: Bool { return true }
    override var prefersStatusBarHidden: Bool {return true}
    
    @IBOutlet var sceneView: SCNView!
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let shape = RundomShapeNodeGenerator()
    var renderContolTime: TimeInterval = 0
    
    let gameHelper = GameHelper.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        setScene()
        setCamera()
        renderShape()
        setupHUD()
    }
    
    fileprivate func setScene() {
        //sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.showsStatistics = true
        sceneView.delegate = self
        sceneView.isPlaying = true
        sceneView.scene = scene
        scene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    fileprivate func setCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        scene.rootNode.addChildNode(cameraNode)
    }
    fileprivate func renderShape() {
        let rundomShape = shape.rundom()
        scene.rootNode.addChildNode(rundomShape)
    }
    fileprivate func removeShape() {
        for node in scene.rootNode.childNodes where node.presentation.position.y < -2 {
            node.removeFromParentNode()
        }
    }
    fileprivate func setupHUD() {
        gameHelper.hudNode.position = SCNVector3(x: 0.0, y: 10.0, z: 0.0)
        scene.rootNode.addChildNode(gameHelper.hudNode)
    }
    fileprivate func handleTouch(node: SCNNode) {
        if node.name == "GOOD" {
            gameHelper.score += 1
            createExplosion(node: node)
            node.removeFromParentNode()
        } else if node.name == "BAD" {
            gameHelper.score -= 1
            createExplosion(node: node)
            node.removeFromParentNode()
        }
    }
    func createExplosion(node:SCNNode) {
        let explosion = SCNParticleSystem(named: "Explode.scnp", inDirectory:nil)!
        explosion.emitterShape = node.geometry
        explosion.birthLocation = .surface
        
        let rotation = node.presentation.rotation
        let position = node.presentation.position
        let rotationMatrix = SCNMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
        let translationMatrix = SCNMatrix4MakeTranslation(position.x, position.y, position.z)
        let transformMatrix = SCNMatrix4Mult(rotationMatrix, translationMatrix)
        scene.addParticleSystem(explosion, transform: transformMatrix)
    }
    
    //MARK: - SCNSceneRendererDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > renderContolTime {
            self.renderShape()
            renderContolTime = time + TimeInterval(Float.random(min: 0.2, max: 1.5))
        }
        removeShape()
        gameHelper.updateHUD()
    }
    
    
    //MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {return}
        let location = touch.location(in: sceneView)
        let hitResult = sceneView.hitTest(location, options: nil)
        if hitResult.count > 0 {
            let result = hitResult.first!
            handleTouch(node: result.node)
        }
    }
}
