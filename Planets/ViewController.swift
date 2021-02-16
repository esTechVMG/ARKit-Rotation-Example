//
//  ViewController.swift
//  Planets
//
//  Created by A4-iMAC01 on 16/02/2021.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [
            ARSCNDebugOptions.showWorldOrigin
        ]
        self.sceneView.session.run(configuration)
    }
    override func viewDidAppear(_ animated: Bool) {
        let sun = planet(geometry: SCNSphere(radius: 0.25), diffuse: UIImage(named: "sun"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,0), name: "Sun")
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        
        
        let earthParent = SCNNode()
        earthParent.position = sun.position
        sceneView.scene.rootNode.addChildNode(earthParent)
        let actionEarthParent = self.rotation(time: 8)
        earthParent.runAction(actionEarthParent)
        
        //Nodo Tierra
        let earth = planet(geometry: SCNSphere(radius: 0.05), diffuse: UIImage(named: "earth_daymap"), specular: UIImage(named: "earth_specular_map"), emission: UIImage(named: "earth_clouds"), normal: UIImage(named: "earth_normal_map"), position: SCNVector3(0,0,-1), name: "Earth")
        earthParent.addChildNode(earth)
        
        earth.runAction(rotation(time: 8))
        
        
        //Not work idk why
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
        sceneView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(rec:UITapGestureRecognizer){
        if rec.state == .ended{
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                print("You tapped \(tappedNode?.name ?? "UnknownNode in func handleTap()")")
            }
        }
    }
    
    func planet(geometry:SCNGeometry, diffuse: UIImage?, specular:UIImage?, emission:UIImage?, normal:UIImage?, position:SCNVector3, name:String?) -> SCNNode {
        let planet = SCNNode()
        planet.geometry = SCNSphere(radius: 0.05)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        planet.name = name
        return planet;
    }
    func rotation(time:TimeInterval) -> SCNAction{
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(rotation)
        return foreverRotation
    }
}

extension Int{
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
