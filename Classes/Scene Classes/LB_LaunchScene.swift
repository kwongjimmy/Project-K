//
//  LB_LaunchScene.swift
//  Project K
//
//  Created by Jimmy Kwong on 1/17/17.
//  Copyright © 2017 Jimmy Kwong. All rights reserved.
//

import SpriteKit

/// The introduction scene before entering to the main scene
class LB_LaunchScene: SKScene {
    
    var titleLabel = SKLabelNode()
    var startLabel = SKLabelNode()
    var facebookButton = SKLabelNode()
    var settingsButton = SKLabelNode()
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    //When user touches the screen - once
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = atPoint(touch.location(in: self))
            if location.name == "Start" {
                let battleScene = LB_LevelSelectScene(fileNamed: "LB_LevelScene")
//                let battleScene = LB_Level_1(fileNamed: "LB_BattleScene")
                battleScene?.scaleMode = .aspectFit
                self.view?.presentScene(battleScene)
            }
        }
    }
    
    //When user release their fingers - once
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //When user move their fingers on the screen - more than one time
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func initialize() {
        createLabels()
//        createButtons()
    }
    
    /// Creates the required labels for the scene
    func createLabels() {
        titleLabel = SKLabelNode(fontNamed: "Helvetica Neue Light")
        titleLabel.fontSize = 128
        titleLabel.color = UIColor.black
        titleLabel.position = CGPoint(x: 0, y: 200)
        titleLabel.text = "Project K"
        titleLabel.zPosition = 1
        self.addChild(titleLabel)
        
//        startLabel = SKLabelNode(fontNamed: "Helvetica Neue Light")
//        startLabel.fontSize = 64
//        startLabel.color = UIColor.black
//        startLabel.position = CGPoint(x: 0, y: -(frame.size.height / 6))
//        startLabel.horizontalAlignmentMode = .center
//        startLabel.verticalAlignmentMode = .baseline
//        startLabel.text = "Start"
//        startLabel.zPosition = 1
//        startLabel.name = "Start"
//        self.addChild(startLabel)
        
    }
    
    /// Creates the required buttons for the scene
    func createButtons() {
        facebookButton = SKLabelNode(fontNamed: "Helvetica Neue Light")
        facebookButton.fontSize = 30
        facebookButton.color = UIColor.black
        facebookButton.position = CGPoint(x: -150, y: -450)
        facebookButton.text = "Facebook"
        facebookButton.zPosition = 1
        facebookButton.name = "Facebook"
        self.addChild(facebookButton)
        
        settingsButton = SKLabelNode(fontNamed: "Helvetica Neue Light")
        settingsButton.fontSize = 30
        settingsButton.color = UIColor.black
        settingsButton.position = CGPoint(x: 150, y: -450)
        settingsButton.text = "Settings"
        settingsButton.zPosition = 1
        settingsButton.name = "Settings"
        self.addChild(settingsButton)
    }
        
}
