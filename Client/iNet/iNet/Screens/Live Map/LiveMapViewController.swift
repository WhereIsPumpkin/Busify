//
//  MapViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import GoogleMaps

class LiveMapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var mapView: GMSMapView?
    var viewModel = LiveMapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocationManager()
        Task {
            await viewModel.fetchBusStops()
            loadBusStopsOnMap()
        }
    }
    
    private func setupView() {
        setupBackground()
        setupMapView()
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor(resource: .background)
    }
    
    private func setupMapView() {
        let options = GMSMapViewOptions()
        options.frame = view.bounds
        options.backgroundColor = .background
        mapView = GMSMapView(options:options)
        mapView?.isIndoorEnabled = false
        mapView?.isMyLocationEnabled = true
        view = mapView
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    private func loadBusStopsOnMap() {
        for location in viewModel.locations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            marker.title = location.name
            marker.map = mapView
        }
    }
}

extension LiveMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        updateCameraPosition(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    private func updateCameraPosition(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DispatchQueue.main.async {
            let camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 12)
            self.mapView?.camera = camera
        }
    }
}








