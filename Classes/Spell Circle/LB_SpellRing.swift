//
//  LB_SpellRing.swift
//  Project LightBringers
//
//  Created by Jimmy Kwong on 1/25/17.
//  Copyright © 2017 Team K. All rights reserved.
//

import SpriteKit


/// Responsible for intializing and displaying the spell ring.
class LB_SpellRing: SKSpriteNode{
    
    private var spellSlotArray: [LB_SpellSlotNode]?
    private var _spellRingLocation = CGPoint()
    private var currentIndex = 0 //Current primary spell index
    private var arrayOfPoints = [CGPoint]()
    
    /// Health Ring
    private var healthRing = SKShapeNode()
    private var healthRatio: Double = 0.0
    private var factor: Double = 0.5
    private var radius = CGFloat(100)
    private let fullCircle = Double.pi * 2.0
    private let startingAngle = Double.pi/2.0
    
    private let battleManager: LB_BattleManager?
    private var player: LB_Player?

    
    /// Setter and getter for the position of the spell ring
    var spellRingLocation: CGPoint {
        get {
            return _spellRingLocation
        }
        set(newLocation) {
            _spellRingLocation = newLocation
            self.position = _spellRingLocation
        }
    }
    
    init(slotArray: [LB_SpellSlotNode],battleManager: LB_BattleManager) {
        self.battleManager = battleManager
        self.spellSlotArray = slotArray
        super.init(texture: SKTexture(imageNamed : "circle2.png"), color: SKColor.clear, size: CGSize(width: 100, height: 100))
        
        self.zPosition = 5
        self.name = "Spell Ring"
        player = battleManager.getPlayer()
        setupSpellSlotNodes()
        drawHealthBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Rotates clockwise when a spell has been casted
    func rotate() {
        self.run(SKAction.rotate(byAngle: CGFloat(Double.pi/(Double((spellSlotArray?.count)!)/2.0)), duration: 0.5))
        for child in self.children {
            child.run(SKAction.rotate(byAngle: -CGFloat(Double.pi/(Double((spellSlotArray?.count)!)/2.0)), duration: 0.5))
        }
        if currentIndex < (spellSlotArray?.count)! - 1 {
            updatePrimarySpell(spellIndex: currentIndex + 1)
        } else {
            updatePrimarySpell(spellIndex: 0)
        }
    }
    

    /// Rotates clock-wise based until it has reached the location of the current spell index.
    ///
    /// - Parameter spellIndex: The spell index it is rotating towards to.
    func rotate(spellIndex: Int) {
        print("Spell Index: \(spellIndex)")
        var difference = currentIndex - spellIndex
        if difference == -1 || difference == 3 {
            rotate()
        } else {
            if difference < -1 {
                difference *= -1
            } else if difference == 1 {
                difference = 3
            }
            let degree = CGFloat((Double.pi/(Double((spellSlotArray?.count)!)/2.0)) * Double(difference))
            
            /// Rotates each spell slot node so that the image orientation does not change.
            for child in self.children {
                child.run(SKAction.rotate(byAngle: -degree, duration: 0.5))
            }
            
            updatePrimarySpell(spellIndex: spellIndex)
            self.run(SKAction.rotate(byAngle: degree, duration: 0.5))
        }
    }
    
    /// Updates the primary spell to the selected spell index.
    ///
    /// - Parameter spellIndex: Index of the new primary spell.
    func updatePrimarySpell(spellIndex: Int) {
        //Resize the previous primary spell and enlarge the current primary spell
        spellSlotArray?[currentIndex].run(SKAction.scaleX(to: CGFloat(0.75), y: CGFloat(0.75), duration: 0.5))
        spellSlotArray?[spellIndex].run(SKAction.scaleX(to: CGFloat(1), y: CGFloat(1), duration: 0.5))
        currentIndex = spellIndex
    }
    
    
    /// Gets the array of spell slot node objects.
    ///
    /// - Returns: Array of spell slot nodes.
    func getSpellSlotArray() -> [LB_SpellSlotNode] {
        return spellSlotArray!
    }
    
    /// Initializes the beginning positions and sizing of the slot nodes
    private func setupSpellSlotNodes() {
        getPoints()
        
        for i in 0...(spellSlotArray?.count)! - 1 {
            spellSlotArray?[i].position = arrayOfPoints[i]
            if i > 0 {
                spellSlotArray?[i].run(SKAction.scaleX(to: 0.75, y: 0.75, duration: 0))
            }
            self.addChild((spellSlotArray?[i])!)
        }
    }
    
    /// Allow the spell ring to move towards the player's position.
    ///
    /// - Parameter playerPosition: Player's current position.
    func moveTo(playerPosition: CGPoint) {
        self.run(SKAction.move(to: playerPosition, duration: 0.25))
    }
    
    /// Helper function for getPoints() in retrieving specific points in the array.
    ///
    /// - Parameters:
    ///   - radius: Radius of the selected node.
    ///   - center: Center point of the node.
    ///   - angle: Angle used to determine the placement of the points.
    /// - Returns: <#return value description#>
    private func getPoint(radius: Float, center: CGPoint, angle: Float) -> CGPoint {
        let theta = angle * Float(Double.pi) / 180
        let x = round(radius * cosf(theta))
        let y = round(radius * sinf(theta))
        
        return CGPoint(x: CGFloat(x) + center.x, y: CGFloat(y) + center.y)
    }
    
    /// Grabs all the points around the spell container based on the size of the spellSlotNode array.
    private func getPoints() {
        arrayOfPoints = [CGPoint]()
        for i in 0...(spellSlotArray?.count)!-1 {
            arrayOfPoints.append(getPoint(radius: Float(self.size.width), center: self.position, angle: (Float(i) * Float(360 / (spellSlotArray?.count)!))))
        }
//        print(arrayOfPoints)
        let center = self.position
        
        /// Sort function found online: Sorts it clockwise
        arrayOfPoints.sort {a, b in
            if (a.x - center.x >= 0 && b.x - center.x < 0) {
                return true
            }
            
            if (a.x - center.x < 0 && b.x - center.x >= 0) {
                return false
            }
            if (a.x - center.x == 0 && b.x - center.x == 0) {
                if (a.y - center.y >= 0 || b.y - center.y >= 0) {
                    return a.y > b.y
                }
                return b.y > a.y
            }
            
            /// compute the cross product of vectors (center -> a) x (center -> b)
            let det = ((a.x - center.x) * (b.y - center.y)) - ((b.x - center.x) * (a.y - center.y))
            if (Int(det) < 0) {
                return true
            }
            if (Int(det) > 0) {
                return false
            }
            
            /// points a and b are on the same line from the center
            /// check which point is closer to the center
            let d1 = ((a.x - center.x) * (a.x - center.x)) + ((a.y - center.y) * (a.y - center.y))
            let d2 = ((b.x - center.x) * (b.x - center.x)) + ((b.y - center.y) * (b.y - center.y))
            return Int(d1) > Int(d2)
        }
    }
    
    /// Initalizes and draws player's health bar onto scene.
    private func drawHealthBar() {
        healthRing = SKShapeNode(circleOfRadius: radius)
        healthRing.alpha = 0.90
        healthRing.lineWidth = CGFloat(3)
        healthRing.zPosition = 1
        updateHealthRing()
        self.addChild(healthRing)
        let baseRing = SKShapeNode(circleOfRadius: radius)
        let endingAngle = (fullCircle) + startingAngle
        let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: CGFloat(startingAngle), endAngle: CGFloat(endingAngle), clockwise: true)
        baseRing.path = path.cgPath
        baseRing.zPosition = 0
        baseRing.lineWidth = CGFloat(8)
        baseRing.strokeColor = UIColor.darkGray
        self.addChild(baseRing)
    }
    
    /// https://www.youtube.com/watch?list=PLSu4oD8fW_f0CWidT67OiFim-Qk6kEhVc&v=t_xPMTGkpd0
    /// Updates the current health ring to player's curernt health
    func updateHealthRing() {
        
        let healthRatio = Double(((player?.currentHealth)!/(player?.maxHealth)!))
        let endingAngle = (fullCircle * healthRatio) + startingAngle
        let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: radius, startAngle: CGFloat(startingAngle), endAngle: CGFloat(endingAngle), clockwise: true)
        healthRing.path = path.cgPath
        healthRing.strokeColor = UIColor.green
//        if healthRatio < factor {
//            healthRing.strokeColor = UIColor(colorLiteralRed: Float(factor), green: Float(healthRatio), blue: 0, alpha: 1.0)
//        } else {
//            healthRing.strokeColor = UIColor(colorLiteralRed: Float(1 - healthRatio), green: Float(healthRatio), blue: 0, alpha: 1.0)
//        }
    }
}
