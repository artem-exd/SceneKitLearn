//
//  GameView.swift
//  MarbleMaze
//
//  Created by Artem Sherbachuk (UKRAINE) on 11/7/16.
//  Copyright © 2016 ArtemSherbachuk. All rights reserved.
//

import SceneKit

final class GameView: SCNView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.allowsCameraControl = true
        self.showsStatistics = true
    }
    
    func setupNodes() {
        
    }

}
