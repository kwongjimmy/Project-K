//
//  LB_BattleScene.swift
//  Project K
//
//  Created by Jimmy Kwong on 1/17/17.
//  Copyright © 2017 Jimmy Kwong. All rights reserved.
//

import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

/// The game scene where the gameplay happens.
class LB_BattleScene: SKScene, SKPhysicsContactDelegate {
    
    private var currentLevel: Int?
    
    private var gamePaused = false
    private var pauseMenu: SKSpriteNode?
    private var gameOverMenu: SKSpriteNode?
    private var victoryMenu: SKSpriteNode?
    private var waveText: SKLabelNode?
    
    private var playerNode: LB_PlayerNode?
    private var spellSlots: [LB_SpellSlotNode]?
    private var spellRing: LB_SpellRing?
    private var spellRingController: LB_SpellRingController?
    
    // Usedin the update() for update rate
    private var previousUpdateTimetoken : Double = 0.0
    private var previousUpdateTimetoken2 : Double = 0.0
    private var previousUpdateTimetoken3 : Double = 0.0
    
    // Useds for flick gesture detection
    private var firstTouchLocation: CGPoint = CGPoint(x: 0, y: 0)
    private var firstTouchTime: TimeInterval = 0
    private var moving: Bool = false
    private var minFlickDistance = CGFloat(10)
    private var minFlickSpeed = CGFloat(0.185)
    private var beginFlickDetect = false
    private var currentPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    // Managers
    private var battleManager: LB_BattleManager?
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    /// Battle scene initialization
    private func initialize() {
        self.physicsWorld.gravity = CGVector.zero
        self.physicsWorld.speed = 0.9999
        physicsWorld.contactDelegate = self
        
        let bg = SKSpriteNode(imageNamed: "background.png")
        bg.zPosition = -1
        self.addChild(bg)
        
        waveText = SKLabelNode(fontNamed: "Helvetica Neue Light")
        waveText?.name = "waveText"
        waveText?.position = CGPoint(x: 0, y: 625)
        waveText?.zPosition = 9
        waveText?.fontSize = 40
        self.addChild(waveText!)
        
        createManagers()
        getReferences()
        createSpellRing()
        createPauseMenu()
        createGameOverMenu()
        createVictoryMenu()
    }
    
    func setWave(wave: String) {
        waveText?.text = wave
    }
    
    /// Allow battle manager to get reference to player before game state begins.
    private func getReferences() {
        playerNode = battleManager?.getPlayerNode()
    }
    
    /// Create all the managers required.
    private func createManagers() {
        battleManager = LB_BattleManager(levelObjects: getLevelInfo(), battleScene: self)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA.node /// Collision Object
        let bodyB = contact.bodyB.node /// Collision Object
        
        let spell: LB_SpellNode?
        let being: SKSpriteNode?
        var collision: LB_Collision?

        /// Ignores spells that are colliding with each other
        if bodyA?.name == "spell" && bodyB?.name != "spell" {
        
            spell = bodyA as? LB_SpellNode
            being = bodyB as! SKSpriteNode?
            
        } else if bodyB?.name == "spell" && bodyA?.name != "spell" {
            
            spell = bodyB as? LB_SpellNode
            being = bodyA as! SKSpriteNode?
            
        } else {
            return
        }
        
        /// Ignores spells casted by the being hitting itself
        if being?.name == "enemy" && spell?.type == "player" {
            
            collision = LB_Collision(target: being as! LB_EnemyNode, spell: spell!)
            
        } else if being?.name == "player" && spell?.type == "enemy" {
            
            collision = LB_Collision(target: being as! LB_PlayerNode!, spell: spell!)
            
        } else {
            return
        }
        
        // Send batttle manager the collision information between being and spell
        battleManager?.calculateCollision(collision: collision!)
    }
    
    /// Create a level state for battlemanager
    ///
    /// - Returns: Dictionary containing enemy waves information.
    func getLevelInfo() -> LB_BattleManager.Level {
        // Add a player to beginning state
        let player = LB_Player(name: "Player", level: 1)
   
        return LB_BattleManager.Level(level: 0, player: player, enemyWaves: [[LB_Enemy]](), waves: 0)
    }
    
    /// Initializes the spell ring, then drawn into the scene
    func createSpellRing() {
        let playerSpells = playerNode?.getPlayer().getPlayerSpells()
        let slot1 = LB_SpellSlotNode(spell: (playerSpells?[0])!, name: (playerSpells?[0])!.name)
        let slot2 = LB_SpellSlotNode(spell: (playerSpells?[1])!, name: (playerSpells?[1])!.name)
        let slot3 = LB_SpellSlotNode(spell: (playerSpells?[2])!, name: (playerSpells?[2])!.name)
        let slot4 = LB_SpellSlotNode(spell: (playerSpells?[3])!, name: (playerSpells?[3])!.name)
        slot1.name = "spell_1"
        slot2.name = "spell_2"
        slot3.name = "spell_3"
        slot4.name = "spell_4"
        
        spellSlots = [slot1,slot2,slot3,slot4]
        spellRing = LB_SpellRing(slotArray: spellSlots!, battleManager: battleManager!)
        spellRingController = LB_SpellRingController(spellRing: spellRing!)
        spellRingController?.updateSpellRingLocation(newLocation: (playerNode?.position)!)
        playerNode?.setSpellRingController(controller: spellRingController!)
        self.addChild(spellRing!)
    }
    
    private func createPauseMenu() {
        pauseMenu = SKSpriteNode(color: SKColor.black, size: CGSize(width: frame.width, height: frame.height))
        pauseMenu?.alpha = 0.9
        pauseMenu?.zPosition = 10
        
        let playButton = SKSpriteNode(imageNamed: "play-button")
        playButton.size = CGSize(width: 125, height: 125)
        playButton.name = "resume"
        playButton.position = CGPoint(x: -125, y: 0)
        playButton.zPosition = 11
        pauseMenu?.addChild(playButton)
        
        let homeButton = SKSpriteNode(imageNamed: "home-button")
        homeButton.size = CGSize(width: 100, height: 100)
        homeButton.name = "home"
        homeButton.position = CGPoint(x: 125, y: 0)
        homeButton.zPosition = 11
        pauseMenu?.addChild(homeButton)
        
        let pauseText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
        pauseText.text = "PAUSED"
        pauseText.fontSize = 81
        pauseText.zPosition = 11
        pauseText.position = CGPoint(x: 0, y: frame.height / 4.0)
        pauseMenu?.addChild(pauseText)
    }
    
    private func createGameOverMenu() {
        gameOverMenu = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height: frame.height))
        gameOverMenu?.zPosition = 10
        gameOverMenu?.alpha = 0.0
        
        let restartButton = SKSpriteNode(imageNamed: "restart-button")
        restartButton.size = CGSize(width: 125, height: 125)
        restartButton.name = "restart"
        restartButton.position = CGPoint(x: -125, y: 0)
        restartButton.zPosition = 11
        gameOverMenu?.addChild(restartButton)
        
        let homeButton = SKSpriteNode(imageNamed: "home-button")
        homeButton.size = CGSize(width: 100, height: 100)
        homeButton.name = "home"
        homeButton.position = CGPoint(x: 125, y: 0)
        homeButton.zPosition = 11
        gameOverMenu?.addChild(homeButton)
        
        let gameOverText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
        gameOverText.text = "GAME OVER"
        gameOverText.fontSize = 81
        gameOverText.zPosition = 11
        gameOverText.position = CGPoint(x: 0, y: frame.height / 4.0)
        gameOverMenu?.addChild(gameOverText)
    }
    
    private func createVictoryMenu() {
        victoryMenu = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height: frame.height))
        victoryMenu?.zPosition = 10
        victoryMenu?.alpha = 0.0
        
        let nextButton = SKSpriteNode(imageNamed: "next-button")
        nextButton.size = CGSize(width: 125, height: 125)
        nextButton.name = "next"
        nextButton.position = CGPoint(x: -125, y: 0)
        nextButton.zPosition = 11
        victoryMenu?.addChild(nextButton)
        
        let homeButton = SKSpriteNode(imageNamed: "home-button")
        homeButton.size = CGSize(width: 100, height: 100)
        homeButton.name = "home"
        homeButton.position = CGPoint(x: 125, y: 0)
        homeButton.zPosition = 11
        victoryMenu?.addChild(homeButton)
        
        let victoryText = SKLabelNode(fontNamed: "Helvetica Neue UltraLight")
        victoryText.text = "VICTORY"
        victoryText.fontSize = 81
        victoryText.zPosition = 11
        victoryText.position = CGPoint(x: 0, y: frame.height / 4.0)
        victoryMenu?.addChild(victoryText)
    }
    
    func gameOver() {
        gamePaused = true
        gameOverMenu?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.9, duration: 0.75), SKAction.run {
            for node in self.children {
                node.isPaused = true
            }
            }]))
        self.addChild(gameOverMenu!)
    }
    
    func victory() {
        gamePaused = true
        victoryMenu?.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.9, duration: 0.75), SKAction.run {
            for node in self.children {
                node.isPaused = true
            }
            }]))
        self.addChild(victoryMenu!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        firstTouchLocation = (touches.first?.location(in: self))!
        /// Checking if it is touching a spell slot node, if it does then rotate to that spell
        if !gamePaused {
            
            for i in 0...(spellRingController?.getSpellSlotArraySize())! - 1{
                if atPoint(firstTouchLocation).name == "spell_\(i+1)" {
                    spellRingController?.rotate(spellNumber: i)
                    break
                }
            }
            
            if atPoint(firstTouchLocation).name == "pause" {
                gamePaused = true
                self.addChild(pauseMenu!)
                for node in self.children {
                    node.isPaused = true
                }
                return
            }
            
            /// Setting touch times for flick speed calculation
            firstTouchTime = (touches.first?.timestamp)!
            if (playerNode?.isCasting())! {
                playerNode?.cancelCasting()
            }
            
        } else {
            let button = atPoint(firstTouchLocation).name
            if button == "resume" {
                gamePaused = false
                pauseMenu?.removeFromParent()
                for node in self.children {
                    node.isPaused = false
                }
                return
            } else if button == "home" {
                let launchScene = LB_LaunchScene(fileNamed: "LB_LaunchScene")
                launchScene?.scaleMode = .aspectFit
                self.view?.presentScene(launchScene)
            } else if button == "restart" {
                let gameScene = LevelManager.init().getLevel(level: (battleManager?.getLevel())!)
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene)
            } else if button == "next"{
                let gameScene = LevelManager.init().getLevel(level: (battleManager?.getLevel())!+1)
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene)
            } else {
                return
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gamePaused {
            super.touchesMoved(touches, with: event)
            moving = true
            for touch in touches {
                // grabs the touch from the finger touched location
                let touchedLocation = touch.location(in: self)
                currentPoint = touchedLocation
                // Conditions where if the player touched the spell ring or withing the boundaries, should begin the detection for flick gesture.
                if atPoint(touchedLocation).name == "spell_1" || atPoint(touchedLocation).name == "spell_2" || atPoint(touchedLocation).name == "spell_3" || atPoint(touchedLocation).name == "spell_4" {
                    beginFlickDetect = true
                } /*else { */
                else if (touchedLocation.y < 0 && touchedLocation.y > -535) /*&& (touchedLocation.x > -250 && touchedLocation.x < 250)*/ {
                    beginFlickDetect = true
                    spellRingController?.updateSpellRingLocation(newLocation: touchedLocation)
                }
//                }
            }
        } else {
            return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /// Check if primary spell is on cooldown before checking for flick gesture.
        //https://stackoverflow.com/questions/26551777/sprite-kit-determine-vector-of-swipe-gesture-to-flick-sprite/26553288
        if !(spellRingController?.getSpellSlotStatus())! && beginFlickDetect && !(playerNode?.isCasting())! && !gamePaused {
            
            moving = false // Prevent player from moving
            let lastTouchPosition = touches.first?.location(in: self)
            let lastTouchTime = touches.first?.timestamp
            let dx = CGFloat((lastTouchPosition?.x)! - firstTouchLocation.x)
            let dy = CGFloat((lastTouchPosition?.y)! - firstTouchLocation.y)
            let magnitude = CGFloat(sqrt(dx*dx+dy*dy))
//            print("magnitude: \(magnitude)")
            
            print(magnitude)
            if magnitude >= minFlickDistance {
                
                let dt = lastTouchTime! - firstTouchTime
                let speed = CGFloat(dt)
                print(speed)
                if speed < minFlickSpeed {
                    
                    let offset = lastTouchPosition! - firstTouchLocation
        
                    /// Prevent user from shooting it backwards
//                    if (offset.y < 100) {
//                        print(offset.y)
//                        return }
                    
                    /// Calculate the direction the spell circle to moving towards to.
                    let destination = offset.normalized() * 1250 + lastTouchPosition!
                    
                    /// Create a primary spell node (Player casting a spell)
                    playerNode?.beginCastingSpell(spell: (spellRingController?.getCurrentSpell())!, spellLocation: destination)
                    spellRingController?.moveSpellRingToPlayer(playerPosition: (playerNode?.position)!)
                }
            }
        } else {
            beginFlickDetect = false /// Reset detecting gesture.
            return
        }

    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Allow battle manager to check for spells from out of frame
        if previousUpdateTimetoken3 + 3 < currentTime {
            previousUpdateTimetoken3 = currentTime
            battleManager?.checkSpellOutOfBounds()
        }
        
        //Updating firstTouchLocation for usage for checking flick gesture
        if previousUpdateTimetoken2 + 0.125 < currentTime && moving {
            previousUpdateTimetoken2 = currentTime
            firstTouchTime = currentTime
            firstTouchLocation = (spellRing!.position)

            if currentPoint.y > 0 {
                // Player should not be able to flick when doing the gesture on the top half of the screen.
                beginFlickDetect = false
            }
        }
        
        if previousUpdateTimetoken + 0.1 < currentTime {
            previousUpdateTimetoken = currentTime
            playerNode?.move(to: (spellRing!.position))
        }
    }
}
