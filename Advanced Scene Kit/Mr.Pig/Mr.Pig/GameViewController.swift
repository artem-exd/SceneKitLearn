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
        gameView.delegate = self
        gameView.backgroundColor = .yellow
        scene = Scene(view:gameView)
        scene.gameScene.physicsWorld.contactDelegate = self
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
        gameCore.state = .tapToPlay
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


extension GameViewController: SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    //MARK: - SCNSceneRendererDelegate
    //---------------------------------------------------------------------------------//
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if gameCore.isPlayingState() {
            scene.redraw()
            scene.statusBar.update(coinsBanked: gameCore.coins.banked, coinsCollected: gameCore.coins.collected)
        }
    }
    
    
    //MARK: - SCNPhysicsContactDelegate
    //---------------------------------------------------------------------------------//
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if isCoinContated(contact: contact) {
            gameCore.collectCoin()
            scene.coinContactActionFrom(contact: contact)
        }
        
        if isVehicleContacted(contact: contact) {
            stopGame()
        }
        
        if isObstacleContacted(contact: contact) {
            scene.mainCharacter.stopMovingInDirectionOfContact(contact: contact)
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        if isObstacleContacted(contact: contact) {
            scene.mainCharacter.unstopMovingInDirectionOfContact(contact: contact)
        }
    }
    
    private func isCoinContated(contact: SCNPhysicsContact) -> Bool {
        return (contact.nodeA.physicsBody!.categoryBitMask == BitMaskCoin) || (contact.nodeB.physicsBody!.categoryBitMask == BitMaskCoin)
    }
    
    private func isVehicleContacted(contact: SCNPhysicsContact) -> Bool {
        return (contact.nodeA.physicsBody!.categoryBitMask == BitMaskVehicle) || (contact.nodeB.physicsBody!.categoryBitMask == BitMaskVehicle)
    }
    
    private func isObstacleContacted(contact: SCNPhysicsContact) -> Bool {
        return (contact.nodeA.physicsBody!.categoryBitMask == BitMaskObstacle) || (contact.nodeB.physicsBody!.categoryBitMask == BitMaskObstacle)
    }
}

