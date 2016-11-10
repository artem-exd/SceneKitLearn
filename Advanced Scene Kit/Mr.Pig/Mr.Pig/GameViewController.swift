//
//  ViewController.swift
//  Mr.Pig
//
//  Created by Artem Sherbachuk (UKRAINE) on 11/10/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import UIKit
import SceneKit

final class GameViewController: UIViewController {
    
    @IBOutlet weak var gameView: SCNView!
    var scene: Scene!
    var gameCore: GameCore!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScenes()
        setupSounds()
        gameCore = GameCore()
        gameCore.state = .tapToPlay
    }
    
    func setupScenes() {
        gameView.backgroundColor = .yellow
        scene = Scene(view:gameView)
    }
    func setupSounds() {
    }
    
    //MARK: - Game State
    //---------------------------------------------------------------------------------//
    
    func startGame() {
        gameCore.state = .playing
        setupSounds()
        scene.startGame()
    }
    
    func stopGame() {
        gameCore.state = .gameOver
        scene.gameOver()
    }
    
    func introStart() {
        gameCore.state = .tapToPlay
        setupSounds()
        scene.introStart()
    }
    
    
    //MARK: - Touches
    //---------------------------------------------------------------------------------//
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameCore.isTapToPlayState() {
            startGame()
        }
    }

    
    
    //MARK: - View Controller behavior
    //---------------------------------------------------------------------------------//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

