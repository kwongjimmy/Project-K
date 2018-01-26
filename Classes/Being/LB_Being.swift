//
//  LB_Being.swift
//  Project K
//
//  Created by Jimmy Kwong on 1/17/17.
//  Copyright © 2017 Jimmy Kwong. All rights reserved.
//

import SpriteKit

/// Characteristics for initializing and creaitng a being
class LB_Being {
    
    private var _level: Float?
    private var _name: String?
    private var _maxHealth: Float?
    private var _currentHealth: Float?
    private var _isAlive: Bool = true
    
    var level: Float {
        get {
            return _level!
        }
        set(newLevel) {
            _level = newLevel
        }
    }
    
    /// Setter and getter for name
    var name: String {
        get {
            return _name!
        }
        set(newName) {
            _name = newName
        }
    }
    
    /// Setter and getter for health
    var maxHealth: Float {
        get {
            return _maxHealth!
        }
        set(newHealth) {
            _maxHealth = newHealth
        }
    }
    
    /// Setter and getter for health
    var currentHealth: Float {
        get {
            return _currentHealth!
        }
        set(newHealth) {
            if newHealth <= 0 {
                _currentHealth = 0
                isAlive = false
            } else {
                _currentHealth = newHealth
            }
        }
    }
    
    /// Setter and getter for alive status
    var isAlive: Bool {
        get {
            return _isAlive
        }
        set(isAlive) {
            _isAlive = isAlive
        }
    }
    
    init(name: String, level: Float) {
        _name = name
        _maxHealth = 20.0 + 1.25 * level
        _currentHealth = maxHealth
        _isAlive = isAlive
    }
}
