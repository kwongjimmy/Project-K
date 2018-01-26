//
//  LB_EnemyNode.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 3/24/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit

/// The node object in charge of animations, actions for the enemy information object.
class LB_EnemyNode: SKSpriteNode {
    
    private var enemy: LB_Enemy?
    private var battleManager: LB_BattleManager?
    private var enemyIdleAtlas: SKTextureAtlas?
    private var currentSpell: LB_Spell?
    
    /// Health bar
    private var barWidth: CGFloat = 60
    private var barHeight: CGFloat = 15
    private var outline = SKShapeNode()
    private var fill = SKShapeNode()
    private var factor: Float = 0.5
    
    ///
    private var blink = false
    private var onHit = false
    
    /// Spell Ailment
    var statusAilments: [LB_Ailment]
    private var _silenced: Bool = false
    private var _blinded: Bool = false
    private var _confused: Bool = false
    private var _slowedAmount: Float = 0
    private var _weakenAmount: Float = 0
    private var _shockAmount: Float = 0
    
    var silenced: Bool {
        get {
            return _silenced
        }
        set(newSilenced) {
            _silenced = newSilenced
        }
    }
    
    var blinded: Bool {
        get {
            return _blinded
        }
        set(newBlinded) {
            _blinded = newBlinded
        }
    }
    
    var confused: Bool {
        get {
            return _confused
        }
        set(newConfused) {
            _confused = newConfused
        }
    }
    
    var slowedAmount: Float {
        get {
            return _slowedAmount
        }
        set(newSlowedAmount) {
            _slowedAmount = newSlowedAmount
        }
    }
    
    var weakenAmount: Float {
        get {
            return _weakenAmount
        }
        set(newWeakenAmount) {
            _weakenAmount = newWeakenAmount
        }
    }
    
    var shockAmount: Float {
        get {
            return _shockAmount
        }
        set(newShockAmount) {
            _shockAmount = newShockAmount
        }
    }
    
    /// Initalization of the enemy node object.
    ///
    /// - Parameter enemy: Requires enemy information object.
    init(enemy: LB_Enemy) {
        statusAilments = [LB_Ailment]()
        super.init(texture: SKTexture(imageNamed: "\(enemy.name)_idle_1"), color: SKColor.clear, size: CGSize(width: 100, height: 100))
        self.enemy = enemy
        self.name = "enemy"
        enemyIdleAtlas = SKTextureAtlas.init(named: "\(enemy.name)_idle")
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        setupPhysics()
        setupAnimation()
        currentSpell = enemy?.getSpells()[0]
    }
    
    /// Give enemy the reference to the battle manager.
    ///
    /// - Parameter battleManager: battle manager reference.
    public func setBattleManager(battleManager: LB_BattleManager) {
        self.battleManager = battleManager
    }
    
    
    /// Gets the enemy information object.
    ///
    /// - Returns: enemy object
    public func getEnemy() -> LB_Enemy {
        return enemy!
    }
    
    /// Setups the SKPhysics of the enemy.
    private func setupPhysics() {
        self.zPosition = 1
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: 100, height: 100))
        self.xScale = 1.10
        self.yScale = 1.10
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        self.physicsBody?.categoryBitMask = ColliderType.Enemy
        self.physicsBody?.contactTestBitMask = ColliderType.Spell
    }
    
    /// Setups the animation of the enemy.
    private func setupAnimation() {
        var animationArray = [SKTexture]()
        let animationAtlasArray = enemyIdleAtlas?.textureNames.sorted()
        for i in 0..<(animationAtlasArray?.count)! {
            animationArray.append(SKTexture(imageNamed: (animationAtlasArray?[i])!))
        }
        self.run(SKAction.repeatForever(SKAction.animate(with: animationArray, timePerFrame: 1)))
    }
    

    /// Enemy will begin casting spell to player positions at a set interval.
    public func beginCastingSpell() {
        // TODO: Duration based on cast speed + cooldown
        let sequence = SKAction.sequence([SKAction.wait(forDuration: Double((currentSpell?.castTime)!)), SKAction.run(castSpell), SKAction.wait(forDuration: Double((currentSpell?.cooldown)!))])
        self.run(SKAction.repeatForever(sequence), withKey: "cast")
    }
    
    public func stopCastingSpell() {
        self.removeAction(forKey: "cast")
    }
    
    private func castSpell() {
        if !silenced {
            let castingSpell = LB_SpellNode(spell: (enemy?.getSpells()[0])!, type: "enemy")
            castingSpell.weakenedAmount = weakenAmount
            // Spawn the spell in front of being
            castingSpell.position = CGPoint(x: self.position.x, y: self.position.y)
            // Calculate the direction it is traveling towards
            var spellDestination: CGPoint = CGPoint(x: 0, y: 0)
            if blinded {
                spellDestination = (CGPoint(x: self.position.x, y: self.position.y - 550) - self.position).normalized() * 1000 + CGPoint(x: self.position.x, y: self.position.y - 550)
            }
            else if confused {
//                print("hit self")
//                castingSpell.type = "player"
//                let randomPos = battleManager!.getRandomEnemyPos()
//                castingSpell.position = CGPoint(x: self.position.x, y: self.position.y)
//                spellDestination = (randomPos - castingSpell.position).normalized() * 1000 + randomPos
                /// Enemy will hit itself
                decrementHealth(damage: (enemy?.getSpells()[0].damage)!)
                battleManager?.checkEnemyStatus(enemyNode: self)
                return
            } else {
                spellDestination = ((battleManager?.getPlayerPosition())! - self.position).normalized() * 1250 + (battleManager?.getPlayerPosition())!
            }
            
            // TODO: Duration based on missile speed
            let action = SKAction.move(to: spellDestination, duration: TimeInterval(3 + castingSpell.getSpell().missileSpeed))
            let createSpell = SKAction.run({
                // Check if battle manager and statemachine registeration was sucessful
                if (self.battleManager?.addSpell(spell: castingSpell))! {
                    castingSpell.run(action)
                    castingSpell.zRotation = self.getSpellPosition(spellLocation: (self.battleManager?.getPlayerPosition())!)
                    self.scene?.addChild(castingSpell)
                }
            })
            self.run(createSpell)
        }
    }
    
    private func getSpellPosition(spellLocation: CGPoint) -> CGFloat {
        let dx = Float(spellLocation.x - self.position.x)
        let dy = Float(spellLocation.y - self.position.y)
        
        let theta = atan2f(dy, dx)
        return CGFloat(theta + .pi)
    }
    
    /// Initialize and draw the health bar of the enemy.
    func drawHealthBar() {
        outline = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight))
        outline.lineWidth = 2
        outline.fillColor = UIColor.clear
        outline.strokeColor = UIColor.black
        outline.zPosition = 2
        outline.position = CGPoint(x: 0, y: 50)
        
        fill = SKShapeNode(rectOf: CGSize(width: barWidth, height: barHeight))
        fill.lineWidth = 0
        fill.zPosition = 1
        
        self.addChild(outline)
        self.addChild(fill)
        updateHealthBar()
    }
    
    /// Updates the healthbar for the enemy.
    private func updateHealthBar() {
        let healthRatio = (enemy?.currentHealth)! / (enemy?.maxHealth)!
        let fillWidth = CGFloat((healthRatio * Float(barWidth)) - Float(outline.lineWidth) + 1)
        let fillRect = CGRect(x: outline.frame.minX+outline.lineWidth, y: outline.frame.minY+outline.lineWidth, width: fillWidth, height: CGFloat(barHeight))
        let path = UIBezierPath(rect: fillRect)
        fill.path = path.cgPath
        
        if healthRatio < factor {
            fill.fillColor = UIColor(colorLiteralRed: factor, green: healthRatio, blue: 0, alpha: 1.0)
        } else {
            fill.fillColor = UIColor(colorLiteralRed: 1 - healthRatio, green: factor, blue: 0, alpha: 1.0)
        }
    }
    
//    private func onHitBlink() {
//        if blink == false {
//            self.color = UIColor.gray
//            self.colorBlendFactor = 0.5
//            blink = true
//        } else {
//            self.colorBlendFactor = 0.0
//            blink = false
//        }
//    }
//    
//    private func onHitToggle() {
//        if onHit {
//            onHit = false
//        } else {
//            onHit = true
//        }
//    }
    
    /// Decrease enemy health, will be used in conjunction with updateHealthBar()
    ///
    /// - Parameter damage: Damage taken
    func decrementHealth(damage: Float) {
        enemy?.currentHealth = (enemy?.currentHealth)! - (damage * (1 + (shockAmount / 100)))
        updateHealthBar()
//        if !onHit {
//            let action = SKAction.sequence([SKAction.run(onHitBlink), SKAction.wait(forDuration: 0.10)])
//            self.run(SKAction.sequence([SKAction.run(onHitToggle), SKAction.repeat(action, count: 10), SKAction.run(onHitToggle)]), withKey: "blink")
//        }
    }
    
    /// This will begin running the SKAction where it will decrement the debuff timers.
    func beginUpdatingStatusAilment() {
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.25),SKAction.run(updateStatusAilment)])))
    }
    
    private func updateStatusAilment() {
//        print(statusAilments)
        if statusAilments.count > 0 {
            for i in (0...statusAilments.count-1).reversed() {
                let status = statusAilments[i]
                status.decrementRemainingTime(time: 0.25)
                battleManager?.updateEnemyAilmentStatus(ailment: status, ailmentIndex: i, enemy: self)
            }
        }
    }
    
}
