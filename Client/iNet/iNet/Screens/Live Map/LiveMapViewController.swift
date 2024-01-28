//
//  MapViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import GoogleMaps

class LiveMapViewController: UIViewController {
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var mapView: GMSMapView?
    private let options = GMSMapViewOptions()
    private let viewModel = LiveMapViewModel()
    private var locations = Locations()
    private var busStopIcon: UIImageView?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        setupView()
        setupLocationManager()
    }
    
    private func setupView() {
        setupBackground()
        setupMapView()
        setupViewModel()
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor(resource: .background)
    }
    
    private func setupMapView() {
        setupOptions()
        setupMapViewProperties()
        setupIcon()
        view = mapView
    }
    
    private func setupOptions() {
        options.frame = view.bounds
        options.backgroundColor = .background
    }
    
    private func setupMapViewProperties() {
        mapView = GMSMapView(options:options)
        mapView?.isBuildingsEnabled = false
        mapView?.isIndoorEnabled = false
        mapView?.isMyLocationEnabled = true
    }
    
    private func setupIcon() {
        if let image = UIImage(systemName: "circle.fill.square.fill") {
            let tintedImage = image.withRenderingMode(.alwaysOriginal)
            let imageView = UIImageView(image: tintedImage)
            imageView.tintColor = UIColor(resource: .base)
            busStopIcon = imageView
        }
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        Task {
            await viewModel.viewDidLoad()
        }
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    private func loadBusStopsOnMap() {
        for location in locations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            marker.title = location.name
            marker.iconView = busStopIcon
            marker.tracksViewChanges = false
            marker.map = mapView
        }
    }
}

// MARK: - Extensions
extension LiveMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        updateCameraPosition(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    private func updateCameraPosition(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DispatchQueue.main.async {
            let camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 15)
            self.mapView?.camera = camera
        }
    }
}

extension LiveMapViewController: LiveMapViewModelDelegate {
    func locationsFetched(_ locations: Locations) {
        self.locations = locations
        DispatchQueue.main.async {
            self.loadBusStopsOnMap()
        }
    }
    
    func showError(_ error: Error) {
        print(error)
    }
}





