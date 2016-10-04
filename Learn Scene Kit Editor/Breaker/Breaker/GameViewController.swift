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
    var lastContactNode: SCNNode!
    
    var touchX: CGFloat = 0
    var paddleX: Float = 0

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
        scene.physicsWorld.contactDelegate = self
    }
    func setupNode() {
        scene.rootNode.addChildNode(gameHelper.hudNode)
        horizontalCamera = scene.rootNode.childNode(withName: "HorizontalCamera", recursively: true)!
        verticalCamera = scene.rootNode.childNode(withName: "VerticalCamera", recursively: true)!
        ballNode = scene.rootNode.childNode(withName: "Ball", recursively: true)!
        paddleNode = scene.rootNode.childNode(withName: "Paddle", recursively: true)!
        
        //add physics
        ballNode.physicsBody?.contactTestBitMask  = ColiderType.Barrier.rawValue | ColiderType.Brick.rawValue | ColiderType.Paddle.rawValue
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let location = touch.location(in: sceneView)
            touchX = location.x
            paddleX = paddleNode.position.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { touch in
            let location = touch.location(in: sceneView)
            paddleNode.position.x = paddleX +  (Float(location.x - touchX) * 0.1)
            
            if paddleNode.position.x > 4.5 {
                paddleNode.position.x = 4.5
            } else if paddleNode.position.x < -4.5 {
                paddleNode.position.x = -4.5
            }
        }
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        gameHelper.updateHUD()
    }
}
extension GameViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let contactNode = contact.nodeA.name == "Ball" ? contact.nodeA : contact.nodeB
        if lastContactNode != nil && lastContactNode == contactNode {
            return
        } else {
          lastContactNode = contactNode
        }
        
        if contactNode.physicsBody?.categoryBitMask == ColiderType.Barrier.rawValue && contactNode.name == "Bottom" {
            gameHelper.lives -= 1
            if gameHelper.lives == 0 {
                gameHelper.saveState();
                gameHelper.reset();
            }
        }
        
        if contactNode.physicsBody?.categoryBitMask == ColiderType.Brick.rawValue {
            gameHelper.score += 1
            contactNode.isHidden = true
            contactNode.runAction(SCNAction.waitForDurationThenRunBlock(120) { node in
                node.isHidden = false
            })
        }
        
        if contactNode.physicsBody?.categoryBitMask == ColiderType.Paddle.rawValue {
            if contactNode.name == "Left" {
                ballNode.physicsBody?.velocity.xzAngle -= (convertToRadians(20))
            }
            if contactNode.name == "Right" {
                ballNode.physicsBody?.velocity.xzAngle += (convertToRadians(20))
            }
        }
        ballNode.physicsBody?.velocity.length = 5.0
    }
}

enum ColiderType: Int {
    case Ball = 0b1
    case Barrier = 0b10
    case Brick = 0b100
    case Paddle = 0b1000
}
