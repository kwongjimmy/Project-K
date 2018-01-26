//
//  LB_Collision.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 3/24/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

/// Collision object that will hold information of the collision that occured between Being and Spell.
class LB_Collision {
    
    private var collisionTarget: SKSpriteNode?
    private var collisionSpell: LB_SpellNode?
    public var type: String? //Type refers to the type of collision, "Player" for player collision, "Enemy" for enemy collision.
    
    /// Initialization of the collision between enemy and spell.
    ///
    /// - Parameters:
    ///   - target: Enemy object
    ///   - spell: Spell object
    init(target: LB_EnemyNode, spell: LB_SpellNode){
        collisionTarget = target
        collisionSpell = spell
        type = "enemy"
    }
    
    /// Initialization of the collision between player and spell.
    ///
    /// - Parameters:
    ///   - target: Player object
    ///   - spell: Spell objecy
    init(target: LB_PlayerNode, spell: LB_SpellNode) {
        collisionTarget = target
        collisionSpell = spell
        type = "player"
    }
    
    /// Gets the current target of the collision.
    ///
    /// - Returns: the target of the collision based on type.
    public func getCollisionTarget() -> SKSpriteNode? {
        return collisionTarget!
    }
    
    /// Gets the current spell of the collision.
    ///
    /// - Returns: the spell of the collision.
    public func getCollisionSpell() -> LB_SpellNode {
        return collisionSpell!
    }
}
