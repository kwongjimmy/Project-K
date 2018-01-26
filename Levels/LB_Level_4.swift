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
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        let enemy2 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        let enemy3 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        
        /// Wave 2
        let enemy4 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        let enemy5 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        
        let fireball = SpellCreator.init().getSpell(level: 3.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 3.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
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
        
        let wave1 = [enemy1, enemy2, enemy3]
        let wave2 = [enemy4, enemy5]
        let enemyWave = [wave1,wave2]
        
        let level4 = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level4
    }
}
