//
//  LB_Ailment.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 4/16/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import Foundation

/// Debuff information object
class LB_Ailment {
    
    private var type: LB_Spell.SpellType? /// Used to distinguish the type of debuff it is.
    private var effect: LB_Spell.effect? /// Effect object that has the duration and value application information.
    private var duration: Float?
    private var remainingDuration: Float?
    
    init(type: LB_Spell.SpellType, effect: LB_Spell.effect) {
        self.type = type
        self.effect = effect
        self.duration = effect.duration
        self.remainingDuration = duration
    }
    
    func getType() -> LB_Spell.SpellType {
        return type!
    }
    
    func getEffect() -> LB_Spell.effect {
        return effect!
    }
    
    /// Decrements the remaining debuff time
    ///
    /// - Parameter time: The amount of time it is decreasing by.
    func decrementRemainingTime(time: Float) {
        remainingDuration = remainingDuration! - time
    }
    
    /// Battle manager will check if the current debuff (DoT atm) will proc.
    ///
    /// - Returns: True if it is proccing, else false.
    func onTick() -> Bool {
        if remainingDuration!.truncatingRemainder(dividingBy: 1.0) == 0 {
            return true
        } else {
            return false
        }
    }
    
    /// Used to get the status of the debuff (Completed/InCompleted)
    ///
    /// - Returns: True when the debuff has ran out of time, else false.
    func getStatus() -> Bool {
        if remainingDuration! > Float(0) {
            return true
        } else {
            return false
        }
    }
}
