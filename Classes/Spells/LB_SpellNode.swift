//
//  LB_SpellNode.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 1/25/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

/// Spell node object that is in charge of animation and physics of a spell.
class LB_SpellNode: SKSpriteNode {
    
    private var spell: LB_Spell
    private var hitBox: CGSize
    private var spellAnimation =  SKAction()
    private var spellParticles = SKEmitterNode()
    private var spellAtlas: SKTextureAtlas = SKTextureAtlas(named: "spells")
    private var _type: String
    private var _weakenedAmount: Float = 0
    /// Type contains the infomration of whether a player casted it or enemy.
    var type: String {
        get {
            return _type
        }
        set(newType) {
            _type = newType
            setupPhysics()
        }
    }
    
    var weakenedAmount: Float  {
        get {
            return _weakenedAmount
        }
        set(newWeakenedAmount) {
            _weakenedAmount = newWeakenedAmount
        }
    }

    /// Initialization of spell node.
    ///
    /// - Parameters:
    ///   - spell: the spell information object
    ///   - type: player/enemy type
    init(spell: LB_Spell, type: String) {
        self.spell = spell
        self.hitBox = spell.hitBox
        self._type = type
        super.init(texture: spellAtlas.textureNamed("\(spell.name)bolt_1"), color: SKColor.clear, size: CGSize(width: 205, height: 79))
        self.name = "spell"
        setupPhysics()
        setupAnimation()
    }
    
    private func setupPhysics() {
        self.zPosition = 4
//        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/7.25, center: CGPoint(x: -75, y: -15))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.zRotation = .pi/2
        self.size = CGSize(width: self.size.width * CGFloat(1 + (Double(spell.level) * 5)/100), height: self.size.height * CGFloat(1 + (Double(spell.level) * 6.25)/100))
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.Spell
        self.physicsBody?.collisionBitMask = 0
        if type == "enemy" {
            self.physicsBody?.contactTestBitMask = ColliderType.Player
        } else if type == "player" {
            self.physicsBody?.contactTestBitMask = ColliderType.Enemy
        } else {
            self.physicsBody?.contactTestBitMask = 0
        }

    }
    
    /// Gets the spell information object.
    ///
    /// - Returns: spell information object.
    public func getSpell() -> LB_Spell {
        return spell
    }
    
    private func setupAnimation() {
        var animationArray = [SKTexture]()
        for i in 1...6 {
            animationArray.append(spellAtlas.textureNamed("\(spell.name)bolt_\(i)"))
        }
        let animation = SKAction.animate(with: animationArray, timePerFrame: TimeInterval(0.25), resize: false, restore: false)
        self.run(SKAction.repeatForever(animation))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
