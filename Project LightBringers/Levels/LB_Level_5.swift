//
//  LB_Level_4.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/27/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_5: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        
        let level = 5
        
        /// Player
        let player = LB_Player(name: "", level: 1)
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", level: 4)
        let enemy2 = LB_Enemy(name: "enemy_fw", level: 4)
        let enemy3 = LB_Enemy(name: "enemy_iw", level: 4)
        
        /// Wave 2
        let enemy4 = LB_Enemy(name: "enemy_fw", level: 4)
        let enemy5 = LB_Enemy(name: "enemy_fw", level: 4)
        
        /// Wave 3
        let enemy6 = LB_Enemy(name: "enemy_pw", level: 5)
        
        let fireball = SpellCreator.init().getSpell(level: 4.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 3.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        let earthBolt = SpellCreator.init().getSpell(level: 3.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        let waterBolt = SpellCreator.init().getSpell(level: 5.0, spellType: LB_Spell.SpellType.Slow, elementType: LB_Spell.ElementType.Water)

        
        enemy1.setSpells(spells: [fireDoT])
        enemy1.position = Position.MIDDLE_LEFT
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.MIDDLE_RIGHT
        
        enemy3.setSpells(spells: [waterBolt])
        enemy3.position = Position.BOTTOM_CENTER
        
        enemy4.setSpells(spells: [fireDoT])
        enemy4.position = Position.TOP_LEFT
        
        enemy5.setSpells(spells: [fireball])
        enemy5.position = Position.TOP_RIGHT
        
        enemy6.setSpells(spells: [earthBolt])
        enemy6.position = Position.MIDDLE_CENTER
        
        let wave1 = [enemy1, enemy2, enemy3]
        let wave2 = [enemy4, enemy5]
        let wave3 = [enemy6]
        
        let enemyWave = [wave1,wave2,wave3]
        
        let levelInfo = LB_BattleManager.Level(level: level, player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return levelInfo
    }
}
