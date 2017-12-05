//
//  ViewController.swift
//  FakeCamera
//
//  Created by zhangxi on 05/12/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let cameraView = CameraView(frame: CGRect(x: 0, y: 40, width: 320, height: 428))
        self.view.addSubview(cameraView)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


class CameraView: UIView {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        session?.stopRunning()
    

        let devices = AVCaptureDevice.devices()
        
        for d in devices {
            if d.position == .back {
                device = d
            }
        }
        
        if device == nil {
            return
        }
        
        guard let input  = try? AVCaptureDeviceInput(device: device!) else { return }
        
        session?.beginConfiguration()
        session = AVCaptureSession()
        session?.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        session?.addOutput(output)
        session?.commitConfiguration()
        
        
        previewLayer?.removeFromSuperlayer()
        previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        previewLayer!.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        previewLayer!.videoGravity = .resizeAspectFill
        self.layer.insertSublayer(previewLayer!, at: 0)
        
        session?.startRunning()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class CameraButton : UIButton {
    
    var player:AVAudioPlayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let path = Bundle.main.path(forResource: "sound", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        self.player = try! AVAudioPlayer(contentsOf: url)
        self.player.numberOfLoops = -1
        self.player.prepareToPlay()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.player.play()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.player.stop()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.player.stop()
    }
}

