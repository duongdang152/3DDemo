//
//  ViewController.swift
//  3DDemo
//
//  Created by dang huu duong on 11/24/20.
//  Copyright © 2020 Compathnion. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sceneView.autoenablesDefaultLighting = true
        
        self.setupWorldTracking()
        self.sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))

    }

    private func setupWorldTracking() {
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            configuration.isLightEstimationEnabled = true
            self.sceneView.session.run(configuration, options: [])
        }
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
        guard let result: ARHitTestResult = results.first else {
            return
        }

        // pulls cube.scn from github repo

        let myURL = NSURL(string: "https://raw.githubusercontent.com/wave-electron/scnFile/master/cube.scn")
        let scene = try! SCNScene(url: myURL! as URL, options: nil)
        let node = scene.rootNode.childNode(withName: "SketchUp", recursively: true)
        node?.scale = SCNVector3(0.02,0.02,0.02)

        let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        node?.position = position
        self.sceneView.scene.rootNode.addChildNode(node!)
        print("Added")
     }

}

