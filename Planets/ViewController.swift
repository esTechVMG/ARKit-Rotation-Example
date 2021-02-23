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
        let sun = planet(radius:0.2, diffuse: UIImage(named: "sun"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-1), name: "Sun")
        //Orbit Nodes
        let planetNodes:[SCNNode]=[
            planet(radius:0.05, diffuse: UIImage(named: "earth_daymap"), specular: UIImage(named: "earth_specular_map"), emission: UIImage(named: "earth_clouds"), normal: UIImage(named: "earth_normal_map"), position: SCNVector3(0,0,-2), name: "Earth"),
            planet(radius:0.05, diffuse: UIImage(named: "venus_surface"), specular: nil, emission: UIImage(named: "venus_atmosphere"), normal: nil, position: SCNVector3(0, 0, -1.5), name: "Venus"),
            planet(radius:0.05, diffuse: UIImage(named: "mars"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0, 0, -2.5), name: "Mars")
        ]
        var orbitNodes:[SCNNode] = Array(repeating: SCNNode(), count: planetNodes.count)
        for n in 0...planetNodes.count-1{
            orbitNodes[n] = SCNNode()
        }
        let moon = planet(radius: 0.02, diffuse: UIImage(named: "moon"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.1), name: "Moon")
        //moon.runAction(rotation(time: 2)) //Planet Node Index 0 is the earth
        planetNodes[0].addChildNode(moon)
        
        let orbitSpeeds:[Double] = [25,30,35]
        let rotationSpeeds:[Double] = [8.0,3.5,5.6]
        for n in 0...planetNodes.count-1 {
            orbitNodes[n].position = sun.position
            //planetNodes[n].rotate(by: SCNQuaternion(0, -1, 0, 360.degreesToRadians), aroundTarget: sun.position) //Work in progress
            orbitNodes[n].runAction( rotation(time: orbitSpeeds[n]))
            orbitNodes[n].addChildNode(planetNodes[n])
            planetNodes[n].runAction(rotation(time: rotationSpeeds[n]))
            sun.addChildNode(orbitNodes[n])
        }
        
        
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        
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
    
    func planet(radius:Double, diffuse: UIImage?, specular:UIImage?, emission:UIImage?, normal:UIImage?, position:SCNVector3, name:String?) -> SCNNode {
        let planet = SCNNode()
        planet.geometry = SCNSphere(radius: CGFloat(radius))
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
