//
//  GameViewController.swift
//  MarbleMaze
//
//  Created by Artem Sherbachuk (UKRAINE) on 11/7/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

final class GameViewController: UIViewController {
    override var shouldAutorotate: Bool {
        return true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var gameView: GameView!
    private(set) var scene: SCNScene!
    private(set) var ballNode: SCNNode!
    private(set)var gameCore: GameCore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupNodes()
    }
    private func setupScene() {
        gameCore = GameCore()
        scene = SCNScene(named: "art.scnassets/game.scn")
        gameView.delegate = gameCore
        gameView.scene = scene
        scene.physicsWorld.contactDelegate = gameCore
    }
    private func setupNodes() {
        ballNode = scene.rootNode.childNode(withName: "ball", recursively: true)!
    }
}
