//
//  LB_SpellRingController.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 1/25/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

/// Controller for the spell ring class
class LB_SpellRingController {
    
    private var spellRing: LB_SpellRing
    private var spellSlotArray: [LB_SpellSlotNode]
    private var spellIndex = 0
    
    init(spellRing: LB_SpellRing) {
        self.spellRing = spellRing
        self.spellSlotArray = spellRing.getSpellSlotArray()
    }
    
    
    /// Updates the spell ring location.
    ///
    /// - Parameter newLocation: The new location of the spell ring.
    func updateSpellRingLocation(newLocation: CGPoint) {
        spellRing.spellRingLocation = newLocation
    }
    
    /**
        Tells the spell ring class to rotate to the indicated spell index
        - Parameter spellNumber: the new primary spell for rotation
     */
    /// Informs the spell ring class to rotate to the specific location based on player interaction.
    ///
    /// - Parameter spellNumber: The spell number it is rotating towards.
    func rotate(spellNumber: Int) {
        /// Don't rotate if user is clicking on the same primary spell.
        if spellNumber == spellIndex {
        } else {
            spellIndex = spellNumber
            spellRing.rotate(spellIndex: spellNumber)
        }
    }
    
    /// Informs the spell ring class to rotate clock-wise once.
    func rotate() {
        spellRing.rotate()
    }
    
    /// Begins the cooldown of the current selected spell slot.
    func setSpellSlotStatus(spellIndex: Int) {
        spellRing.rotate()
        spellSlotArray[spellIndex].startCoolDown()
        updateNextSpell()
    }
    
    /// Increments the spell index for the next spell.
    func updateNextSpell() {
        if spellIndex == spellSlotArray.count - 1 {
            spellIndex = 0
        } else {
            spellIndex += 1
        }
    }
    
    /// Move the spell ring to the player node's location in the battle scene.
    ///
    /// - Parameter playerPosition: The player's current position.
    func moveSpellRingToPlayer(playerPosition: CGPoint) {
        spellRing.moveTo(playerPosition: playerPosition)
    }
    
    /// - Returns the cooldown status of the current spellslot 
    func getSpellSlotStatus() -> Bool {
        return spellSlotArray[self.spellIndex].isOnCoolDown()
    }
    
    /// - Returns: SpellSlotArray size
    func getSpellSlotArraySize() -> Int {
        return spellRing.getSpellSlotArray().count
    }
    
    /// Gets the current primary spell index.
    ///
    /// - Returns: The primary spell index.
    func getCurrentIndex() -> Int {
        return spellIndex
    }
    
    /// Gets the primary spell.
    ///
    /// - Returns: The primary spell information object.
    func getCurrentSpell() -> LB_Spell {
        return spellRing.getSpellSlotArray()[spellIndex].getSpell()
    }
    
    func getSpellRing() -> LB_SpellRing {
        return spellRing
    }
    
    func updateHealthRing() {
        spellRing.updateHealthRing()
    }
}
