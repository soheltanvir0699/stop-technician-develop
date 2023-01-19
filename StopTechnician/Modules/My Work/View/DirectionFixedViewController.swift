//
//  DirectionFixedViewController.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 27/08/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import GooglePlaces
import SwiftyJSON
import Kingfisher


class DirectionFixedViewController: StopAppBaseView {
    
    @IBOutlet weak var googleMaps: GMSMapView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var avatarClient: BXImageView!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientAddress: UILabel!
    @IBOutlet weak var rateClient: FloatRatingView!
    @IBOutlet weak var categoryClientOrder: UILabel!
    @IBOutlet weak var buttonClientCall: UIButton! {
        didSet {
            self.buttonClientCall.addTarget(self, action: #selector(self.didCallClient(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var viewFailedDirection: UIView! {
        didSet {
            self.viewFailedDirection.isHidden = true
        }
    }
    
    
    // VARIABLES HERE
    var getClientRate: Double = 0
    var getClientPhone = ""
    var getClientName = ""
    var getClientAvatar = ""
    var getClientAddress = ""
    var getCategoryOrder = ""
    
    var engineerLatitude: Double = 0.0
    var engineerLongitude: Double = 0.0
    
    let zoom: Float = 18
    
    var userLatitude: Double = 0.0
    var userLongitude: Double = 0.0
    
    // VARIABLES HERE
    let lat = -7.9273567
    let long = 112.6014499
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    var coordinates: [CLLocationCoordinate2D] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rateClient.rating          = self.getClientRate
        self.clientName.text            = self.getClientName
        self.clientAddress.text         = self.getClientAddress
        self.categoryClientOrder.text   = self.getCategoryOrder
        
        if let urlAvatar = URL(string: self.getClientAvatar) {
            self.avatarClient.kf.setImage(with: urlAvatar)
        }
        
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager.location else {
                return
            }
            
            self.engineerLatitude   = currentLocation.coordinate.latitude
            self.engineerLongitude  = currentLocation.coordinate.longitude
            
            
            self.createMapView()
            self.createDirection()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.presentTransparentNavigationBar()
    }
    
    func createMapView() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        let camera = GMSCameraPosition.camera(withLatitude:lat,
                                              longitude: long, zoom: zoom)
        self.googleMaps.camera = camera
        self.googleMaps.mapStyle(withFilename: "ubers", andType: "json")
        self.googleMaps.delegate = self
    }
    
    func createDirection() {
        let direction = BuildDirection(from:"\(self.engineerLatitude),\(self.engineerLongitude)",to: "\(self.userLatitude),\(self.userLongitude)")
        let fromMarker = CLLocationCoordinate2D(latitude: self.engineerLatitude, longitude:self.engineerLongitude)
        let toMarker = CLLocationCoordinate2D(latitude: self.userLatitude, longitude:self.userLongitude)
        self.coordinates.append(fromMarker)
        self.coordinates.append(toMarker)
        
        
        self.directionMarker(icon: UIImage(named: "iconMarkerClient")!, location: fromMarker)
        self.directionMarker(icon: UIImage(named: "iconMarkerEngineer")!, location: toMarker)
        
        self.showLoading()
        direction.directionCompletion(handler: { (route) in
            print (route)
            for route in route.routes {
                self.googleMaps.addDirection(path: (route?.overviewPolyline?.points)!)
                
                let path = route?.overviewPolyline?.points
                
                if let getPath = path {
                    let pathGMS = GMSPath(fromEncodedPath: getPath)!
                    let bounds = GMSCoordinateBounds(path: pathGMS)
                    self.googleMaps.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 160.0))
                    
                }
                self.dismissLoading()
            }
            
        }) { (error) in
            self.dismissLoading()
            print("DIRECTION ERROR: \(error)")
            self.viewFailedDirection.isHidden = false
        }
    }
    
    func directionMarker (icon: UIImage, location: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.title = "Within 5 Km"
        marker.icon = icon
        marker.map = self.googleMaps
    }
    
    @IBAction func popBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didCallClient(_ sender: UIButton) {
        
        let phoneNumber = self.getClientPhone
        
        if phoneNumber.isEmpty {
            self.alertMessage("", message: "Phone number not found") {
                
            }
        } else {
            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }

}
