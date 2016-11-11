//
//  GameCore.swift
//  Mr.Pig
//
//  Created by Artem Sherbachuk (UKRAINE) on 11/10/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import SceneKit

enum GameState {
    case playing
    case tapToPlay
    case gameOver
}

typealias Coins = (banked: Int, collected: Int)

let BitMaskPig = 1
let BitMaskVehicle = 2
let BitMaskObstacle = 4
let BitMaskPigFront = 8
let BitMaskPigBack = 16
let BitMaskPigLeft = 32
let BitMaskPigRight = 64
let BitMaskCoin = 128
let BitMaskHouse = 256

final class GameCore: NSObject {
    
    var state: GameState {
        didSet {
            switch state {
            case .gameOver:
                reset()
            default:
                break
            }
        }
    }
    var coins: Coins
    
    override init() {
        state = .tapToPlay
        coins.banked = 0
        coins.collected = 0
        super.init()
    }
    
    func isTapToPlayState() -> Bool {
        return state == .tapToPlay
    }
    
    func isPlayingState() -> Bool {
        return state == .playing
    }
    
    func collectCoin() {
        coins.collected += 1
    }
    
    func bankCoins() -> Bool {
        coins.banked += coins.collected
        
        if coins.collected > 0 {
            coins.collected = 0
            return true
        }
        
        return false
    }
    
    func reset() {
        coins.collected = 0
        coins.banked = 0
    }
}
