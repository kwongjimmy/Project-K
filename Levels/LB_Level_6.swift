//
//  LB_Level_6.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/27/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_6: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_fw", health: 35, hitBox: CGSize())
        let enemy2 = LB_Enemy(name: "enemy_fw", health: 35, hitBox: CGSize())
        let enemy3 = LB_Enemy(name: "enemy_fw", health: 35, hitBox: CGSize())
        
        /// Wave 2
        let enemy4 = LB_Enemy(name: "enemy_fw", health: 40, hitBox: CGSize())
        let enemy5 = LB_Enemy(name: "enemy_fw", health: 40, hitBox: CGSize())
        let enemy6 = LB_Enemy(name: "enemy_pw", health: 45, hitBox: CGSize())
        
        let fireball = SpellCreator.init().getSpell(level: 5.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 4.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        let earthBolt = SpellCreator.init().getSpell(level: 4.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        enemy1.setSpells(spells: [fireball])
        enemy1.position = Position.MIDDLE_LEFT
        
        enemy2.setSpells(spells: [fireball])
        enemy2.position = Position.MIDDLE_RIGHT
        
        enemy3.setSpells(spells: [fireDoT])
        enemy3.position = Position.BOTTOM_CENTER
        
        enemy4.setSpells(spells: [fireball])
        enemy4.position = Position.BOTTOM_LEFT
        
        enemy5.setSpells(spells: [fireDoT])
        enemy5.position = Position.MIDDLE_RIGHT
        
        enemy6.setSpells(spells: [earthBolt])
        enemy6.position = Position.TOP_CENTER
        
        let wave1 = [enemy1, enemy2, enemy3]
        let wave2 = [enemy4, enemy5, enemy6]
        let enemyWave = [wave1,wave2]
        
        let level = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level
    }
}
