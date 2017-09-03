//
//  ViewController.swift
//  Yochi_ARDemo1
//
//  Created by Yochi·Kung on 2017/9/3.
//  Copyright © 2017年 Yochi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let textures = ["earth.jpg","jupiter.jpg","mars.jpg","venus.jpg"]
    private var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         // Set the view's delegate
         sceneView.delegate = self
         
         // Show statistics such as fps and timing information
         sceneView.showsStatistics = true
         
         // Create a new scene
         let scene = SCNScene(named: "art.scnassets/ship.scn")!
         
         // Set the scene to the view
         sceneView.scene = scene
         */

// +++++++++++++++++++++++++++++++++++++++++++++++++++++
        /**
         ARKit ：入门掌握的四大点
         几何、节点、渲染、手势
         */
// +++++++++++++++++++++++++++++++++++++++++++++++++++++
        
// +++++++++++++++++++++++++++++++++++++++++++++++++++++
        // 盒子
        // self.sceneBox()
        
// +++++++++++++++++++++++++++++++++++++++++++++++++++++
        // 球
        self.sceneSphere()
        
        // 更换场景
        self.addGestureOnSphere()
// +++++++++++++++++++++++++++++++++++++++++++++++++++++
        // 场景截图
        //self.scenesnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func sceneBox() {
        // 万物皆scene(场景),3d模型就是一个scene 比例为1m
        let scene = SCNScene()
        
        // 创键一个盒子
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        // 渲染器
        let material = SCNMaterial()
        
        // 设置渲染内容，放什么媒体内容都可以
        // 放颜色
        //material.diffuse.contents = UIColor.purple
        
        // 放图片
        material.diffuse.contents = UIImage(named: "brick.png")
        
        box.materials = [material]
        
        // 创建节点 每个scene都包含一个根节点 设置它位置等等信息
        let boxNode = SCNNode(geometry: box)
        
        // 设置节点的位置
        boxNode.position = SCNVector3(0,0,-0.2)
        
        // 把节点添加到Scene的根节点上
        scene.rootNode.addChildNode(boxNode)
        
        sceneView.scene = scene
    }
    
    func sceneSphere() {
        
        let scene = SCNScene()
        
        let sphere = SCNSphere(radius: 0.1)
        
        let material = SCNMaterial()
        
        material.diffuse.contents = UIImage(named:"earth.jpg")
        
        sphere.materials = [material]
        
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0,0,-1)
        scene.rootNode.addChildNode(sphereNode)
        
        sceneView.scene = scene;
    }
    
    func addGestureOnSphere() {
        
        // 添加修改场景手势
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(changeSphere))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func changeSphere(recognizer:UITapGestureRecognizer) {
        
        let sceneView = recognizer.view as! ARSCNView
        let touchLoaction = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLoaction, options: [:])
        
        if !hitResults.isEmpty {
            
            if index == self.textures.count {
                index = 0
            }
            guard let hitRersult = hitResults.first else {
                return
            }
            
            let node = hitRersult.node
            node.geometry?.firstMaterial?.diffuse.contents = UIImage(named:textures[index])
            index += 1
        }
        
        print("\(index)")
    }
    
    func scenesnapshot() {
        
        // 添加手势 点击屏幕截图
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(handtap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handtap(_ tapgesture:UITapGestureRecognizer) {
        
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        
        // 创建一个平面
        let imagePlane = SCNPlane(width:sceneView.bounds.width/6000, height:sceneView.bounds.height/6000)
        
        // 截屏
        imagePlane.firstMaterial?.diffuse.contents = sceneView.snapshot()
        imagePlane.firstMaterial?.lightingModel = .constant
        
        // 创建一个节点
        let planeNode = SCNNode(geometry:imagePlane)
        sceneView.scene.rootNode.addChildNode(planeNode)
        
        // 相机追踪
        
        // 4*4矩阵
        var translate = matrix_identity_float4x4
        
        translate.columns.3.x = -0.2
        
        // 两个矩阵相乘
        planeNode.simdTransform = matrix_multiply((currentFrame.camera.transform), translate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
