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
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_iw", health: 45, hitBox: CGSize())
        let enemy2 = LB_Enemy(name: "enemy_iw", health: 45, hitBox: CGSize())
        let enemy3 = LB_Enemy(name: "enemy_pw", health: 40, hitBox: CGSize())
        let enemy4 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        
        let earthBolt = SpellCreator.init().getSpell(level: 8.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        let waterBolt = SpellCreator.init().getSpell(level: 9.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Water)
        
        let fireDoT = SpellCreator.init().getSpell(level: 7.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        enemy1.setSpells(spells: [waterBolt])
        enemy1.position = Position.BOTTOM_LEFT
        
        enemy2.setSpells(spells: [waterBolt])
        enemy2.position = Position.BOTTOM_RIGHT
        
        enemy3.setSpells(spells: [earthBolt])
        enemy3.position = Position.BOTTOM_CENTER
        
        enemy4.setSpells(spells: [fireDoT])
        enemy4.position = Position.TOP_CENTER
        
        
        let wave1 = [enemy1, enemy2, enemy3, enemy4]
        let enemyWave = [wave1]
        
        let level = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level
    }
    
}
