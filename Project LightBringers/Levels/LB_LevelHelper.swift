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

struct LevelManager {
    func getLevel(level: Int) -> LB_BattleScene {
        var battleScene = LB_BattleScene(fileNamed: "LB_BattleScene")
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
        }
        return battleScene!
    }
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
            
        /// AIR SPELLS
        } else if elementType == LB_Spell.ElementType.Air {
            return getAirSpell(level: level, spellType: spellType)
            
        /// DARK SPELLS
        } else if elementType == LB_Spell.ElementType.Dark {
            return getDarkSpell(level: level, spellType: spellType)
        } else if elementType == LB_Spell.ElementType.Light {
            return getLightSpell(level: level, spellType: spellType)
        } else {
            return LB_Spell(name: "dummy", spellType: LB_Spell.SpellType.Default, elementType: LB_Spell.ElementType.Default, level: 0, missileSpeed: 0, castTime: 0, cooldown: 0, damage: 0, range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
        }
    }
    
    private func getFireSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        
        /// FIRE DOT
        if spellType == LB_Spell.SpellType.DoT {
            let spell = LB_Spell(name: "fire", spellType: spellType, elementType: LB_Spell.ElementType.Fire, level: Int(level), missileSpeed: 1.25, castTime: 2, cooldown: 4, damage: Float(2.0 + (0.25 * level)), range: 0, effect: LB_Spell.effect.init(value: Float(1.5 + (0.25 * level)), duration: 3), hitBox: CGSize(), description: "")
            return spell
        /// FIRE DAMAGE
        } else {
            let spell = LB_Spell(name: "fire", spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire, level: Int(level), missileSpeed: 1.25, castTime: 2.5, cooldown: 4, damage: Float(2.50 + (level * 1.25)), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
            return spell
        }
    }
    
    private func getEarthSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        
        /// Earth SHOCK
        if spellType == LB_Spell.SpellType.Shock {
            let spell = LB_Spell(name: "earth", spellType: spellType, elementType: LB_Spell.ElementType.Earth, level: Int(level), missileSpeed: 1.5, castTime: 3.5, cooldown: 3.5, damage: Float(1.5 + (0.75 * level)), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 4 + (0.1 * level)), hitBox: CGSize(), description: "")
            return spell
            
        /// Earth DAMAGE
        } else {
            let spell = LB_Spell(name: "earth", spellType: spellType, elementType: LB_Spell.ElementType.Earth, level: Int(level), missileSpeed: 2, castTime: 3.5, cooldown: 3.5, damage: Float(4.0 + (1.25 * level)), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
            return spell
        }
    }
    
    private func getWaterSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        
        /// SLOW
        if spellType == LB_Spell.SpellType.Slow {
            let spell = LB_Spell(name: "ice", spellType: spellType, elementType: LB_Spell.ElementType.Water, level: Int(level), missileSpeed: 0.5, castTime: 2.25, cooldown: 3, damage: Float(1 + (level * 0.5)), range: 0, effect: LB_Spell.effect.init(value: (10 + 1.25 * level), duration: (1.5 + (level * 0.375))), hitBox: CGSize(), description: "")
            return spell
        } else {
            let spell = LB_Spell(name: "ice", spellType: spellType, elementType: LB_Spell.ElementType.Water, level: Int(level), missileSpeed: 0.5, castTime: 1.25, cooldown: 2.5, damage: Float(2 + (level * 1)), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
            return spell
        }
    }
    
    private func getAirSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        if spellType == LB_Spell.SpellType.Weaken {
            let spell = LB_Spell(name: "air", spellType: spellType, elementType: LB_Spell.ElementType.Air, level: Int(level), missileSpeed: 0, castTime: 1.25, cooldown: 1.5, damage: 2.0 + (0.625 * level), range: 0, effect: LB_Spell.effect.init(value: 10 + (5 * level), duration: 5), hitBox: CGSize(), description: "")
            return spell
        }
        let spell = LB_Spell(name: "air", spellType: spellType, elementType: LB_Spell.ElementType.Air, level: Int(level), missileSpeed: -0.35, castTime: 1.5, cooldown: 1.5, damage: 1.5 + (1.0 * level), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
        return spell
    }
    
    private func getLightSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        if spellType == LB_Spell.SpellType.Shock {
            let spell = LB_Spell(name: "light", spellType: spellType, elementType: LB_Spell.ElementType.Light, level: Int(level), missileSpeed: -0.35, castTime: 2.25, cooldown: 2.25, damage: 2.0 + (0.85 * level), range: 0, effect: LB_Spell.effect.init(value: 10 + (level * 2.5), duration: 3 + (level * 0.25)), hitBox: CGSize(), description: "")
            return spell
        } else {
            let spell = LB_Spell(name: "light", spellType: spellType, elementType: LB_Spell.ElementType.Light, level: Int(level), missileSpeed: -0.35, castTime: 2.5, cooldown: 2.5, damage: 3.0, range: 0, effect: LB_Spell.effect.init(value: 0, duration: (level * 0.125)), hitBox: CGSize(), description: "")
            return spell
        }
    }
    
    private func getDarkSpell(level: Float, spellType: LB_Spell.SpellType) -> LB_Spell {
        
        /// CONFUSE
        if spellType == LB_Spell.SpellType.Confuse {
            let spell = LB_Spell(name: "dark", spellType: spellType, elementType: LB_Spell.ElementType.Dark, level: Int(level), missileSpeed: 1, castTime: 2, cooldown: 5, damage: 2 + (0.25 * level), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 4 + (0.125 * level)), hitBox: CGSize(), description: "")
            return spell
        } else if spellType == LB_Spell.SpellType.Blind {
            let spell = LB_Spell(name: "dark", spellType: spellType, elementType: LB_Spell.ElementType.Dark, level: Int(level), missileSpeed: 1, castTime: 2, cooldown: 5, damage: 2 + (0.25 * level), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 5), hitBox: CGSize(), description: "")
            return spell
        } else {
            let spell = LB_Spell(name: "dark", spellType: spellType, elementType: LB_Spell.ElementType.Dark, level: Int(level), missileSpeed: 1, castTime: 2.5, cooldown: 5, damage: 2.5 + (0.35 * level), range: 0, effect: LB_Spell.effect.init(value: 0, duration: 0), hitBox: CGSize(), description: "")
            return spell
        }
    }
}
