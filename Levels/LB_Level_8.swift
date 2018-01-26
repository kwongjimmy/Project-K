//
//  LB_Level_8.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/27/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

class LB_Level_8: LB_BattleScene {
    
    override func getLevelInfo() -> LB_BattleManager.Level {
        /// Player
        let player = LB_Player(name: "Player", health: 100, hitBox: CGSize())
        
        /// Wave 1
        let enemy1 = LB_Enemy(name: "enemy_pw", health: 45, hitBox: CGSize())
        let enemy2 = LB_Enemy(name: "enemy_pw", health: 45, hitBox: CGSize())
        let enemy3 = LB_Enemy(name: "enemy_pw", health: 45, hitBox: CGSize())
        
        /// Wave 2
        let enemy4 = LB_Enemy(name: "enemy_fw", health: 40, hitBox: CGSize())
        let enemy5 = LB_Enemy(name: "enemy_fw", health: 40, hitBox: CGSize())
        let enemy6 = LB_Enemy(name: "enemy_fw", health: 40, hitBox: CGSize())
        
        /// Wave 3
        let enemy7 = LB_Enemy(name: "enemy_fw", health: 20, hitBox: CGSize())
        let enemy8 = LB_Enemy(name: "enemy_pw", health: 20, hitBox: CGSize())
        let enemy9 = LB_Enemy(name: "enemy_pw", health: 20, hitBox: CGSize())
        let enemy10 = LB_Enemy(name: "enemy_fw", health: 20, hitBox: CGSize())
        
        let earthBolt = SpellCreator.init().getSpell(level: 7.0, spellType: LB_Spell.SpellType.Shock, elementType: LB_Spell.ElementType.Earth)
        
        let fireball = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.Damage, elementType: LB_Spell.ElementType.Fire)
        
        let fireDoT = SpellCreator.init().getSpell(level: 6.0, spellType: LB_Spell.SpellType.DoT, elementType: LB_Spell.ElementType.Fire)
        
        enemy1.setSpells(spells: [earthBolt])
        enemy1.position = Position.TOP_CENTER
        
        enemy2.setSpells(spells: [earthBolt])
        enemy2.position = Position.MIDDLE_RIGHT
        
        enemy3.setSpells(spells: [earthBolt])
        enemy3.position = Position.BOTTOM_CENTER
        
        enemy4.setSpells(spells: [fireDoT])
        enemy4.position = Position.TOP_LEFT
        
        enemy5.setSpells(spells: [fireball])
        enemy5.position = Position.TOP_CENTER
        
        enemy6.setSpells(spells: [fireDoT])
        enemy6.position = Position.TOP_RIGHT
        
        enemy7.setSpells(spells: [fireDoT])
        enemy7.position = Position.BOTTOM_CENTER
        
        enemy8.setSpells(spells: [earthBolt])
        enemy8.position = Position.MIDDLE_LEFT
        
        enemy9.setSpells(spells: [earthBolt])
        enemy9.position = Position.TOP_CENTER
        
        enemy10.setSpells(spells: [fireball])
        enemy10.position = Position.MIDDLE_RIGHT
        
        let wave1 = [enemy1, enemy2, enemy3]
        let wave2 = [enemy4, enemy5, enemy6]
        let wave3 = [enemy7, enemy8, enemy9, enemy10]
        
        let enemyWave = [wave1, wave2, wave3]
        
        let level = LB_BattleManager.Level(player: player, enemyWaves: enemyWave, waves: enemyWave.count)
        return level
    }
}
