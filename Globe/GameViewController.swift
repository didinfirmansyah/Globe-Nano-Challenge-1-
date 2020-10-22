//
//  GameViewController.swift
//  Globe
//
//  Created by Didin Firmansyah on 10/04/20.
//  Copyright © 2020 Didin Firmansyah. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    
    let text = 2
    var gameView: SCNView!
    var gameScene: SCNScene!
    
    var ballNode: SCNNode!
    var selfieStickNode: SCNNode!
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)

    override func viewDidLoad() {
        setupScene()
        setupNode()
        soundSetup()
    }
    
    func setupScene(){
        gameView = self.view as! SCNView
        gameView.delegate = self
        //gameView.allowsCameraControl = true
        gameScene = SCNScene(named: "art.scnassets/MainScene.scn")
        gameView.scene = gameScene
        
        gameScene.physicsWorld.contactDelegate = self
        
        let tapRzecognizer = UITapGestureRecognizer()
        tapRzecognizer.numberOfTapsRequired = 1
        tapRzecognizer.numberOfTouchesRequired = 1
        
        tapRzecognizer.addTarget(self, action: #selector(GameViewController.gameViewtapped(recognizer:)))
        gameView.addGestureRecognizer(tapRzecognizer)
    }
    func setupNode(){
        ballNode = gameScene.rootNode.childNode(withName: "ball", recursively: true)!
        ballNode.physicsBody?.contactTestBitMask = text
        selfieStickNode = gameScene.rootNode.childNode(withName: "selfieStick", recursively: true)!
    }
    
    func soundSetup(){
        let jumpSound = SCNAudioSource(fileNamed: "jump.wav")!
        jumpSound.load()
        jumpSound.volume = 0.4
        
        
        
        let musicPlayer = SCNAudioPlayer(source: jumpSound)
        ballNode.addAudioPlayer(musicPlayer)

    }
    
    @objc func gameViewtapped(recognizer: UITapGestureRecognizer){
        let location = recognizer.location(in: gameView)
        let hitResult = gameView.hitTest(location, options: nil)
        
        if hitResult.count > 0{
            let result = hitResult.first
            if let node = result?.node{
                if node.name == "ball"{
                    let jumpSound = SCNAudioSource(fileNamed: "jump.wav")!
                    jumpSound.load()
                    jumpSound.volume = 0.4
                    ballNode.runAction(SCNAction.playAudio(jumpSound, waitForCompletion: false))
                    ballNode.physicsBody?.applyForce(SCNVector3(x: 0, y: 2, z: -2), asImpulse: true)
                    
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let ball = ballNode.presentation
        let ballPosition = ball.position
        
        let targetPosition = SCNVector3(x: ballPosition.x, y: ballPosition.y + 1, z: ballPosition.z + 1)
        var cameraPosition = selfieStickNode.position
        
        let camDamping:Float = 0.5
        
        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * (1 - camDamping)
        let yComponent = cameraPosition.y * (1 - camDamping) + targetPosition.y * (1 - camDamping)
        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * (1 - camDamping)
        
        cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        selfieStickNode.position = cameraPosition
        
        motion.getAccelerometerData { (x, y, z) in
            self.motionForce = SCNVector3(x: x * 0.05, y: 0, z: (y + 0.8) * -0.05)
        }
        ballNode.physicsBody?.velocity += motionForce
    }
    
    
    
    /*func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode: SCNNode!
        
        if contact.nodeA.name == "ball"{
            contactNode = contact.nodeB
        }else{
            contactNode = contact.nodeA
        }
        
        if contactNode.physicsBody?.categoryBitMask == text{
            contactNode.isHidden = true
            
            let waitAction = SCNAction.wait(duration: 15)
            let unHideAction = SCNAction.run { (node) in
                node.isHidden = false
            }
            
            let actionSequence = SCNAction.sequence([waitAction,unHideAction])
            
            contactNode.runAction(actionSequence)
        }
        
    }*/
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
 

}


