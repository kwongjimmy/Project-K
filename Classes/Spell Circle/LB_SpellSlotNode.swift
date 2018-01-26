//
//  LB_SpellSlotNode.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 1/25/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

/// Sprite node of a specified spell
class LB_SpellSlotNode: SKSpriteNode {
    
    private var spell: LB_Spell
    private var maxCoolDownDuration: Float?
    private var onCoolDown: Bool = false
    private var coolDown: Float?
    private var spellAtlas: SKTextureAtlas = SKTextureAtlas(named: "spellicon")
    
    init(spell: LB_Spell, name: String) {
        self.spell = spell
        maxCoolDownDuration = spell.cooldown
        super.init(texture: spellAtlas.textureNamed(name), color: SKColor.black, size: CGSize(width: 100, height: 100))
        self.alpha = 0.80
        self.zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /// Gets the spell of the slot node.
    ///
    /// - Returns: spell information object.
    func getSpell() -> LB_Spell {
        return spell
    }

    /// - Returns: Bool status of if the spell is on cooldown
    func isOnCoolDown() -> Bool {
        return onCoolDown
    }
    
    /// Used for decrementing the cooldown timer
    private func decrementCoolDown() {
        coolDown? -= 0.125
        self.colorBlendFactor = CGFloat(1.0 * (coolDown! / maxCoolDownDuration!))
        if coolDown! <= 0.0 {
            stopCoolDown()
        }
    }
    
    func startCoolDown() {
        onCoolDown = true
        coolDown = spell.cooldown
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.125), SKAction.run(decrementCoolDown)])), withKey: "cooldown")
    }
    /// Used when cooldown has ended, removes label 
    private func stopCoolDown() {
        self.removeAction(forKey: "cooldown")
        self.colorBlendFactor = 0
        onCoolDown = false
    }
    
}
