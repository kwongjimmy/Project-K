//
//  LB_LevelHelper.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/26/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

struct Position {
    private static let width: Double = 750
    private static let height: Double = 1334
    
    static let TOP_LEFT = CGPoint(x: -width/3, y: height/4 + 200)
    static let TOP_CENTER = CGPoint(x: 0, y: height/4 + 200)
    static let TOP_RIGHT = CGPoint(x: width/3, y: height/4 + 200)
    
    static let MIDDLE_LEFT = CGPoint(x: -width/3, y: height/4)
    static let MIDDLE_CENTER = CGPoint(x: 0, y: height/4)
    static let MIDDLE_RIGHT = CGPoint(x: width/3, y: height/4)
    
    static let BOTTOM_LEFT = CGPoint(x: -width/3, y: height/4 - 200)
    static let BOTTOM_CENTER = CGPoint(x: 0, y: height/4 - 200)
    static let BOTTOM_RIGHT = CGPoint(x: width/3, y: height/4 - 200)
}

struct SpellCreator {
    func getSpell(level: Float, spellType: LB_Spell.SpellType, elementType: LB_Spell.ElementType) -> LB_Spell {
        
        /// FIRE SPELLS
        if elementType == LB_Spell.ElementType.Fire {
            return getFireSpell(level: level, spellType: spellType)
            
        /// EARTH SPELLS
        } else if elementType == LB_Spell.ElementType.Earth {
            return getEarthSpell(level: level, spellType: spellType)
            
        /// WATER SPELLS
        } else if  elementType == LB_Spell.ElementType.Water {
            return getWaterSpell(level: level, spellType: spellType)
        } else if elementType == LB_Spell.ElementType.Air {
            
        /// AIR SPELLS
            return getAirSpell(level: level, spellType: spellType)
        }
        
        return LB_Spell(name: "dummy", spellType: LB_Spell.SpellType.Default, elementType: LB_Spell.ElementType.Default, level: 0, missileSpeed: 0, castTime: 0, cooldown: 0, damage: 0, range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
    }
    
    private func getFireSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        
        /// FIRE DOT
        if spellType == LB_Spell.SpellType.DoT {
            let spell = LB_Spell(name: "red", spellType: spellType, elementType: LB_Spell.ElementType.Fire, level: Int(level), missileSpeed: 1, castTime: 1.5, cooldown: 3, damage: Float(2.0 + (0.25 * level)), range: 0, effect: LB_Spell.effect.init(value: Float(1.5 + (0.5 * level)), duration: 3), hitBox: CGSize(), description: "")
            return spell
        /// FIRE DAMAGE
        } else {
            let spell = LB_Spell(name: "red", spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire, level: Int(level), missileSpeed: 1, castTime: 1.5, cooldown: 2, damage: Float(2.50 + (level * 2.50)), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
            return spell
        }
    }
    
    private func getEarthSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        
        /// Earth SHOCK
        if spellType == LB_Spell.SpellType.Shock {
            let spell = LB_Spell(name: "green", spellType: spellType, elementType: LB_Spell.ElementType.Light, level: Int(level), missileSpeed: 1, castTime: 1.5, cooldown: 3, damage: Float(1.5 + (0.5 * level)), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 6), hitBox: CGSize(), description: "")
            return spell
            
        /// Earth DAMAGE
        } else {
            let spell = LB_Spell(name: "green", spellType: spellType, elementType: LB_Spell.ElementType.Light, level: Int(level), missileSpeed: 0, castTime: 1.5, cooldown: 2, damage: Float(2 + (0.75 * level)), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
            return spell
        }
    }
    
    private func getWaterSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        
        /// SLOW
        if spellType == LB_Spell.SpellType.Slow {
            let spell = LB_Spell(name: "blue", spellType: spellType, elementType: LB_Spell.ElementType.Water, level: Int(level), missileSpeed: 1, castTime: 1.5, cooldown: 3, damage: Float(1 + (level * 0.5)), range: 0, effect: LB_Spell.effect.init(value: (10 + level * 2.5), duration: (1.5 + (level * 0.25))), hitBox: CGSize(), description: "")
            return spell
        } else {
            let spell = LB_Spell(name: "blue", spellType: spellType, elementType: LB_Spell.ElementType.Water, level: Int(level), missileSpeed: 1, castTime: 1, cooldown: 2.5, damage: Float(2 + (level * 1)), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
            return spell
        }
    }
    
    private func getAirSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        if spellType == LB_Spell.SpellType.Weaken {
            let spell = LB_Spell(name: "yellow", spellType: spellType, elementType: LB_Spell.ElementType.Air, level: Int(level), missileSpeed: 1, castTime: 2, cooldown: 1.5, damage: 1.0 + (1.0 * level), range: 0, effect: LB_Spell.effect.init(value: 10 + (5 * level), duration: 5), hitBox: CGSize(), description: "")
            return spell
        }
        let spell = LB_Spell(name: "yellow", spellType: spellType, elementType: LB_Spell.ElementType.Air, level: Int(level), missileSpeed: 0, castTime: 2, cooldown: 1.5, damage: 1.5 + (1.0 * level), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
        return spell
    }
    
    private func getLightSpell(level: Float, spellType: LB_Spell.SpellType) {
    
    }
    
    private func getDarkSpell(level: Float, spellType: LB_Spell.SpellType) {
    
    }
}
