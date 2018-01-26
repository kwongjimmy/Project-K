//
//  LB_Spell.swift
//  Project K
//
//  Created by Jimmy Kwong on 1/17/17.
//  Copyright © 2017 Jimmy Kwong. All rights reserved.
//

import SpriteKit

/// Characteristics for initializing and creating a spell
class LB_Spell {
    
    /// Spell Types
    ///
    /// - Default:
    /// - Damage: Spells that inflict instant damage.
    /// - DoT: Spells that does damage over time.
    /// - Slow: DEBUFF:
    /// - Silence: DEBUFF: Prevents casting spell.
    /// - Shock: DEBUFF: Takes inreased recieving damage
    /// - Weaken: DEBUFF: Spells casted are weakened
    /// - Blind: DEBUFF: CAST only in a straight line
    /// - Confuse: DEBUFF: Attack self/ others
    enum SpellType {
        case Default, Damage, DoT, Slow, Silence, Shock, Weaken, Blind, Confuse
    }
    
    /// Element Types
    ///
    /// - Default:
    /// - Fire:
    /// - Water:
    /// - Earth:
    /// - Air:
    /// - Light:
    /// - Dark:
    enum ElementType {
        case Default, Fire, Water, Earth, Air, Light, Dark
    }
    
    struct effect {
        var value: Float
        var duration: Float
        
        init(value: Float, duration: Float) {
            self.value = value
            self.duration = duration
        }
    }
    
    private var _name: String
    private var _missileSpeed: Float
    private var _hitBox: CGSize
    private var _castTime: Float
    private var _elementType: ElementType = ElementType.Default
    private var _type: SpellType = SpellType.Default
    private var _description: String
    private var _damage: Float
    private var _level: Int
    private var _range: Float
    private var _cooldown: Float
    
    private var _effect: effect
    
    /// Setter and getter for spell name.
    var name: String {
        get {
            return _name
        }
        set(newName) {
            _name = newName
        }
    }
    
    /// Setter and gett for spell level.
    var level: Int {
        get {
            return _level
        }
        set(newLevel) {
            _level = newLevel
        }
    }
    
    /// Setter and getter for spell missle speed.
    var missileSpeed: Float {
        get {
            return _missileSpeed
        }
        set(newMissileSpeed) {
            _missileSpeed = newMissileSpeed
        }
    }
    
    /// Setter and getter for spell hit box size.
    var hitBox: CGSize {
        get {
            return _hitBox
        }
        set(newHitBox) {
            _hitBox = newHitBox
        }
    }
    
    /// Setter and getter for spell cast time.
    var castTime: Float {
        get {
            return _castTime
        }
        set(newCastTime) {
            _castTime = newCastTime
        }
    }
    
    /// Setter and getter for spell element type.
    var elementType: ElementType {
        get {
            return _elementType
        }
        set(newElementType) {
            _elementType = newElementType
        }
    }
    
    /// Setter and getter for spell type.
    var spellType: SpellType {
        get {
            return _type
        }
        set(newType) {
            _type = newType
        }
    }
    
    /// Setter and getter for spell description.
    var spellDescription: String {
        get {
            return _description
        }
        set(newDescription) {
            _description = newDescription
        }
    }
    
    /// Setter and getter for spell damage.
    var damage: Float {
        get {
            return _damage
        }
        set(newDamage) {
            _damage = newDamage
        }
    }
    
    ///Setter and getter for spell range.
    var range: Float{
        get {
            return _range
        }
        set(newRange) {
            _range = newRange
        }
    }
    
    var cooldown: Float{
        get {
            return _cooldown
        }
        set(newCooldown) {
            _cooldown = newCooldown
        }
    }
    
    var effect: effect{
        get {
            return _effect
        }
        set(newEffect) {
            _effect = newEffect
        }
    }
    
    
    /// Initialization of spell information object.
    ///
    /// - Parameters:
    ///   - name: Spell's name
    ///   - spellType: Spell's type
    ///   - elementType: Spell's element
    ///   - level: Spell's level
    ///   - missileSpeed: Spell's missile speed
    ///   - castTime: Spell's cast time
    ///   - cooldown: Spell's cooldown
    ///   - damage: Spell's damage
    ///   - range: Spell's range
    ///   - effect: Spell's effect
    ///   - hitBox: Spell's hitbox size
    ///   - description: Spell description
    init(name: String, spellType: SpellType, elementType: ElementType, level: Int, missileSpeed: Float, castTime: Float, cooldown: Float, damage: Float, range: Float, effect: effect, hitBox: CGSize, description: String ) {
        _name = name
        _type = spellType
        _elementType = elementType
        _level = level
        _missileSpeed = missileSpeed
        _castTime = castTime
        _cooldown = cooldown
        _damage = damage
        _range = range
        _effect = effect
        _hitBox = hitBox
        _description = description
    }
    
}
