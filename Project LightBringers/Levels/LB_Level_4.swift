//
//  LB_Level_4.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/27/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_4: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        
        let level = 4
        
        /// Player
        let player = LB_Player(name: "", level: 1)
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", level: 3)
        let enemy2 = LB_Enemy(name: "enemy_fw", level: 3)
        let enemy3 = LB_Enemy(name: "enemy_fw", level: 3)
        
        /// Wave 2
        let enemy4 = LB_Enemy(name: "enemy_fw", level: 4)
        let enemy5 = LB_Enemy(name: "enemy_fw", level: 4)
        let enemy6 = LB_Enemy(name: "enemy_iw", level: 4)
        
        let fireball = SpellCreator.init().getSpell(level: 3.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 3.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        let waterBolt = SpellCreator.init().getSpell(level: 7.0, spellType: LB_Spell.SpellType.Slow, elementType: LB_Spell.ElementType.Water)

        
        enemy1.setSpells(spells: [fireball])
        enemy1.position = Position.BOTTOM_RIGHT
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.BOTTOM_LEFT
        
        enemy3.setSpells(spells: [fireDoT])
        enemy3.position = Position.MIDDLE_CENTER
        
        enemy4.setSpells(spells: [fireDoT])
        enemy4.position = Position.TOP_LEFT
        
        enemy5.setSpells(spells: [fireball])
        enemy5.position = Position.TOP_RIGHT
        
        enemy6.setSpells(spells: [waterBolt])
        enemy6.position = Position.MIDDLE_CENTER
        
        let wave1 = [enemy1, enemy2, enemy3]
        let wave2 = [enemy4, enemy5]
        let enemyWave = [wave1,wave2]
        
        let levelInfo = LB_BattleManager.Level(level: level, player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return levelInfo
    }
}
