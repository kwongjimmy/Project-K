//
//  LB_ActionEvent.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/11/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import Foundation

/// Event that holds the player/enemy debuff information.
class LB_ActionEvent {
    private var type: String? /// For state machine to distinguish between player/enemy event.
    private var spell: LB_Spell?
    private var player: LB_PlayerNode?
    private var enemy: LB_EnemyNode?
    private var ailment: LB_Ailment?
    
    init(spell: LB_Spell, player: LB_PlayerNode) {
        self.spell = spell
        self.player = player
        type = "player"
        generateAilment()
        applyIntialEffect()
    }
    
    init(spell: LB_Spell, enemy: LB_EnemyNode) {
        self.spell = spell
        self.enemy = enemy
        type = "enemy"
        generateAilment()
        applyIntialEffect()
    }
    
    
    /// The bottom 2 initializers are used for a ailment removal event. When the debuff timer has reached 0.

    init(ailment: LB_Ailment, enemy: LB_EnemyNode) {
        self.ailment = ailment
        self.enemy = enemy
        type = "enemy"
    }
    
    init(ailment: LB_Ailment, player: LB_PlayerNode) {
        self.ailment = ailment
        self.player = player
        type = "player"
    }
    
    /// Action Event will create a ailment type for state machine and battle manager to process.
    private func generateAilment() {
        ailment = LB_Ailment(type: (spell?.spellType)!, effect: (spell?.effect)!)
    }
    
    /// Upon collision with spell, if the spell type is Stun/Stun (for now..) it will apply initial changes to the beings instantly.
    private func applyIntialEffect() {
        if ailment?.getType() == LB_Spell.SpellType.Silence {
            if type == "player" {
                print("player silenced")
                player?.silenced = true
            } else {
                enemy?.silenced = true
                enemy?.stopCastingSpell()
            }
        } else if ailment?.getType() == LB_Spell.SpellType.Slow {
            if type == "player" {
                player?.slowedAmount = (spell?.effect.value)!
            }
            else {
                enemy?.slowedAmount = (spell?.effect.value)!
            }
        } else if ailment?.getType() == LB_Spell.SpellType.Weaken {
            if type == "player" {
                player?.weakenAmount = (spell?.effect.value)!
            }
            else {
                print("enemy weaken")
                enemy?.weakenAmount = (spell?.effect.value)!
            }
        } else if ailment?.getType() == LB_Spell.SpellType.Shock {
            if type == "player" {
                player?.shockAmount = (spell?.effect.value)!
            }
            else {
                print("enemy shocked")
                enemy?.shockAmount = (spell?.effect.value)!
            }
        } else if ailment?.getType() == LB_Spell.SpellType.Blind {
            if type == "player" {
                player?.blinded = true
            }
            else {
                print("enemy blinded")
                enemy?.blinded = true
            }
        } else if ailment?.getType() == LB_Spell.SpellType.Confuse {
            if type == "player" {
            } else {
                print("enemy confused")
                enemy?.confused = true
            }
        }
    }
    
    /// Used when the action event is a removal type.
    ///
    /// - Returns: True when the modifies inflicted to beings are back to default.
    func removeEffect() -> Bool{
        if ailment?.getType() == LB_Spell.SpellType.Silence {
            if type == "player" {
                player?.silenced = false
            } else {
                enemy?.silenced = false
                enemy?.beginCastingSpell()
            }
            return true
        } else if ailment?.getType() == LB_Spell.SpellType.Slow {
            if type == "player" {
                player?.slowedAmount = 0
            }
            else {
                enemy?.slowedAmount = 0
            }
            return true
        } else if ailment?.getType() == LB_Spell.SpellType.DoT {
            return true
        } else if ailment?.getType() == LB_Spell.SpellType.Weaken {
            if type == "player" {
                player?.weakenAmount = 0
            }
            else {
                enemy?.weakenAmount = 0
            }
            return true
        } else if ailment?.getType() == LB_Spell.SpellType.Shock {
            if type == "player" {
                player?.shockAmount = 0
            }
            else {
                enemy?.shockAmount = 0
            }
            return true
        } else if ailment?.getType() == LB_Spell.SpellType.Blind {
            if type == "player" {
                player?.blinded = false
            }
            else {
                enemy?.blinded = false
            }
            return true
        } else if ailment?.getType() == LB_Spell.SpellType.Confuse {
            if type == "player" {
            } else {
                enemy?.confused = false
            }
            return true
        }
        else {
            return false
        }
    }
    
    /// Retrieve ailment object from the event itself.
    ///
    /// - Returns: LB_Ailment
    func getAilment() -> LB_Ailment {
        return ailment!
    }
    
}
