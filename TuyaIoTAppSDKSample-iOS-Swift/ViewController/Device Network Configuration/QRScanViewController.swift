//
//  QRScanViewController.swift
//  ThingIoTAppSDK
//
//  Copyright (c) 2014-2022 Thing Inc. (https://developer.tuya.com/)

import Foundation
import AVFoundation

typealias CallBack = (_ code : String? ) -> ()

class QRScanViewController: UIViewController {
    let session = AVCaptureSession()
    var callBack:CallBack?
    
    override func viewDidLoad() {
        self.addScaningVideo()
    }
    
    private func addScaningVideo(){
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        }
        
        metadataOutput.metadataObjectTypes = [.qr, .code128, .code39, .code93, .code39Mod43, .ean8, .ean13, .upce, .pdf417, .aztec]
        
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        
        session.startRunning()
    }
}

extension QRScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        session.stopRunning()
        
        for result in metadataObjects {
            if let code = result as? AVMetadataMachineReadableCodeObject {
                self.callBack?(code.stringValue ?? "")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
