//
//  Scene.swift
//  SpriteDemo
//
//  Created by Dov Rosenberg on 9/2/17.
//  Copyright © 2017 Dov Rosenberg. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    let spriteLabel = SKLabelNode(text: "Prizes")
    let numberOfPrizesLabel = SKLabelNode(text: "0")
    var creationTime : TimeInterval = 0
    var prizeCount = 0 {
        didSet {
            self.numberOfPrizesLabel.text = "\(prizeCount)"
        }
    }
    
    let killSound = SKAction.playSoundFileNamed("Fog_Horn", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        spriteLabel.fontSize = 20
        spriteLabel.fontName = "DevanagariSangamMN-Bold"
        spriteLabel.color = .white
        spriteLabel.position = CGPoint(x: 40, y: 50)
        addChild(spriteLabel)
        
        numberOfPrizesLabel.fontSize = 30
        numberOfPrizesLabel.fontName = "DevanagariSangamMN-Bold"
        numberOfPrizesLabel.color = .white
        numberOfPrizesLabel.position = CGPoint(x: 40, y: 10)
        addChild(numberOfPrizesLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if currentTime > creationTime {
            createAnchor()
            creationTime = currentTime + TimeInterval(randomFloat(min: 3.0, max: 6.0))
        }
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    func createAnchor(){
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        let _360degrees = 2.0 * Float.pi
        
        let rotateX = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 1, 0, 0))
        
        let rotateY = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 0, 1, 0))
        
        let rotation = simd_mul(rotateX, rotateY)
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -2 - randomFloat(min: 0.0, max: 1.0)

        let transform = simd_mul(rotation, translation)
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
        prizeCount += 1
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let hit = nodes(at: location)
        if let node = hit.first {
            if node.name == "prize" {
                let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                let remove = SKAction.removeFromParent()
                
                // Group the fade out and sound actions
                let groupKillingActions = SKAction.group([fadeOut, killSound])
                // Create an action sequence
                let sequenceAction = SKAction.sequence([groupKillingActions, remove])
                
                // Execute the actions
                node.run(sequenceAction)
                
                // TODO store a reference to the item clicked on
                
                // Update the counter
                prizeCount -= 1
            }
        }
    }
}
