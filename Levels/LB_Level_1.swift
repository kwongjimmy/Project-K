//
//  LB_Level_1.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/27/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_1: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", health: 20, hitBox: CGSize())
        
        let fireball = LB_Spell(name: "red", spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire, level: 1, missileSpeed: 1, castTime: 0.5, cooldown: 1, damage: 5, range: 10, effect: LB_Spell.effect.init(value: 1, duration: 2), hitBox: CGSize(), description: "???")
        
        enemy1.setSpells(spells: [fireball])
        enemy1.position = Position.MIDDLE_CENTER
        
        let wave1 = [enemy1]
        let enemyWave = [wave1]
        
        let level1 = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level1
    }
}
