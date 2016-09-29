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

class GameViewController: UIViewController {
    
    @IBOutlet var sceneView: SCNView!
    let scene = SCNScene()
    let cameraNode = SCNNode()
    let shape = RundomShapeNodeGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.showsStatistics = true
        setScene()
        setCamera()
        setShapes()
    }
    
    fileprivate func setScene() {
        sceneView.scene = scene
        scene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    fileprivate func setCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        scene.rootNode.addChildNode(cameraNode)
    }
    fileprivate func setShapes() {
        let rundomShape = shape.rundom()
        scene.rootNode.addChildNode(rundomShape)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
