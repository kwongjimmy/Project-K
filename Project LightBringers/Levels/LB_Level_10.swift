//
//  LB_Level_10.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 5/1/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_10: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        let level = 10
        /// Player
        let player = LB_Player(name: "", level: 1)
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_pw", level: 9)
        let enemy2 = LB_Enemy(name: "enemy_fw", level: 9)
        let enemy3 = LB_Enemy(name: "enemy_pw", level: 9)
        let enemy4 = LB_Enemy(name: "enemy_fw", level: 9)
        let enemy5 = LB_Enemy(name: "enemy_fw", level: 9)
        
        
        let earthBolt = SpellCreator.init().getSpell(level: 9, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        let fireball = SpellCreator.init().getSpell(level: 9, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 9, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        let lightBolt = SpellCreator.init().getSpell(level: 9, spellType: LB_Spell.SpellType.Silence, elementType: LB_Spell.ElementType.Light)
        
        let waterBolt = SpellCreator.init().getSpell(level: 9, spellType: LB_Spell.SpellType.Slow,elementType: LB_Spell.ElementType.Water)
        
        enemy1.setSpells(spells: [earthBolt])
        enemy1.position = Position.BOTTOM_LEFT
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.BOTTOM_RIGHT
        
        enemy3.setSpells(spells: [lightBolt])
        enemy3.position = Position.BOTTOM_CENTER
        
        enemy4.setSpells(spells: [waterBolt])
        enemy4.position = Position.TOP_CENTER
        
        enemy5.setSpells(spells: [fireDoT])
        enemy5.position = Position.MIDDLE_LEFT
        
        
        let wave1 = [enemy1, enemy2, enemy3, enemy4, enemy5]
        let enemyWave = [wave1]
        
        let levelInfo = LB_BattleManager.Level(level: level, player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return levelInfo
    }
    
}
