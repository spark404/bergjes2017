//
//  QrScannerController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 13/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol QrCodeResultDelegate {
    
    func qrCodeFound(qrValue: String)
}

class QrScannerController: NSObject {
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var delegate: QrCodeResultDelegate?
    
    func setupScanner(parentView: UIView) {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        let input = try? AVCaptureDeviceInput.init(device: captureDevice)
        
        if (captureSession.canAddInput(input)) {
            captureSession.addInput(input!)
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if let videoPreviewLayer = self.videoPreviewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = parentView.bounds
            parentView.layer.addSublayer(videoPreviewLayer)
        }
        
        // Initialize QR Code Frame to highlight the QR code
        self.qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = self.qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            parentView.addSubview(qrCodeFrameView)
            parentView.bringSubview(toFront: qrCodeFrameView)
        }

        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func checkCamera(completionHandler: @escaping (Void) -> Void, failedHandler: @escaping (Void) -> Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
        case .authorized: completionHandler()
        case .denied: failedHandler()
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                self.checkCamera(completionHandler: completionHandler, failedHandler: failedHandler)
            });
        default: failedHandler()
        }
    }
    
    func startSession() {
        if !self.captureSession.isRunning {
            self.captureSession.startRunning()
        }
    }
    
    func stopSession() {
        if self.captureSession.isRunning {
            self.captureSession.stopRunning()
        }
    }
}

extension QrScannerController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                stopSession()
                delegate?.qrCodeFound(qrValue: metadataObj.stringValue)
            }
        }
    }
    

}
