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
    
    @IBOutlet var sceneView: SCNView!
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let shape = RundomShapeNodeGenerator()
    var renderContolTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setScene()
        setCamera()
        renderShape()
    }
    
    fileprivate func setScene() {
        sceneView.allowsCameraControl = true
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
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //MARK: - SCNSceneRendererDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > renderContolTime {
            self.renderShape()
            renderContolTime = time + TimeInterval(Float.random(min: 0.2, max: 1.5))
        }
        removeShape()
    }
}
