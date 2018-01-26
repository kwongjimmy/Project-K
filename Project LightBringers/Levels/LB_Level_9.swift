//
//  LB_Level_9.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 5/1/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_9: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        let level = 9
        /// Player
        let player = LB_Player(name: "", level: 1)
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_pw", level: 7)
        let enemy2 = LB_Enemy(name: "enemy_fw", level: 7)
        let enemy3 = LB_Enemy(name: "enemy_pw", level: 7)
        
        /// Wave 2
        let enemy4 = LB_Enemy(name: "enemy_iw", level: 8)
        let enemy5 = LB_Enemy(name: "enemy_pw", level: 8)
        let enemy6 = LB_Enemy(name: "enemy_iw", level: 8)
        
        /// Wave 3
        let enemy7 = LB_Enemy(name: "enemy_fw", level: 9)
        let enemy8 = LB_Enemy(name: "enemy_iw", level: 9)
        let enemy9 = LB_Enemy(name: "enemy_fw", level: 9)
        
        let earthBolt = SpellCreator.init().getSpell(level: 9.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        let fireball = SpellCreator.init().getSpell(level: 9.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 9.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        let lightBolt = SpellCreator.init().getSpell(level: 9.0, spellType: LB_Spell.SpellType.Silence, elementType: LB_Spell.ElementType.Light)
        
        let waterBolt = SpellCreator.init().getSpell(level: 9.0, spellType: LB_Spell.SpellType.Slow,elementType: LB_Spell.ElementType.Water)
        
        let airBolt = SpellCreator.init().getSpell(level: 9.0, spellType: LB_Spell.SpellType.Weaken, elementType: LB_Spell.ElementType.Air)
        
        enemy1.setSpells(spells: [earthBolt])
        enemy1.position = Position.TOP_CENTER
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.TOP_RIGHT
        
        enemy3.setSpells(spells: [lightBolt])
        enemy3.position = Position.TOP_LEFT
        
        enemy4.setSpells(spells: [waterBolt])
        enemy4.position = Position.MIDDLE_LEFT
        
        enemy5.setSpells(spells: [earthBolt])
        enemy5.position = Position.MIDDLE_RIGHT
        
        enemy6.setSpells(spells: [waterBolt])
        enemy6.position = Position.MIDDLE_CENTER
        
        enemy7.setSpells(spells: [fireball])
        enemy7.position = Position.BOTTOM_LEFT
        
        enemy8.setSpells(spells: [airBolt])
        enemy8.position = Position.MIDDLE_CENTER
        
        enemy9.setSpells(spells: [fireDoT])
        enemy9.position = Position.BOTTOM_RIGHT
        
        let wave1 = [enemy1, enemy2, enemy3]
        let wave2 = [enemy4, enemy5, enemy6]
        let wave3 = [enemy7, enemy8, enemy9]
        let enemyWave = [wave1, wave2, wave3]
        
        let levelInfo = LB_BattleManager.Level(level: level, player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return levelInfo
    }

}
