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

    var circlesMaskView1: MaskedCirclesContainerView?
    var circlesMaskView2: MaskedHorizontalCirclesContainerView?
    
    var boyView: TextFlickerView?
    var girlView: TextFlickerView?
    
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
        self.contentView.backgroundColor = .black
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
        self.contentView.addSubview(self.textMaskView1!)

        self.textMaskView2 = MaskedTextContainerView(frame: self.view.bounds, labelCount: 3)
        self.contentView.addSubview(self.textMaskView2!)

        self.textMaskView3 = MaskedTextContainerView(frame: self.view.bounds, labelCount: 4)
        self.contentView.addSubview(self.textMaskView3!)

        self.circlesMaskView1 = MaskedCirclesContainerView(frame: self.view.bounds)
        self.contentView.addSubview(self.circlesMaskView1!)

        self.circlesMaskView2 = MaskedHorizontalCirclesContainerView(frame: self.view.bounds)
        self.contentView.addSubview(self.circlesMaskView2!)

        self.boyView = TextFlickerView(frame: self.view.bounds, text: "BOY")
        self.boyView?.mask = MaskVerticalView(frame: self.view.bounds, offset: 2, count: 1)
        self.boyView?.scramble(segmentCount: 0)
        self.contentView.addSubview(self.boyView!)
        
        self.girlView = TextFlickerView(frame: self.view.bounds, text: "GIRL")
        self.girlView?.mask = MaskVerticalView(frame: self.view.bounds, offset: 2, count: 1)
        self.girlView?.scramble(segmentCount: 0)
        self.contentView.addSubview(self.girlView!)
        
        self.startButton.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.audioPlayer.stop()
    }
    
    // MARK: - Private
    
    fileprivate func start() {
        self.sceneView.isHidden = false
        self.contentView.isHidden = false
        
        self.audioPlayer.play()
        
        self.textMaskView1?.setText(text1: "Modern", text2: "Modern")

        showContentView(identifier: 0)

        scheduleEvents()
    }
    
    private func scheduleEvents() {
        let tick = ((120.0 / 130.0) / 8.0)
        let length = tick * 36.0
        let loops = 3 * 8
        
        for position in 0..<loops {
            let startTime = length * Double(position)
            
            let hit1 = startTime + (tick * 15.0)
            perform(#selector(event1), with: nil, afterDelay: hit1)
            
            let hit2 = startTime + (tick * 32.0)
            perform(#selector(event2), with: nil, afterDelay: hit2)

            let hit3 = startTime + (tick * 33.0)
            if position == 2 {
                perform(#selector(event4), with: nil, afterDelay: hit3)
                perform(#selector(event3), with: nil, afterDelay: hit3 + Constants.shapeAnimationDuration)
            } else if position == 8 {
                    perform(#selector(event5), with: nil, afterDelay: hit3)
                    perform(#selector(event3), with: nil, afterDelay: hit3 + Constants.shapeAnimationDuration)
            } else {
                perform(#selector(event3), with: nil, afterDelay: hit3)
            }
        }
    }
    
    @objc
    private func event1() {
        if Bool.random() {
            let word = randomWord()
            self.textMaskView2?.setText(text1: word, text2: word, text3: word)
        } else {
            self.textMaskView2?.setText(text1: randomWord(), text2: randomWord(), text3: randomWord())
        }
        
        showContentView(identifier: 1)
    }
    
    @objc
    private func event2() {
        if Bool.random() {
            let word = randomWord()
            self.textMaskView3?.setText(text1: word, text2: word, text3: word, text4: word)
        } else {
            self.textMaskView3?.setText(text1: randomWord(), text2: randomWord(), text3: randomWord(), text4: randomWord())
        }
        
        showContentView(identifier: 2)
    }

    @objc
    private func event3() {
        if Bool.random() {
            let word = randomWord()
            self.textMaskView1?.setText(text1: word, text2: word)
        } else {
            self.textMaskView1?.setText(text1: randomWord(), text2: randomWord())
        }

        showContentView(identifier: 0)
    }

    @objc
    private func event4() {
        self.circlesMaskView1?.animate()
        
        showContentView(identifier: 3)
    }

    @objc
    private func event5() {
        self.circlesMaskView2?.animate()
        
        showContentView(identifier: 4)
    }

    private func randomWord() -> String {
        let word = Constants.vocabulary[Int.random(in: 0..<Constants.vocabulary.count)]
        
        switch arc4random_uniform(3) {
        case 0:
            return word.capitalized
        case 1:
            return word.uppercased()
        default:
            return word
        }
    }
    
    private func showContentView(identifier: Int) {
        for (index, view) in self.contentView.subviews.enumerated() {
            view.isHidden = identifier != index
        }
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

extension Bool {
    static func random() -> Bool {
        return arc4random_uniform(2) == 0
    }
}
