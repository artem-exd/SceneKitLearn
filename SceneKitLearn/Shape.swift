//
//  ShapeType.swift
//  SceneKitLearn
//
//  Created by Artem Sherbachuk (UKRAINE) on 9/29/16.
//  Copyright © 2016 FSStudio. All rights reserved.
//

import SceneKit

public enum ShapeType: Int {
    case box = 0
    case sphere
    case pyramid
    case torus
    case capsule
    case cylinder
    case cone
    case tube
    
    static func random() -> ShapeType {
        let maxValue = tube.rawValue
        let rand = arc4random_uniform(UInt32(maxValue+1))
        return ShapeType(rawValue: Int(rand))!
    }
}

open class RundomShapeNodeGenerator {
    
    func  rundom() -> SCNNode {
        var geometry:SCNGeometry
        // 2
        switch ShapeType.random() {
        case .box:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        case .sphere:
            geometry = SCNSphere(radius: 0.5)
        case .pyramid:
            geometry = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        case .torus:
            geometry = SCNTorus(ringRadius: 0.5, pipeRadius: 0.25)
        case .capsule:
            geometry = SCNCapsule(capRadius: 0.3, height: 2.5)
        case .cylinder:
            geometry = SCNCylinder(radius: 0.3, height: 2.5)
        case .cone:
            geometry = SCNCone(topRadius: 0.25, bottomRadius: 0.5, height: 1.0)
        case .tube:
            geometry = SCNTube(innerRadius: 0.25, outerRadius: 0.5, height: 1.0)
        }
        
        //fill shape
        let rundomColor = UIColor.random()
        geometry.materials.first?.diffuse.contents = rundomColor
        
        
        let geometryNode = SCNNode(geometry: geometry)
        
        //add effects on shape node
        let emmiter = createParticleEffect(color: rundomColor, geometry: geometry)
        geometryNode.addParticleSystem(emmiter)
        
        //add phisics on shape node
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        let randomX = Float.random(min: -2, max: 2)
        let randomY = Float.random(min: 10, max: 18)
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        
        
        //add id to shape node
        if rundomColor == UIColor.black {
            geometryNode.name = "BAD"
        } else {
            geometryNode.name = "GOOD"
        }
        
        return geometryNode
    }
    
    fileprivate func createParticleEffect(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        let particle = SCNParticleSystem(named: "Trail", inDirectory: nil)!
        particle.particleColor = color
        particle.emitterShape = geometry
        return particle
    }
}
