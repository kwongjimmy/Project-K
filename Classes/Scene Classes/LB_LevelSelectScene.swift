//
//  LB_LevelSelectScene.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 5/9/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

/// The introduction scene before entering to the main scene
class LB_LevelSelectScene: SKScene {
    
    let uiAtlas = SKTextureAtlas.init(named: "ui")
    override func didMove(to view: SKView) {
        createButtons()
    }
    
    //When user touches the screen - once
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = atPoint(touch.location(in: self))
            if location.name == "back" {
                let launchScene = LB_LaunchScene(fileNamed: "LB_LaunchScene")
                launchScene?.scaleMode = .aspectFill
                self.view?.presentScene(launchScene)
            }
            for i in 0...10 {
                if location.name == "level_\(i)" {
                    launchLevel(level: i)
                }
            }
        }
    }
    
    //When user release their fingers - once
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    //When user move their fingers on the screen - more than one time
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    private func launchLevel(level: Int) {
        var battleScene: SKScene?
        if level == 1 {
            battleScene = LB_Level_1(fileNamed: "LB_BattleScene")
        } else if level == 2 {
            battleScene = LB_Level_2(fileNamed: "LB_BattleScene")
        } else if level == 3{
            battleScene = LB_Level_3(fileNamed: "LB_BattleScene")
        } else if level == 4 {
            battleScene = LB_Level_4(fileNamed: "LB_BattleScene")
        } else if level == 5 {
            battleScene = LB_Level_5(fileNamed: "LB_BattleScene")
        } else if level == 6 {
            battleScene = LB_Level_6(fileNamed: "LB_BattleScene")
        } else if level == 7 {
            battleScene = LB_Level_7(fileNamed: "LB_BattleScene")
        } else if level == 8 {
            battleScene = LB_Level_8(fileNamed: "LB_BattleScene")
        } else if level == 9 {
            battleScene = LB_Level_9(fileNamed: "LB_BattleScene")
        } else if level == 10 {
            battleScene = LB_Level_10(fileNamed: "LB_BattleScene")
        } else {
            return
        }
        battleScene?.scaleMode = .aspectFill
        self.view?.presentScene(battleScene)
    }
    
    private func createButtons() {
        var level = 1
        for i in 1...3 {
            for j in 1...4 {
                if level > 10 {
                    return
                }
                let panel = SKSpriteNode(texture:uiAtlas.textureNamed("grey_button13"))
                panel.size = CGSize(width: 100, height: 100)
                panel.position = CGPoint(x: -(self.frame.width / 2.0) + CGFloat(150.0 * Double(j)), y: CGFloat(self.frame.height / 2.0 - CGFloat(175 * i)) - 100)
                panel.zPosition = 0
                panel.name = "level_\(level)"
                
                let levelText = SKLabelNode(fontNamed: "Helvetica Neue Light")
                levelText.fontSize = 24
                levelText.position = CGPoint(x: 0, y: 0)
                levelText.fontColor = UIColor.darkGray
                levelText.text = "L-\(level)"
                levelText.zPosition = 1
                levelText.name = panel.name
                level += 1
                panel.addChild(levelText)
                self.addChild(panel)
            }
        }
    }
    
}

