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
        
        let level = 1
        
        /// Player
        let player = LB_Player(name: "", level: 1)
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", level: 1)
        
        let fireball = SpellCreator.init().getSpell(level: 1, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        enemy1.setSpells(spells: [fireball])
        enemy1.position = Position.MIDDLE_CENTER
        
        let wave1 = [enemy1]
        let enemyWave = [wave1]
        
        let levelInfo = LB_BattleManager.Level(level: level, player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return levelInfo
    }
}
