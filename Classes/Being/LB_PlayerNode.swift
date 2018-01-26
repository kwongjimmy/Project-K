//
//  LB_PlayerNode.swift
//  Project K
//
//  Created by Jimmy Kwong on 1/17/17.
//  Copyright © 2017 Jimmy Kwong. All rights reserved.
//

import SpriteKit

extension CGPoint {
    
    /**
     Calculates a distance to the given point.
     
     :param: point - the point to calculate a distance to
     
     :returns: distance between current and the given points
     */
    func distance(point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}

/// For intializing the player node before being drawn to scene
class LB_PlayerNode: SKSpriteNode {
    
    private var player: LB_Player?
    private var battleManager: LB_BattleManager?
    
    /// Player movement
    private var lastBeforeTurnedPosition: CGPoint = CGPoint(x:0, y:-500);

    private var destinationLocation: CGPoint = CGPoint(x: 0, y: -500)
    private var canMove: Bool = true
    private var walkAtlas: SKTextureAtlas = SKTextureAtlas(named: "Walk")

    private var currentPosition: Int = 4
    private var wasIdle: Bool = true
    private var latestFrame: Int = 0
    
    private var previousDirection: Int = 4
    
    /// Player spell casting
    private var castTime: Float = 0
    private var finishCasting: Bool = true
    private var casting: Bool = false
    private var currentSpell: LB_Spell?
    private var spellLocation: CGPoint = CGPoint(x: 0, y: 0)
    private var controller: LB_SpellRingController?
    private var currentIndex: Int = 0
    
    /// Spell Ailment
    var statusAilments: [LB_Ailment]
    private var _silenced: Bool = false
    private var _blinded: Bool = false
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
    
    init(player: LB_Player) {
        self.player = player
        statusAilments = [LB_Ailment]()
        super.init(texture: walkAtlas.textureNamed("idle%204"), color: SKColor.clear, size: CGSize(width: 100, height: 100))
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.name = "player"
        setPhysics()
    }
    
    public func setBattleManager(battleManager: LB_BattleManager) {
        self.battleManager = battleManager
    }
    
    public func setSpellRingController(controller: LB_SpellRingController) {
        self.controller = controller
    }
    /// Setup the required physics for the node
    private func setPhysics() {
        self.zPosition = 3
        self.position = CGPoint(x: 0, y: -500)
//        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height/3.5, center: CGPoint(x: 20, y: 0))
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: 100, height: 100))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        self.physicsBody?.categoryBitMask = ColliderType.Player
        self.physicsBody?.contactTestBitMask = ColliderType.Spell
    }
    
    /**
        Begin initializing the required parameters for casting a spell.
     
        - Parameter:
            - spell: The spell that will be casted
            - spellLocation: The position where the spell will begin on.
            - spellRingController: Access to spellRingController for alerting after casting is complete.
     */
    /// Begin initializing the required parameters for casting a spell.
    ///
    /// - Parameters:
    ///   - spell: The spell to be casted
    ///   - spellLocation: The location where its moving towards.
    ///   - spellRingController: Access to spellRingController for alerting after casting is complete.
    func beginCastingSpell(spell: LB_Spell, spellLocation: CGPoint) {
        if !silenced {
            stopPlayerWalkingAnimation()
            stopPlayerDisplacementAnimation()
            canMove = false /// Set movement parameter to false to prevent movement.
            currentSpell = spell
            currentIndex = (controller?.getCurrentIndex())!
            self.spellLocation = spellLocation
            castTime = spell.castTime
            
            /// SK Actions for counting down the casting timer for casted spell.
            self.run(SKAction.sequence([SKAction.wait(forDuration: Double(castTime)), SKAction.run(completeCastingSpell)]))
        }
    }
    
    /** 
        Finishes the casting cycle by creating, adding SKActions onto the node and placing it onto the node.
     */
    private func completeCastingSpell() {
        
        /// Create casted spell onto the scene.
        let castingSpell = LB_SpellNode(spell: currentSpell!, type: "player")
        castingSpell.weakenedAmount = weakenAmount
        /// SKAction for spell movement
        let action = SKAction.move(to: spellLocation, duration: 2)
        
        /// Setting spawn position to be few pixels in front of player.
        castingSpell.position = CGPoint(x: self.position.x, y: self.position.y+40)
        castingSpell.zRotation = getSpellPosition()
        castingSpell.run(action)
        
        /// Alert controller to begin creating a cooldown label node for casted spell.
        if (battleManager?.addSpell(spell: castingSpell))! {
            controller?.setSpellSlotStatus(spellIndex: currentIndex)
            scene?.addChild(castingSpell)
        }
        canMove = true /// Allow movement again.
    }
    
    func isCasting() -> Bool {
        if canMove { return false }
        else { return true }
    }
    
    func cancelCasting() {
        self.removeAllActions()
        canMove = true
    }
    
    /// Gets the angle that the player should be facing based on the location it is moving towards.
    ///
    /// - Parameter location: The location the player is moving towards.
    /// - Returns: An integer of the angle.
    private func getPosition(location: CGPoint) -> Int {
        
        let dx = Float(location.x - self.position.x)
        let dy = Float(location.y - self.position.y)
        
//        let dx = Float(location.x - lastBeforeTurnedPosition.x)
//        let dy = Float(location.y - lastBeforeTurnedPosition.y)

        let theta = atan2f(dy, dx)
        var angle = theta * 180 / Float(Double.pi)
        if angle < 0 {
            angle += 360
        }
        angle = round(angle / 22.5)
        if angle == 16{
            angle = 0
        }
        return Int(angle)
    }
    
    public func getPlayer() -> LB_Player {
        return player!
    }
    
    private func getSpellPosition() -> CGFloat {
        let dx = Float(spellLocation.x - self.position.x)
        let dy = Float(spellLocation.y - self.position.y)
        
        let theta = atan2f(dy, dx)
        return CGFloat(theta + .pi)
    }
    
    /**
        Generates a SKAction animation cycle for the player.
     
        - Parameter action: The name of the action the player is doing.
     
        Returns: The animation cycle of the determined action.
     */
    private func getAnimation(action: String) -> SKAction {
        
        /// If was idle, then animation manipulation is not requred.
//        if action == "walk" {
            if !wasIdle {
                // String manipulation to retrieve current frame of texture animation...
                //Description Example: "<SKTexture> \'walk7%201.png\' (89 x 126)"
                let description = self.texture?.description
                
                //It breaks down the description string into 3 components
                var darray = description?.components(separatedBy: "'")
                
                //It uses the second components of the array at index 1, the sprite name string
                //and se
                darray = darray?[1].components(separatedBy: "%20")
                darray = darray?[1].components(separatedBy: ".")
                
                /// Current frame of animation
                let frameIndex = Int((darray?[0])!)
                latestFrame = frameIndex!
            }
            
            /// Next animation loop will begin one frame ahead of current loop to provide decent transition.
            var animationArray = [SKTexture]()
            
            // #14 is from the numbers of frames this specific sprite(asset) has.
            if latestFrame == 14 {
                for i in 0...latestFrame {
                    animationArray.append(walkAtlas.textureNamed("walk\(currentPosition)%20\(i).png"))
                }
            } else {
                for i in latestFrame + 1...14 {
                    animationArray.append(walkAtlas.textureNamed("walk\(currentPosition)%20\(i).png"))
                }
                for i in 0...latestFrame {
                    animationArray.append(walkAtlas.textureNamed("walk\(currentPosition)%20\(i).png"))
                }
                //print(animationArray);
            }
        
        
        return SKAction.repeatForever(SKAction.animate(with: animationArray, timePerFrame: 1/15))
//        }
    }
    
    
    private func comparePosition(playerpos: CGPoint, destpos: CGPoint) -> Bool {
        let playerposx = round(100 * playerpos.x) / 100
        let playerposy = round(100 * playerpos.y) / 100
        let player = CGPoint(x: playerposx, y: playerposy)
        
        let destposx = round(destpos.x * 100) / 100
        let destposy = round(destpos.y * 100) / 100
        let dest = CGPoint(x: destposx, y: destposy)
        if(player == dest) {
            return true
        }
        else {
//            print("player:\(player)")
//            print("dest:\(dest)")
            return false
        }
    }
    /**
        Movement function for the player. It will generate animation that correlates to the given location.
     
        - Parameter:
            - location: The position player will be moving towards to.
     */
    func move(to location: CGPoint) {
        
        /// If stunned stop all movement animations
        if silenced {
            stopPlayerWalkingAnimation()
            stopPlayerDisplacementAnimation()
        }
        
        /// If player isn't moving, change sprite to idle
        if (comparePosition(playerpos: self.position, destpos: destinationLocation) || !canMove) && (!wasIdle) {
            stopPlayerDisplacementAnimation()
            stopPlayerWalkingAnimation()
            wasIdle = true
            currentPosition = getPosition(location: location)
            previousDirection = currentPosition
            self.texture = walkAtlas.textureNamed("idle%204.png")
            latestFrame = 0
            return
        }
        
        currentPosition = getPosition(location: location)

        if ((!silenced && canMove) && (previousDirection != currentPosition || location != destinationLocation)) {
            
            if location != destinationLocation {
                lastBeforeTurnedPosition = location;

                let distanceBetween2Locations : Double = Double(self.position.distance(point: location))

                let action = SKAction.move(to: location, duration: distanceBetween2Locations / ((player?.movementSpeed)!) * Double(1 + (slowedAmount / 100)))
                stopPlayerDisplacementAnimation()
                self.run(action, withKey: "move")
                
                let walk = getAnimation(action: "walk")
                stopPlayerWalkingAnimation()
                self.run(walk, withKey: "walk")
            }

            destinationLocation = location
            previousDirection = currentPosition
            wasIdle = false
        }
    }
    
    func stopPlayerDisplacementAnimation() {
        self.removeAction(forKey: "move")
    }
    
    func stopPlayerWalkingAnimation() {
        self.removeAction(forKey: "walk")
    }
    
    /// Decrease player information object's health
    ///
    /// - Parameter damage: Damage taken
    func decrementHealth(damage: Float) {
//        print((damage * (1 + (shockAmount / 100))))
        player?.currentHealth = (player?.currentHealth)! - (damage * (1 + (shockAmount / 100)))
        controller?.updateHealthRing()
    }

    /// Begin process of decrementing debuffs.
    func beginUpdatingStatusAilment() {
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.125),SKAction.run(updateStatusAilment)])))
    }
    
    /// Decrement each debuff and alert BM the changes.
    private func updateStatusAilment() {
//        print(statusAilments)
        if statusAilments.count > 0 {
            for i in (0...statusAilments.count-1).reversed() {
                let status = statusAilments[i]
                status.decrementRemainingTime(time: 0.25)
                battleManager?.updatePlayerAilmentStatus(ailment: status, ailmentIndex: i)
            }
        }
    }
}
