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
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", health: 20, hitBox: CGSize())
        let enemy2 = LB_Enemy(name: "enemy_fw", health: 20, hitBox: CGSize())
        
        let fireball = SpellCreator.init().getSpell(level: 2.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        enemy1.setSpells(spells: [fireball])
        enemy1.position = Position.MIDDLE_LEFT
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.MIDDLE_RIGHT
        
        let wave1 = [enemy1, enemy2]
        let enemyWave = [wave1]
        
        let level2 = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level2
    }
}
