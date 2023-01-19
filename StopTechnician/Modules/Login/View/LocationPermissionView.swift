//
//  LocationPermissionView.swift
//  StopTechnician
//
//  Created by Agus Cahyono on 15/11/18.
//  Copyright © 2018 Agus Cahyono. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionView: StopAppBaseView, CLLocationManagerDelegate  {

    @IBOutlet weak var tableView: SDStateTableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        tableView.setState(
            .withButton(
                errorImage: "accessLocation",
                title: "Need Your Location",
                message: "Please turn on your GPS to find out where you are",
                buttonTitle: "Allow GPS",
                buttonConfig: { button in
                    // You can configure the button here
                    button.backgroundColor = UIColor.hexStringToUIColor(hex: "E42F38")
                    button.setTitleColor(.white, for: .normal)
            },
                retryAction: {
                    DispatchQueue.main.async {
                        
                        self.locationManager.requestWhenInUseAuthorization()
                        self.locationManager.requestAlwaysAuthorization()
                        
                        self.currentLocation = self.locationManager.location
                        
                        self.tableView.reloadData()
                        self.locationManager.delegate = self
                        self.locationManager.startUpdatingLocation()
                    }
                    
            }))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setNavigationBar("", color: "", titleColor: "")
        self.setArrowBack(imageArrow: UIImage())
        self.transparentBar()
        self.interactiveNavigationBarHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            let register = UIStoryboard.init(name: "RegisterView", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterView") as! RegisterView
            
            register.getLatitude    = currentLocation.coordinate.latitude
            register.getLongitude   = currentLocation.coordinate.longitude
            
            self.navigationController?.pushViewController(register, animated: true)
            
            break
        case .restricted:
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            break
        case .denied:
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            break
        default:
            break
        }
        
    }
    
}
