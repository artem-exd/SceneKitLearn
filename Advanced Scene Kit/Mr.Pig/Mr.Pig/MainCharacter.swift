//
//  MainCharacter.swift
//  Mr.Pig
//
//  Created by Artem Sherbachuk (UKRAINE) artemsherbachuk@gmail.com on 11/10/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import SceneKit

final class MainCharacter: NSObject {
    
    private(set) var rootNode: SCNNode!
    
    private(set) var jumpLeftAction: SCNAction!
    private(set) var jumRightAction: SCNAction!
    private(set) var jumpForwardAction: SCNAction!
    private(set) var jumpBackwardAction: SCNAction!
    private(set) var dieAction: SCNAction!
    private let actionDuration = 0.2
    
    typealias DieCompletion = () -> Void
    
    
    private(set) var collision: SCNNode!
    private(set) var leftCollision: SCNNode!
    private(set) var rightCollision: SCNNode!
    private(set) var frontCollision: SCNNode!
    private(set) var backCollison: SCNNode!
    
    private(set) var isHaveLeftObstacle = false
    private(set) var isHaveRightObstacle = false
    private(set) var isHaveFrontObstacle = false
    private(set) var isHaveBackObstacle = false
    
    
    init(characterNode: SCNNode, collisionNode: SCNNode) {
        super.init()
        rootNode = characterNode
        setupMoveActions()
        setupDieActions()
        setupCollision(rootCollision: collisionNode)
    }
    private func setupMoveActions() {
        let bounceUp = SCNAction.moveBy(x: 0, y: 1.0, z: 0, duration: actionDuration*0.5)
        bounceUp.timingMode = .easeOut
        let bounceDown = SCNAction.moveBy(x: 0, y: -1.0, z: 0, duration: actionDuration*0.5)
        bounceDown.timingMode = .easeIn
        let bounceActions = SCNAction.sequence([bounceUp, bounceDown])
        
        let moveLeft = SCNAction.moveBy(x: -1.0, y: 0, z: 0, duration: actionDuration)
        let moveRight = SCNAction.moveBy(x: 1.0, y: 0, z: 0, duration: actionDuration)
        let moveForward = SCNAction.moveBy(x: 0, y: 0, z: -1.0, duration: actionDuration)
        let moveBackward = SCNAction.moveBy(x: 0, y: 0, z: 1.0, duration: actionDuration)
        
        let turnLeft = SCNAction.rotateTo(x: 0, y: convertToRadians(-90), z: 0, duration: actionDuration, usesShortestUnitArc: true)
        let turnRight = SCNAction.rotateTo(x: 0, y: convertToRadians(90), z: 0, duration: actionDuration, usesShortestUnitArc: true)
        let turnForward = SCNAction.rotateTo(x: 0, y: convertToRadians(180), z: 0, duration: actionDuration, usesShortestUnitArc: true)
        let turnBackward = SCNAction.rotateTo(x: 0, y: convertToRadians(360), z: 0, duration: actionDuration, usesShortestUnitArc: true)
        
        jumpLeftAction = SCNAction.group([turnLeft, bounceActions, moveLeft])
        jumRightAction = SCNAction.group([turnRight, bounceActions, moveRight])
        jumpForwardAction = SCNAction.group([turnForward, bounceActions, moveForward])
        jumpBackwardAction = SCNAction.group([turnBackward, bounceActions, moveBackward])
    }
    private func setupDieActions() {
        let spinAround = SCNAction.rotateBy(x: 0, y: convertToRadians(720), z: 0, duration: actionDuration)
        let riseUp = SCNAction.moveBy(x: 0, y: 10, z: 0, duration: 2)
        let fadeOut = SCNAction.fadeOpacity(to: 0, duration: 2)
        dieAction = SCNAction.group([spinAround, riseUp, fadeOut])
    }
    private func setupCollision(rootCollision: SCNNode) {
        collision = rootCollision
        leftCollision = collision.childNode(withName: "Left", recursively: true)!
        rightCollision = collision.childNode(withName: "Right", recursively: true)!
        frontCollision = collision.childNode(withName: "Front", recursively: true)!
        backCollison = collision.childNode(withName: "Back", recursively: true)!
        
        rootNode.physicsBody?.contactTestBitMask = BitMaskCoin | BitMaskVehicle | BitMaskHouse
        leftCollision.physicsBody?.contactTestBitMask = BitMaskObstacle
        rightCollision.physicsBody?.contactTestBitMask = BitMaskObstacle
        frontCollision.physicsBody?.contactTestBitMask = BitMaskObstacle
        backCollison.physicsBody?.contactTestBitMask = BitMaskObstacle
    }
    
    
    func die(completion: @escaping DieCompletion) {
        rootNode.runAction(dieAction, completionHandler: completion)
    }
    
    func placeInStartPosition() {
        rootNode.position = SCNVector3Zero
        rootNode.opacity = 1
    }
    
    
    func setViewForGestureRecognizers(view: SCNView) {
        func addGesture(direction: UISwipeGestureRecognizerDirection) {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(hanldeGesture(gesture:)))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
        }
        addGesture(direction: .left)
        addGesture(direction: .right)
        addGesture(direction: .up)
        addGesture(direction: .down)
    }
    
    func updatePosition() {
        collision.position = rootNode.presentation.position
    }
    
    func stopMovingInDirectionOfContact(contact: SCNPhysicsContact) {
        func obstacle(mask: Int) -> Bool {
            return (contact.nodeA.physicsBody?.categoryBitMask == mask) || (contact.nodeB.physicsBody?.categoryBitMask == mask)
        }
        isHaveLeftObstacle = obstacle(mask: BitMaskPigLeft)
        isHaveRightObstacle = obstacle(mask: BitMaskPigRight)
        isHaveFrontObstacle = obstacle(mask: BitMaskPigFront)
        isHaveBackObstacle = obstacle(mask: BitMaskPigBack)
    }
    
    func unstopMovingInDirectionOfContact(contact: SCNPhysicsContact) {
        isHaveLeftObstacle = false
        isHaveRightObstacle = false
        isHaveFrontObstacle = false
        isHaveBackObstacle = false
    }
    
    
    
    @objc private func hanldeGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            if !isHaveLeftObstacle {
                rootNode.runAction(jumpLeftAction)
            }
        case UISwipeGestureRecognizerDirection.right:
            if !isHaveRightObstacle {
                rootNode.runAction(jumRightAction)
            }
        case UISwipeGestureRecognizerDirection.up:
            if !isHaveFrontObstacle {
                rootNode.runAction(jumpForwardAction)
            }
        case UISwipeGestureRecognizerDirection.down:
            if !isHaveBackObstacle {
                rootNode.runAction(jumpBackwardAction)
            }
        default:
            break
        }
    }
}
