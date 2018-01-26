//
//  LB_Level_2.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/27/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_2: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        
        let level = 2
        
        /// Player
        let player = LB_Player(name: "", level: 1)
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", level: 1)
        let enemy2 = LB_Enemy(name: "enemy_fw", level: 1)
        
        /// Wave 2
        let enemy3 = LB_Enemy(name: "enemy_iw", level: 2)
        
        let fireball = SpellCreator.init().getSpell(level: 2.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let waterBolt = SpellCreator.init().getSpell(level: 7.0, spellType: LB_Spell.SpellType.Slow, elementType: LB_Spell.ElementType.Water)
        
        enemy1.setSpells(spells: [fireball])
        enemy1.position = Position.MIDDLE_LEFT
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.MIDDLE_RIGHT
        
        enemy3.setSpells(spells: [waterBolt])
        enemy3.position = Position.TOP_CENTER
        
        let wave1 = [enemy1, enemy2]
        let enemyWave = [wave1]
        
        let levelInfo = LB_BattleManager.Level(level: level, player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return levelInfo
    }
}
