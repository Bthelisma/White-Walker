//
//  ViewController.swift
//  White_Walkers
//
//  Created by Dojo on 1/18/18.
//  Copyright © 2018 Dojo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapLocationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    var randomMarker: CLLocationCoordinate2D?
    
    let locationManager = CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            statusLabel.text = ""
            self.isTimerRunning = true
            if isTimerRunning {
                runTimer()
            }
            enableBasicLocationServices()
        }
        
        
        func enableBasicLocationServices() {
            locationManager.delegate = self
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
                
            case .restricted, .denied:
                disableMyLocationBasedFeatures()
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable location features
                enableMyWhenInUseFeatures()
                break
            }
        }
        
        func locationManager(_ manager: CLLocationManager,
                             didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .restricted, .denied:
                disableMyLocationBasedFeatures()
                break
                
            case .authorizedWhenInUse:
                enableMyWhenInUseFeatures()
                break
                
            case .notDetermined, .authorizedAlways:
                break
            }
        }
        
        func disableMyLocationBasedFeatures(){
            print("disableMyLocationBasedFeatures")
        }
        
        func enableMyWhenInUseFeatures(){
            print("enableMyWhenInUseFeaatures")
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = 0  // In meters.
            locationManager.startUpdatingLocation()
            createRandomMarker()
            setUserLocation()
        }
        
        func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
            print(locationManager.location?.coordinate)
            checkWin()
        }
    
    
    func runTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        if seconds < 1{
            timer.invalidate()
            self.isTimerRunning = false
            let alert = UIAlertController(title: "Nice Try!", message: "You have ran out of time!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Press reset on timer to play again.", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        if isTimerRunning {
            isTimerRunning = false
            timer.invalidate()
            sender.setTitle("Resume", for: .normal)
        }else{
            isTimerRunning = true
            runTimer()
            sender.setTitle("Pause", for: .normal)

        }
    }
    
    @IBAction func stopTimer(_ sender: UIButton) {
        timer.invalidate()
        seconds = 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        self.isTimerRunning = true
        runTimer()
    }
    
    func timeString(time: TimeInterval) -> String{
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format :"%02i:%02i:%02i", hours, minutes, seconds)
        
    }
    
    func setUserLocation(){
        if let locationUnwrapped = locationManager.location?.coordinate{
            mapView.mapType = .mutedStandard
            let span = MKCoordinateSpanMake(0.00001, 0.00001)
            let region = MKCoordinateRegion(center: locationUnwrapped, span: span)
            mapView.showsUserLocation = true
            mapView.setRegion(region, animated: false)
        }
    }
    func createRandomMarker(){
        if var locationUnwrapped = self.locationManager.location?.coordinate{
            locationUnwrapped.latitude = 37.375649890706207
            locationUnwrapped.longitude = -121.91012518190705
            randomMarker = locationUnwrapped
            let mapAnnotation = MKPlacemark(coordinate: locationUnwrapped)
            print("Added random marker at : \(locationUnwrapped)")
            mapView.addAnnotation(mapAnnotation)
        }
    }
    
    func checkWin(){
        if(locationManager.location?.coordinate.longitude == randomMarker?.latitude && locationManager.location?.coordinate.longitude == randomMarker?.longitude){
            statusLabel.text = "You found it!"
            statusLabel.textColor = .green
            locationManager.stopUpdatingLocation()
        }else{
            statusLabel.text = "Keep searching!"
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "backToMainController", sender: self)
    }
    
    
}



