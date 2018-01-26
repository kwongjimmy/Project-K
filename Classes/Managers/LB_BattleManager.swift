//
//  LB_BattleManager.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 3/19/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

struct ColliderType {
    
    static let Player: UInt32 = 1
    static let Enemy: UInt32 = 2
    static let Spell: UInt32 = 3
    
}

class LB_BattleManager {
    
    let outofbounds: [String: Int] = ["X1": 650, "X2": -650, "Y1": 650, "Y2": -650]
    private var oobState = true
    
    private var arrayOfEnemies: [LB_EnemyNode]? // Holds the current Enemies in the battle scene.
    private var arrayOfSpellsOnScreen: [LB_SpellNode]? // Holds the current Spells in the battle scene.
    private var battleStateMap: LB_BattleStateMachine.BattleStateMap?
    private var battleStateMachine: LB_BattleStateMachine?
    private var playerNode: LB_PlayerNode?
    private var level: Level //Contains current level objects (player + enemy waves)
    private var battleScene: LB_BattleScene?
    
    private var waveCounter: Int?
    
    struct Level {
        var level: Int
        var player: LB_Player
        var enemyWaves: [[LB_Enemy]]
        var waves: Int
    }
    
    init(levelObjects: Level, battleScene: LB_BattleScene) {
        arrayOfEnemies = [LB_EnemyNode]()
        arrayOfSpellsOnScreen = [LB_SpellNode]()
        waveCounter = 0
        self.level = levelObjects
        self.battleScene = battleScene
        
        // Initialize state machine
        battleStateMachine = LB_BattleStateMachine(battleManager: self)
        
        if (battleStateMachine?.initializeState())! {
            spawnPlayer()
            spawnEnemies()
            battleScene.setWave(wave: "Wave: \(waveCounter!+1)/\(levelObjects.waves)")
        }
    }
    
    /// Updates the current battle state
    public func updateState(updatedState: LB_BattleStateMachine.BattleStateMap) {
        battleStateMap = updatedState
    }
    
    /// Request an stateupdate from the battlestatemachine
    public func requestState() {
        if (battleStateMachine?.getUpdateStatus())! {
            
            // When BSM has finish updating it will allow BattleManager to get a updated state
            battleStateMap = battleStateMachine?.getState()
        }
    }
    
    /// Spawn the player node onto the battle scene.
    private func spawnPlayer() {
        let player = LB_PlayerNode(player: level.player)
        if (battleStateMachine?.register(object: player))! {
            playerNode = player
            playerNode?.setBattleManager(battleManager: self)
//            playerNode?.drawHealthBar()
            playerNode?.beginUpdatingStatusAilment()
            battleScene?.addChild(playerNode!)
        }
    }
    
    /// Spawns enemies by registering with BSM and will only add to array if it is sucessful.
    private func spawnEnemies() {
        let enemies = level.enemyWaves
        if enemies.count > 0 {
            for i in 0...enemies[waveCounter!].count-1 {
                let enemy = enemies[waveCounter!][i]
                let enemyNode = LB_EnemyNode(enemy: enemy)
                if (battleStateMachine?.register(object: enemyNode))! {
                    enemyNode.setBattleManager(battleManager: self)
                    arrayOfEnemies?.append(enemyNode)
                    enemyNode.position = enemy.position
                    enemyNode.drawHealthBar()
                    enemyNode.beginUpdatingStatusAilment()
                    battleScene?.addChild(enemyNode)
                }
            }
            enemyBeginAttack()
        }
    }
    
    
    /// Used to check the current waves. If there are no waves, victory() occurs.
    public func checkWaves() {
        // -1 becasue waveCoutner begins at 0
        if arrayOfEnemies?.count == 0 {
            if waveCounter! < level.waves - 1 {
                waveCounter! += 1
                battleScene?.setWave(wave: "Wave: \(waveCounter!+1)/\(level.waves)")
                spawnEnemies()
            } else {
                victory()
            }
        }
    }
    
    /// Inform enemies to start casting spell towards the playerNode Position.
    private func enemyBeginAttack() {
        for i in 0...(arrayOfEnemies?.count)!-1 {
            arrayOfEnemies?[i].beginCastingSpell()
        }
    }
    
    /// Add spells to Battle manager's arrays and inform state machine for registration
    ///
    /// - Parameter spell: Spell node object
    /// - Returns: True if registration of spell node object is sucessful, else false.
    public func addSpell(spell: LB_SpellNode) -> Bool {
        if (battleStateMachine?.register(object: spell))! {
            arrayOfSpellsOnScreen?.append(spell)
            return true
        }
        return false
    }
    
    
    /// Used to get reference of the playerNode in the battle scene.
    ///
    /// - Parameter playerNode: The player node which contains the player's infomration.
    public func setPlayerNode(playerNode: LB_PlayerNode) {
        self.playerNode = playerNode
    }
    
    
    /// Gets the player node object.
    ///
    /// - Returns: Player node object
    public func getPlayerNode() -> LB_PlayerNode {
        return playerNode!
    }
    
    public func getPlayer() -> LB_Player {
        return playerNode!.getPlayer()
    }
    
    public func getLevel() -> Int {
        return level.level
    }
    
    /// Gets the player's position
    ///
    /// - Returns: The coordinates for the player
    public func getPlayerPosition() -> CGPoint {
        return (playerNode?.position)!
    }
    
    public func getRandomEnemyPos() -> CGPoint {
        let randomIndex = arc4random_uniform(UInt32(arrayOfEnemies!.count))
        let randomPos = arrayOfEnemies?[Int(randomIndex)].position
        return randomPos!
    }

    /// Check all the spells if they are out of the scene. If they are then, they are removed from the state.
    public func checkSpellOutOfBounds() {
        let spellArraySize = (arrayOfSpellsOnScreen?.count)!
        if spellArraySize > 0 && oobState {
            oobState = false
            for i in (0...spellArraySize-1).reversed() {
                if calculateOutOfBounds(spell: (arrayOfSpellsOnScreen?[i])!) {
                    if (battleStateMachine?.remove(object: (arrayOfSpellsOnScreen?[i])!))! {
                        arrayOfSpellsOnScreen?[i].removeFromParent()
                        arrayOfSpellsOnScreen?.remove(at: i)
                    }
                }
            }
            oobState = true
        }
    }
    
    /// Checks if the spell node is out of bounds from the battle scene frame.
    ///
    /// - Parameter spell: The spell node it is currently checking.
    /// - Returns: True if it is out of bounds, else false
    private func calculateOutOfBounds(spell: LB_SpellNode) -> Bool{
        let x = Int(spell.position.x)
        let y = Int(spell.position.y)
        return (x > outofbounds["X1"]! || x < outofbounds["X2"]! || y > outofbounds["Y1"]! || y < outofbounds["Y2"]!)
    }
    
    /// Processes the collision object information and proceeds to calculate the damage.
    ///
    /// - Parameter collision: Collision object containing spell and being collision references.
    public func calculateCollision(collision: LB_Collision) {
//        print(arrayOfSpellsOnScreen)
        var enemyIndex: Int?
        var spellIndex: Int?
        if collision.type == "enemy" {
//            print("enemy getting hit")
            for i in 0...(arrayOfEnemies?.count)!-1 {
                if collision.getCollisionTarget() == arrayOfEnemies?[i] {
                    enemyIndex = i
                    break
                }
            }
            for i in (0...(arrayOfSpellsOnScreen?.count)!-1).reversed() {
                if collision.getCollisionSpell() == arrayOfSpellsOnScreen?[i] {
                    spellIndex = i
                    break
                }
            }
            calculateDamage(enemyIndex: enemyIndex!, spellIndex: spellIndex!)
        } else if collision.type == "player" {
//            print("player getting hit")
            for i in (0...(arrayOfSpellsOnScreen?.count)!-1).reversed() {
                if collision.getCollisionSpell() == arrayOfSpellsOnScreen?[i] {
                    spellIndex = i
                    break
                }
            }
            calculateDamage(spellIndex: spellIndex!)
        }
    }
    
    /// Calculates the damage between enemy and spell
    ///
    /// - Parameters:
    ///   - enemyIndex: The current enemy index in the battle manager's arrayOfEnemies
    ///   - spellIndex: The current spell index in the battle manager's arrayOfSpellsOnScreen
    private func calculateDamage(enemyIndex: Int, spellIndex: Int) {
        let enemyNode = arrayOfEnemies?[enemyIndex]
        let enemy = enemyNode?.getEnemy()
        let spellNode = arrayOfSpellsOnScreen?[spellIndex]
        let spell = spellNode?.getSpell()
        
        // Calculate the damage
        enemyNode?.decrementHealth(damage: (spell?.damage)! * (1 - ((spellNode?.weakenedAmount)! / 10)))
        
        // If statemachine has sucessfully removed the spell for the state and enemy health is less than 0
        if (battleStateMachine?.remove(object: spellNode!))! && (enemy?.isAlive)! == false {
            // Remove enemy from state
            removeEnemy(enemyNode: enemyNode!, enemyIndex: enemyIndex)
        } else {
            if spell?.spellType != LB_Spell.SpellType.Damage {
                let actionEvent = LB_ActionEvent(spell: spell!, enemy: enemyNode!)
                battleStateMachine?.update(object: enemyNode!, actionEvent: actionEvent)
            }
        }
        
        //remove spell from scene after collision
        arrayOfSpellsOnScreen?[spellIndex].removeFromParent()
        //remove spell from battle manager's array of spells
        arrayOfSpellsOnScreen?.remove(at: spellIndex)
        
    }
    
    /// Caculates the damage between spell and player.
    ///
    /// - Parameter spellIndex: Index of spell in arrayOfSpellsOnScreen array
    private func calculateDamage(spellIndex: Int) {
        let spellNode = arrayOfSpellsOnScreen?[spellIndex]
        let spell = spellNode?.getSpell()

        /// Decrement player health first.
        playerNode?.decrementHealth(damage: (spell?.damage)! * (1 - ((spellNode?.weakenedAmount)! / 100)))
        
        /// After BSM removes the spell node after collision AND if player has ran out of live
        if (battleStateMachine?.remove(object: spellNode!))! && (playerNode?.getPlayer().isAlive)! == false {
            gameOver()
        } else {
            /// Player is alive create action event, and only if spell is not DMG/Default it will be updated.
            if spell?.spellType != LB_Spell.SpellType.Damage {
                print("Creating action event")
                let actionEvent = LB_ActionEvent(spell: spell!, player: playerNode!)
                battleStateMachine?.update(object: playerNode!, actionEvent: actionEvent)
            }
        }
        arrayOfSpellsOnScreen?[spellIndex].removeFromParent()
        arrayOfSpellsOnScreen?.remove(at: spellIndex)
    }
    
    /// Updates the ailment(debuff)
    ///
    /// - Parameters:
    ///   - ailment: ailment that it is updating
    ///   - ailmentIndex: the index it was in the players array
    public func updatePlayerAilmentStatus(ailment: LB_Ailment, ailmentIndex: Int) {
        
        /// It currently only applies DoT
        if ailment.onTick() == true {
            if ailment.getType() == LB_Spell.SpellType.DoT {
                playerNode?.decrementHealth(damage: ailment.getEffect().value)
                if playerNode?.getPlayer().isAlive == false {
                    gameOver()
                }
            }
        }
        
        /// If debuff timer reaches 0, remove it from player/state array
        if ailment.getStatus() == false {
            let actionEvent = LB_ActionEvent(ailment: ailment, player: playerNode!)
            if actionEvent.removeEffect() {
                battleStateMap?.player?.statusAilments?.remove(at: ailmentIndex)
                playerNode?.statusAilments.remove(at: ailmentIndex)
                battleStateMachine?.updateState(battleStateMap: battleStateMap!)
            }
        }
    }
    
    public func updateEnemyAilmentStatus(ailment: LB_Ailment, ailmentIndex: Int, enemy: LB_EnemyNode) {
        
        /// Iterate through arrayOfEnemies to find matching enemy.
        if (battleStateMap?.enemies?.count)! > 0 {
            for i in (0...(battleStateMap?.enemies?.count)!-1).reversed() {
                if arrayOfEnemies?[i] == enemy {
                    /// If DoT
                    if ailment.onTick() == true {
                        if ailment.getType() == LB_Spell.SpellType.DoT {
                            arrayOfEnemies?[i].decrementHealth(damage: ailment.getEffect().value)
                            
                            /// If enemy dies from DoT remove from game
                            if arrayOfEnemies?[i].getEnemy().isAlive == false {
                                removeEnemy(enemyNode: (arrayOfEnemies?[i])!, enemyIndex: i)
                                break
                            }
                        }
                    }
                    
                    /// Remove from enemy's array and state array
                    if ailment.getStatus() == false {
                        for j in (0...(battleStateMap?.enemies?.count)!-1).reversed() {
                            if arrayOfEnemies?[i] == battleStateMap?.enemies?[j].beingNode {
                                let actionEvent = LB_ActionEvent(ailment: ailment, enemy: (arrayOfEnemies?[i])!)
                                if actionEvent.removeEffect() {
                                    battleStateMap?.enemies?[j].statusAilments?.remove(at: ailmentIndex)
                                    arrayOfEnemies?[i].statusAilments.remove(at: ailmentIndex)
                                    battleStateMachine?.updateState(battleStateMap: battleStateMap!)
                                    break
                                }
                            }
                        }
                    }
                    break
                }
            }
        }
    }
    
    public func checkEnemyStatus(enemyNode: LB_EnemyNode) {
        print("hello")
        if enemyNode.getEnemy().isAlive == false {
            for i in (0...(battleStateMap?.enemies?.count)!-1).reversed() {
                if (arrayOfEnemies?[i])! == enemyNode {
                    print("hello")
                    removeEnemy(enemyNode: enemyNode, enemyIndex: i)
                    return
                }
            }
        }
    }
    
    /// Helper func for when enemy is dead and needs to be removed from the game.
    ///
    /// - Parameters:
    ///   - enemyNode: The enemy that needs ot be removed.
    ///   - enemyIndex: Index in array of enemies.
    /// - Returns: True if removed sucessfully, else false.
    private func removeEnemy(enemyNode: LB_EnemyNode ,enemyIndex: Int) {
        if (battleStateMachine?.remove(object: enemyNode))! {
            arrayOfEnemies?[enemyIndex].removeFromParent()
            arrayOfEnemies?.remove(at: enemyIndex)
            
            if arrayOfEnemies?.count == 0 {
                checkWaves()
            }
            // If sucessful, remove enemy from scene and from battle manager's array of enemies
        }
    }
    private func gameOver() {
        playerNode?.removeAllActions()
        playerNode?.removeFromParent()
        battleScene?.gameOver()
    }
    
    private func victory() {
        battleScene?.victory()
    }
    
}
