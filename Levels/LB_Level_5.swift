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
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        let enemy2 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        let enemy3 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        
        /// Wave 2
        let enemy4 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        let enemy5 = LB_Enemy(name: "enemy_fw", health: 30, hitBox: CGSize())
        
        /// Wave 3
        let enemy6 = LB_Enemy(name: "enemy_pw", health: 40, hitBox: CGSize())
        
        let fireball = SpellCreator.init().getSpell(level: 4.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 3.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        let earthBolt = SpellCreator.init().getSpell(level: 3.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        enemy1.setSpells(spells: [fireball])
        enemy1.position = Position.MIDDLE_LEFT
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.MIDDLE_RIGHT
        
        enemy3.setSpells(spells: [fireDoT])
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
        
        let level = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level
    }
}
