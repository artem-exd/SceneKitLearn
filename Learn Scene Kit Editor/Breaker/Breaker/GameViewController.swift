//
//  GameViewController.swift
//  Breaker
//
//  Created by Artem Sherbachuk (UKRAINE) on 10/1/16.
//  Copyright © 2016 FSStudio. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    override var shouldAutorotate: Bool {return true}
    override var prefersStatusBarHidden: Bool {return true}
    
    var sceneView: SCNView!
    let gameHelper = GameHelper.sharedInstance
    var scene: SCNScene!
    var horizontalCamera: SCNNode!
    var verticalCamera: SCNNode!
    var ballNode: SCNNode!
    var paddleNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupNode()
        setupSounds()
    }
    
    func setupScene() {
        sceneView = self.view as! SCNView
        sceneView.delegate = self
        scene = SCNScene(named: "Breaker.scnassets/Scenes/Game.scn")!
        sceneView.scene = scene
    }
    func setupNode() {
        scene.rootNode.addChildNode(gameHelper.hudNode)
        horizontalCamera = scene.rootNode.childNode(withName: "HorizontalCamera", recursively: true)!
        verticalCamera = scene.rootNode.childNode(withName: "VerticalCamera", recursively: true)!
        ballNode = scene.rootNode.childNode(withName: "Ball", recursively: true)!
        paddleNode = scene.rootNode.childNode(withName: "Paddle", recursively: true)!
    }
    func setupSounds() {}
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let devOrientation = UIDevice.current.orientation
        switch devOrientation {
        case .portrait:
            sceneView.pointOfView = verticalCamera
        default:
            sceneView.pointOfView = horizontalCamera
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        gameHelper.updateHUD()
    }
}
