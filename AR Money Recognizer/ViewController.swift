//
//  ViewController.swift
//  AR Money Recognizer
//
//  Created by Михаил Медведев on 28/05/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureARImageTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}

extension ViewController {
    
    func configureARImageTracking() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        if let imageTrackingReference = ARReferenceImage.referenceImages(inGroupNamed: "Money Set", bundle: Bundle.main) {
            configuration.detectionImages = imageTrackingReference
            configuration.maximumNumberOfTrackedImages = 2
        } else {
            print("Error: Failed to get image tracking referencing image from bundle")
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func add3DText(_ node: SCNNode, for anchor: ARImageAnchor) {
        
        guard let name = anchor.referenceImage.name else { return }
        
        let text = createTextNode(string: name)
        
        text.isHidden = false
        text.runAction(SCNAction.sequence([
            SCNAction.wait(duration: 1.0),
            SCNAction.scale(to: 0.01, duration: 0.5)
            ]))
        
        node.addChildNode(text)
    }
    
    func createTextNode(string: String) -> SCNNode {
        
        let text = SCNText(string: string, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: text)
        
        
        let fontSize = Float(0.04)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        textNode.eulerAngles.x = -.pi / 2
        textNode.eulerAngles.y = (-.pi / 2) * 2
        textNode.position.z = 0.05
        
        return textNode
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor =  anchor as? ARImageAnchor {
            print("Image detected \(imageAnchor.name!)")
            
            add3DText(node, for: imageAnchor)
        }
    }
    
}
