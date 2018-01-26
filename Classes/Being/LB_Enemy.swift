//
//  LB_Enemy.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 3/20/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit


/// Enemy information object which inherits from Being object.
class LB_Enemy: LB_Being {
    private var spells: [LB_Spell]? //Contains the spells that the enemy will cast.
    private var _position: CGPoint? //Position in scene
    
    var position: CGPoint {
        get {
            return _position!
        }
        set(newPosition) {
            _position = newPosition
        }
    }
    
    /// Sets the spells the enemy will cast.
    ///
    /// - Parameter spells: Array of spells
    public func setSpells(spells: [LB_Spell]) {
        self.spells = spells
    }
    
    /// Gets the enemy spells
    ///
    /// - Returns: Array of enemy spells
    public func getSpells() -> [LB_Spell] {
        return spells!
    }
}
