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

final class GameCore {
    
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
    
    init() {
        state = .tapToPlay
        coins.banked = 0
        coins.collected = 0
    }
    
    func isTapToPlayState() -> Bool {
        return state == .tapToPlay
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
