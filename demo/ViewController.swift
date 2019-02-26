//
//  ViewController.swift
//  demo
//
//  Created by Johan Halin on 12/03/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

import UIKit
import AVFoundation
import SceneKit
import Foundation

class ViewController: UIViewController, SCNSceneRendererDelegate {
    let audioPlayer: AVAudioPlayer
    let sceneView = SCNView()
    let camera = SCNNode()
    let startButton: UIButton
    let qtFoolingBgView: UIView = UIView.init(frame: CGRect.zero)
    let contentView = UIView()
    
    var textMaskView1: MaskedTextContainerView?
    var textMaskView2: MaskedTextContainerView?
    var textMaskView3: MaskedTextContainerView?

    // MARK: - UIViewController
    
    init() {
        if let trackUrl = Bundle.main.url(forResource: "placeholder", withExtension: "m4a") {
            guard let audioPlayer = try? AVAudioPlayer(contentsOf: trackUrl) else {
                abort()
            }
            
            self.audioPlayer = audioPlayer
        } else {
            abort()
        }
        
        let camera = SCNCamera()
        camera.zFar = 600
//        camera.vignettingIntensity = 1
//        camera.vignettingPower = 1
//        camera.colorFringeStrength = 3
//        camera.bloomIntensity = 1
//        camera.bloomBlurRadius = 40
        self.camera.camera = camera // lol
        
        let startButtonText =
            "\"modern pictures\"\n" +
                "by dekadence\n" +
                "\n" +
                "programming and music by ricky martin\n" +
                "\n" +
                "presented at instanssi 2019\n" +
                "\n" +
        "tap anywhere to start"
        self.startButton = UIButton.init(type: UIButton.ButtonType.custom)
        self.startButton.setTitle(startButtonText, for: UIControl.State.normal)
        self.startButton.titleLabel?.numberOfLines = 0
        self.startButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.startButton.backgroundColor = UIColor.black
        
        super.init(nibName: nil, bundle: nil)
        
        self.startButton.addTarget(self, action: #selector(startButtonTouched), for: UIControl.Event.touchUpInside)
        
        self.view.backgroundColor = .black
        
        self.sceneView.backgroundColor = .black
        self.sceneView.delegate = self

        self.qtFoolingBgView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // barely visible tiny view for fooling Quicktime player. completely black images are ignored by QT
        self.view.addSubview(self.qtFoolingBgView)
        
//        self.view.addSubview(self.sceneView)

        self.contentView.isHidden = true
        self.contentView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        self.view.addSubview(self.contentView)
        
        self.view.addSubview(self.startButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.audioPlayer.prepareToPlay()
        
        self.sceneView.scene = createScene()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.qtFoolingBgView.frame = CGRect(
            x: (self.view.bounds.size.width / 2) - 1,
            y: (self.view.bounds.size.height / 2) - 1,
            width: 2,
            height: 2
        )

        self.sceneView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.sceneView.isPlaying = true
        self.sceneView.isHidden = true

        self.contentView.frame = self.view.bounds
        
        self.textMaskView1 = MaskedTextContainerView(frame: self.view.bounds, labelCount: 2)
        self.textMaskView1?.setText(text1: "", text2: "")
        self.contentView.addSubview(self.textMaskView1!)

        self.textMaskView2 = MaskedTextContainerView(frame: self.view.bounds, labelCount: 3)
        self.textMaskView2?.setText(text1: "", text2: "", text3: "")
        self.contentView.addSubview(self.textMaskView2!)

        self.textMaskView3 = MaskedTextContainerView(frame: self.view.bounds, labelCount: 4)
        self.textMaskView3?.setText(text1: "", text2: "", text3: "", text4: "")
        self.contentView.addSubview(self.textMaskView3!)

        showContentView(identifier: 0)
        
        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    // MARK: - Private
    
    private func showContentView(identifier: Int) {
        self.textMaskView1?.isHidden = identifier == 0 ? false : true
        self.textMaskView2?.isHidden = identifier == 1 ? false : true
        self.textMaskView3?.isHidden = identifier == 2 ? false : true
    }
    
    @objc
    fileprivate func startButtonTouched(button: UIButton) {
        self.startButton.isUserInteractionEnabled = false
        
        // long fadeout to ensure that the home indicator is gone
        UIView.animate(withDuration: 4, animations: {
            self.startButton.alpha = 0
        }, completion: { _ in
            self.start()
        })
    }
    
    fileprivate func start() {
        self.sceneView.isHidden = false
        self.contentView.isHidden = false
        
        self.audioPlayer.play()
    }
    
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.black
        
        self.camera.position = SCNVector3Make(0, 0, 58)
        
        scene.rootNode.addChildNode(self.camera)
        
        configureLight(scene)
        
        return scene
    }
    
    fileprivate func configureLight(_ scene: SCNScene) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 1.0, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 0, 60)
        scene.rootNode.addChildNode(omniLightNode)
    }
}
