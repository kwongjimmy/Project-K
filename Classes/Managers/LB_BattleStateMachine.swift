//
//  LB_BattleStateMachine.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 3/20/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_BattleStateMachine {
    
    var battleManager: LB_BattleManager?
    var battleStateMap: BattleStateMap?
    var updateComplete: Bool?
    
    
    /// State map as of now will manage 3 states: Player, array of Enemy, and array of Spells.
    struct BattleStateMap {
        var player: Player? = nil
        var enemies: [Enemy]?
        var spells: [LB_SpellNode]?
    }
    
    /// Player struc contains a reference to itself and list of debuffs on itself.
    struct Player {
        let beingNode: LB_PlayerNode
        var statusAilments: [LB_Ailment]?
    }
    
    
    /// Contains reference to self and list of debuffs.
    struct Enemy {
        let beingNode: LB_EnemyNode
        var statusAilments: [LB_Ailment]?
    }
    
    init(battleManager: LB_BattleManager) {
        self.battleManager = battleManager
        updateComplete = true
    }
    
    public func initializeState() -> Bool {
        battleStateMap = BattleStateMap(player: nil, enemies: [Enemy](), spells: [LB_SpellNode]())
        battleManager?.updateState(updatedState: battleStateMap!)
        return true
    }
    
    /// Registers the spell object into the state.
    ///
    /// - Parameter object: Spell object
    /// - Returns: True if registered into state, else false
    public func register(object: LB_SpellNode) -> Bool{
        battleStateMap?.spells?.append(object)
        battleManager?.updateState(updatedState: battleStateMap!)
        return true
    }
    
    /// Registers the player object into the state.
    ///
    /// - Parameter object: Player object
    /// - Returns: True if registered into state, else false
    public func register(object: LB_PlayerNode) -> Bool {
        battleStateMap?.player = Player(beingNode: object, statusAilments: [LB_Ailment]())
        battleManager?.updateState(updatedState: battleStateMap!)
        return true
    }
    
    /// Registers the enemy object into the state.
    ///
    /// - Parameter object: Enemy object
    /// - Returns: True if registered into state, else false
    public func register(object: LB_EnemyNode) -> Bool {
        battleStateMap?.enemies?.append(Enemy(beingNode: object, statusAilments: [LB_Ailment]()))
        battleManager?.updateState(updatedState: battleStateMap!)
        return true
    }
    
    
    /// Player state updater
    ///
    /// - Parameters:
    ///   - object: Player object
    ///   - actionEvent: Action event that occured.
    public func update(object: LB_PlayerNode, actionEvent: LB_ActionEvent) {
        
        /// If player current have at least 1 debuff
        if((battleStateMap?.player?.statusAilments?.count)! > 0) {
            
            /// Iterate through the list
            for i in 0...(battleStateMap?.player?.statusAilments?.count)!-1 {
                
                /// If the debuff it is recieving has been applied to player already, apply the new debuff.
                /// Game scenario: Same debuffs do not stack, value and duration gets replaced by new debuff.
                if battleStateMap?.player?.statusAilments?[i].getType() == actionEvent.getAilment().getType() {
                    battleStateMap?.player?.statusAilments?[i] = actionEvent.getAilment()
                    break
                } else if i == (battleStateMap?.player?.statusAilments?.count)!-1 {
                    /// If its different then add it to player state array.
                    battleStateMap?.player?.statusAilments?.append(actionEvent.getAilment())
                }
            }
        } else {
            /// If player has no debuffs, add it to array.
            battleStateMap?.player?.statusAilments?.append(actionEvent.getAilment())
        }
        /// Player node object's reference array will be updated with player state array.
        battleStateMap?.player?.beingNode.statusAilments = (battleStateMap?.player?.statusAilments)!
        
        /// Give BM the new stateMap
        battleManager?.updateState(updatedState: battleStateMap!)
    }
    
    /// Enemy state updater
    ///
    /// - Parameters:
    ///   - object: Enemy object
    ///   - actionEvent: Action event that occured
    public func update(object: LB_EnemyNode, actionEvent: LB_ActionEvent) {
        
        /// Match the enemy object with the enemy state array of enemies
        for i in (0...((battleStateMap?.enemies?.count)!-1)).reversed() {
            
            /// If matched begin updating
            if object == (battleStateMap?.enemies?[i].beingNode) {
                var matchedObject = battleStateMap?.enemies?[i]
                
                /// If enemy has at least 1 debuff
                if (matchedObject?.statusAilments?.count)! > 0 {
                    
                    /// Iterate throught the array of debuffs
                    for j in 0...(matchedObject?.statusAilments?.count)!-1 {
                        
                        /// If the debuff exist already, replace with new one.
                        if matchedObject?.statusAilments?[j].getType() == actionEvent.getAilment().getType() {
                            matchedObject?.statusAilments?[j] = actionEvent.getAilment()
                            break
                        } else if j == (matchedObject?.statusAilments?.count)!-1 {
                            battleStateMap?.enemies?[i].statusAilments?.append(actionEvent.getAilment())
                        }
                    }
                } else {
                    /// If no debuffs, add it to the array
                    battleStateMap?.enemies?[i].statusAilments?.append(actionEvent.getAilment())
                }
                
                /// After updating state, update enemy reference's array of ailments.
                battleStateMap?.enemies?[i].beingNode.statusAilments = (battleStateMap?.enemies?[i].statusAilments)!
                break
            }
        }
        
        /// Finally give BM the new state.
        battleManager?.updateState(updatedState: battleStateMap!)
    }
    
    /// Removes the spell object from the state.
    ///
    /// - Parameter object: Spell object
    /// - Returns: True if removed sucessfully, else false
    public func remove(object: LB_SpellNode) -> Bool {
        for i in (0...(battleStateMap?.spells?.count)!-1).reversed() {
            if battleStateMap?.spells?[i] == object {
                battleStateMap?.spells?.remove(at: i)
                battleManager?.updateState(updatedState: battleStateMap!)
                break
            }
        }
        return true
    }
    
    /// Removes the player object from the state.
    ///
    /// - Parameter object: Player object
    /// - Returns: True if removed sucessfully, else false
    public func remove(object: LB_PlayerNode) -> Bool {
        battleStateMap?.player = nil
        print("player removed")
        battleManager?.updateState(updatedState: battleStateMap!)
        return true
    }
    
    /// Removes the enemy object from the state.
    ///
    /// - Parameter object: Enemy object
    /// - Returns: True if removed sucessfully, else false
    public func remove(object: LB_EnemyNode) -> Bool {
        for i in (0...(battleStateMap?.enemies?.count)!-1).reversed() {
            if battleStateMap?.enemies?[i].beingNode == object {
                print("removed enemy")
                battleStateMap?.enemies?.remove(at: i)
                battleManager?.updateState(updatedState: battleStateMap!)
                break
            }
        }
        return true
    }
    /// Updates the current state of the state machine.
    ///
    /// - Parameter battleStateMap: Contains the state information of the current battle scene.
    public func setState(battleStateMap: BattleStateMap) {
        self.battleStateMap = battleStateMap
        battleManager?.updateState(updatedState: self.battleStateMap!)
    }
    
    public func updateState(battleStateMap: BattleStateMap) {
        self.battleStateMap = battleStateMap
    }
    /// Gets the current state of the state machine.
    ///
    /// - Returns: A battlestatemap structure.
    public func getState() -> BattleStateMap {
        return battleStateMap!
    }
    
    /// Gets the current update status of the state machine.
    ///
    /// - Returns: True if it has completed updating, else false
    public func getUpdateStatus() -> Bool {
        return updateComplete!
    }
    

}
