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
    
    var scene: SCNScene!
    @IBOutlet weak var gameView: GameView!
    var gameCore: GameCore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    private func setupScene() {
        gameCore = GameCore()
        scene = SCNScene(named: "art.scnassets/game.scn")
        gameView.delegate = gameCore
        gameView.scene = scene
    }
}
