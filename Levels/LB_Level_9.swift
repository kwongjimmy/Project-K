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
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_pw", health: 45, hitBox: CGSize())
        let enemy2 = LB_Enemy(name: "enemy_pw", health: 45, hitBox: CGSize())
        let enemy3 = LB_Enemy(name: "enemy_pw", health: 45, hitBox: CGSize())
        
        ///Wave 2
        let enemy4 = LB_Enemy(name: "enemy_iw", health: 45, hitBox: CGSize())
        let enemy5 = LB_Enemy(name: "enemy_iw", health: 45, hitBox: CGSize())
        
        let earthBolt = SpellCreator.init().getSpell(level: 7.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        let waterBolt = SpellCreator.init().getSpell(level: 8.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Water)
        
        enemy1.setSpells(spells: [earthBolt])
        enemy1.position = Position.TOP_CENTER
        
        enemy2.setSpells(spells: [earthBolt])
        enemy2.position = Position.TOP_RIGHT
        
        enemy3.setSpells(spells: [earthBolt])
        enemy3.position = Position.TOP_LEFT
        
        enemy4.setSpells(spells: [waterBolt])
        enemy4.position = Position.MIDDLE_LEFT
        
        enemy5.setSpells(spells: [waterBolt])
        enemy5.position = Position.MIDDLE_RIGHT
        
        let wave1 = [enemy1, enemy2, enemy3]
        let wave2 = [enemy4, enemy5]
        let enemyWave = [wave1, wave2]
        
        let level = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level
    }

}
