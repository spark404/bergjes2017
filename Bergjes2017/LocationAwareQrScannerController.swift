//
//  LocationAwareQrScannerController.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 26/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation
import UIKit

protocol LocationAwareQrCodeResultDelegate {
    
    func qrCodeFound(qrValue: String, location: CLLocation?)
}

class LocationAwareQrScannerController: NSObject {
    var locationManager: CLLocationManager!
    var qrScannerController: QrScannerController!
    
    var delegate: LocationAwareQrCodeResultDelegate?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        qrScannerController = QrScannerController()
        qrScannerController.delegate = self
    }
    
    func startSession() {
        locationManager.startUpdatingLocation()
        qrScannerController.startSession()
    }
    
    func stopSession() {
        locationManager.stopUpdatingLocation()
        qrScannerController.stopSession()
    }
    
    func checkCamera(completionHandler: @escaping (Void) -> Void, failedHandler: @escaping (Void) -> Void) {
        qrScannerController.checkCamera(completionHandler: completionHandler, failedHandler: failedHandler)
    }
    
    func setupScanner(parentView: UIView) {
        qrScannerController.setupScanner(parentView: parentView)
    }
}

extension LocationAwareQrScannerController: QrCodeResultDelegate {
    func qrCodeFound(qrValue: String) {
        delegate?.qrCodeFound(qrValue: qrValue, location: locationManager.location)
    }
}

extension LocationAwareQrScannerController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach { (location: CLLocation) in
            print("\(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            // No location services?
        }
    }
}
