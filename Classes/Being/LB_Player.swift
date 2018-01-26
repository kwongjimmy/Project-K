//
//  LB_Player.swift
//  Project K
//
//  Created by Jimmy Kwong on 1/17/17.
//  Copyright © 2017 Jimmy Kwong. All rights reserved.
//

import SpriteKit

/// Player information object that inherits from being object.
class LB_Player: LB_Being {
    
    private var _movementSpeed: Double = 285
    private var spells = [LB_Spell]()

    /// Setter and getter for player movement speed
    var movementSpeed: Double {
        get {
            return _movementSpeed
        }
        set(newMovementSpeed) {
            _movementSpeed = newMovementSpeed
        }
    }
    
    /// Sets new spells into the plauer's spell storage.
    ///
    /// - Parameters:
    ///   - index: The storage slot
    ///   - newSpell: The new spell to be added into the storage slot.
    func setPlayerSpells(index: Int, newSpell: LB_Spell) {
        spells[index] = newSpell
    }
    
    /// Gets the spell inventory of the player.
    ///
    /// - Returns: Array of spells
    func getPlayerSpells() -> [LB_Spell] {
        return spells
    }
    
    /// Initialization of player information object.
    ///
    /// - Parameters:
    ///   - name: Player's name
    ///   - health: Player's health
    ///   - isAlive: Player's living status
    ///   - hitBox: Player's hitbox size
    override init(name: String, level: Float) {
        super.init(name: name, level: level)
        let fire = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        let light = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Light)
        let air = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.Weaken, elementType: LB_Spell.ElementType.Air)
        let earth = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Earth)
        fire.castTime *= 0.20
        light.castTime *= 0.20
        air.castTime *= 0.20
        earth.castTime *= 0.20
        spells = [fire, light, air, earth]
        
        maxHealth = 50
        currentHealth = 50
    }
}
