//
//  QrScannerViewController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 29/03/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import UIKit
import AVFoundation
import AWSLambda

class QrScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput.init(device: captureDevice)
        } catch {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("Error info: \(error)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Starting the capture session")
        captureSession?.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("Stopping the capture layer")
        // Remove the video capture layer
        captureSession?.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
                guard let qrUrl = parseQrcode(qrcodeText: metadataObj.stringValue) else {
                    wrongScan()
                    return
                }
                
                let map = qrUrl.queryItems;
                invokeParseScanFunction(qrcodeText: map["bergjes2017"]!)
                sendNotification(qrcodeText: map["bergjes2017"]!)
            }
        }
    }
    
    func wrongScan() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "wrongscan")
        self.present(controller, animated: true, completion: nil)
    }
    
    func sendNotification(qrcodeText: String) {
        let notificationName = Notification.Name("NotificationIdentifier")
        NotificationCenter.default.post(name: notificationName, object: qrcodeText)
        tabBarController?.selectedIndex = 0
    }
    
    func invokeParseScanFunction(qrcodeText: String) {
        let lambdaInvoker = AWSLambdaInvoker.default()
        let jsonObject: [String: Any] = ["locationCode" : qrcodeText]
        
        lambdaInvoker
            .invokeFunction("ScannedLocationRequest", jsonObject: jsonObject)
            .continueWith(block: {(task) -> AWSTask<AnyObject>! in
                if( task.error != nil) {
                    let error: NSError = (task.error as NSError?)!;
                        print("Error: \(error)")
                        return nil
                    }
                    
                    // Handle response in task.result
                    return nil
                })
    }
    
    func parseQrcode(qrcodeText: String) -> Optional<URL> {
        var url : URL?
        if (qrcodeText.hasPrefix("http://www.fladderen.nl")) {
            url = URL(string: qrcodeText);
        }
        
        return url;
    }
}

extension URL {
    public var queryItems: [String: String] {
        var params = [String: String]()
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            }) ?? [:]
    }
}
