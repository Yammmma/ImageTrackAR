//
//  ViewController.swift
//  Image TrackAR
//
//  Created by yuma@duck on 22/9/18.
//  Copyright © 2018 yuma@duck. All rights reserved.
//

// Hello! Before you try out the app, please check the AR Resources in "assets.xcassets". Thanks!

import UIKit
import SceneKit
import ARKit
import AVFoundation
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        configuration.trackingImages = arImages
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        // Container
        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else { return }
        container.removeFromParentNode()
        node.addChildNode(container)
        container.isHidden = false
        
        // Video
        let videoURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let videoPlayer = AVPlayer(url: videoURL)
        
        let videoScene = SKScene(size: CGSize(width: 720.0, height: 1280.0))
        
        let videoNode = SKVideoNode(avPlayer: videoPlayer)
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.size = videoScene.size
        videoNode.yScale = -1
        videoNode.play()
        
        videoScene.addChild(videoNode)
        
        guard let video = container.childNode(withName: "video", recursively: true) else { return }
        video.geometry?.firstMaterial?.diffuse.contents = videoScene
        
        // Animations
        guard let videoContainer = container.childNode(withName: "videoContainer", recursively: false) else { return }
        guard let text = container.childNode(withName: "text", recursively: false) else { return }
        guard let textTwitter = container.childNode(withName: "textTwitter", recursively: false) else { return }
        
        videoContainer.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.0), SCNAction.scale(to: 1.0, duration: 0.5)]))
        text.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.5), SCNAction.scale(to: 0.01, duration: 0.5)]))
        textTwitter.runAction(SCNAction.sequence([SCNAction.wait(duration: 2.0), SCNAction.scale(to: 0.006, duration: 0.5)]))
        
        // Particlez!!!
        let particle = SCNParticleSystem(named: "particle.scnp", inDirectory: nil)!
        let particleNode = SCNNode()
        
        container.addChildNode(particleNode)
        particleNode.addParticleSystem(particle)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}
