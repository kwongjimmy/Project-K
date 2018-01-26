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
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_pw", health: 50, hitBox: CGSize())
        let enemy2 = LB_Enemy(name: "enemy_pw", health: 50, hitBox: CGSize())
        let enemy3 = LB_Enemy(name: "enemy_pw", health: 50, hitBox: CGSize())
        
        let earthBolt = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        enemy1.setSpells(spells: [earthBolt])
        enemy1.position = Position.TOP_CENTER
        
        enemy2.setSpells(spells: [earthBolt])
        enemy2.position = Position.MIDDLE_RIGHT
        
        enemy3.setSpells(spells: [earthBolt])
        enemy3.position = Position.BOTTOM_CENTER
        
        
        let wave1 = [enemy1, enemy2, enemy3]
        let enemyWave = [wave1]
        
        let level = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level
    }
}
