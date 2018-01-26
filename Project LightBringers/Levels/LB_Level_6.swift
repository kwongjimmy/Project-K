//
//  LB_Level_6.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/27/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_6: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        let level = 6
        /// Player
        let player = LB_Player(name: "", level: 1)
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", level: 5)
        let enemy2 = LB_Enemy(name: "enemy_fw", level: 5)
        let enemy3 = LB_Enemy(name: "enemy_fw", level: 5)
        
        /// Wave 2
        let enemy4 = LB_Enemy(name: "enemy_fw", level: 5)
        let enemy5 = LB_Enemy(name: "enemy_fw", level: 5)
        let enemy6 = LB_Enemy(name: "enemy_pw", level: 5)
        
        /// Wave 3
        let enemy7 = LB_Enemy(name: "enemy_pw", level: 6)
        let enemy8 = LB_Enemy(name: "enemy_fw", level: 6)
        let enemy9 = LB_Enemy(name: "enemy_iw", level: 6)
        
        
        let fireball = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 4.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        let earthBolt = SpellCreator.init().getSpell(level: 4.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        let waterBolt = SpellCreator.init().getSpell(level: 5.0, spellType: LB_Spell.SpellType.Slow, elementType: LB_Spell.ElementType.Water)
        
        enemy1.setSpells(spells: [fireball])
        enemy1.position = Position.MIDDLE_LEFT
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.MIDDLE_RIGHT
        
        enemy3.setSpells(spells: [fireDoT])
        enemy3.position = Position.BOTTOM_CENTER
        
        enemy4.setSpells(spells: [fireball])
        enemy4.position = Position.BOTTOM_LEFT
        
        enemy5.setSpells(spells: [fireDoT])
        enemy5.position = Position.MIDDLE_RIGHT
        
        enemy6.setSpells(spells: [earthBolt])
        enemy6.position = Position.TOP_CENTER
        
        enemy7.setSpells(spells: [earthBolt])
        enemy7.position = Position.MIDDLE_LEFT
        
        enemy8.setSpells(spells: [fireball])
        enemy8.position = Position.MIDDLE_CENTER
        
        enemy9.setSpells(spells: [waterBolt])
        enemy9.position = Position.MIDDLE_RIGHT
        
        let wave1 = [enemy1, enemy2, enemy3]
        let wave2 = [enemy4, enemy5, enemy6]
        let wave3 = [enemy7, enemy8, enemy9]
        let enemyWave = [wave1,wave2,wave3]
        
        let levelInfo = LB_BattleManager.Level(level: level, player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return levelInfo
    }
}
