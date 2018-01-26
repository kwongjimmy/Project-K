//
//  LB_Level_7.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/27/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_7: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        let level = 7
        /// Player
        let player = LB_Player(name: "", level: 1)
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_pw", level: 7)
        let enemy2 = LB_Enemy(name: "enemy_pw", level: 6)
        let enemy3 = LB_Enemy(name: "enemy_pw", level: 7)
        
        let earthBolt = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        let lightBolt = SpellCreator.init().getSpell(level: 5.0, spellType: LB_Spell.SpellType.Silence, elementType: LB_Spell.ElementType.Light)
        
        enemy1.setSpells(spells: [earthBolt])
        enemy1.position = Position.TOP_CENTER
        
        enemy2.setSpells(spells: [lightBolt])
        enemy2.position = Position.MIDDLE_RIGHT
        
        enemy3.setSpells(spells: [earthBolt])
        enemy3.position = Position.BOTTOM_CENTER
        
        
        let wave1 = [enemy1, enemy2, enemy3]
        let enemyWave = [wave1]
        
        let levelInfo = LB_BattleManager.Level(level: level, player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return levelInfo
    }
}
