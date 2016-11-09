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
    private var gameScene: GameScene!
    private var gameCore: GameCore!
    private let motion = CoreMotionHelper()
    private var motionForce = SCNVector3(x:0, y: 0, z: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        gameScene.resetGame()
    }
    private func setupScene() {
        gameScene = GameScene(view: gameView)
        gameCore = GameCore()
        gameCore.delegate = self
        gameView.delegate = gameCore
        gameScene.scene.physicsWorld.contactDelegate = gameCore
    }
    
    //MARK: - Game Controlling
    //---------------------------------------------------------------------------------//
    
    func play() {
        gameScene.playGame()
        gameView.isPlaying = true
        gameCore.state = GameStateType.playing
    }
    func reset() {
        gameScene.resetGame()
        gameCore.state = GameStateType.tapToPlay
    }
    func testForGameOver() {
        if gameScene.isBallOut() {
            gameCore.state = GameStateType.gameOver
            GameHelper.sharedInstance.playSound(gameScene.ballNode, name: "GameOver")
            gameScene.ballNode.runAction(SCNAction.waitForDurationThenRunBlock(5)
            { (node:SCNNode!) -> Void in
                self.reset()
            })
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameCore.state == GameStateType.tapToPlay {
            play()
        }
    }
    
    fileprivate func updateMotionControll() {
        if gameCore.state == GameStateType.playing {
            motion.getAccelerometerData(0.1) { [weak self] x, y, z in
                guard let s = self else {return}
                let vector = SCNVector3Make(x * 0.05, 0, (y+0.8) * -0.05)
                s.motionForce = vector
            }
            gameScene.ballNode.physicsBody!.velocity += motionForce
        }
    }
    
    fileprivate func updateCamreAndLight() {
        gameScene.updateCameraAndLight(forState: gameCore.state)
    }
}

extension GameViewController: GameCoreDelegate {
    func updateRenderAt(time: TimeInterval) {
        updateMotionControll()
        updateCamreAndLight()
    }
}
