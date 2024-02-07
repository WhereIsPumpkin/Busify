import UIKit
import MapKit

final class LiveMapScreen: UIViewController {
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var mapView: MKMapView?
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
        setupMapViewProperties()
        setupIcon()
        centerMapOnUserLocation()
        setupUserLocationButton()
        view = mapView
    }
    
    private func setupMapViewProperties() {
        mapView = MKMapView(frame: view.bounds)
        mapView?.showsUserLocation = true
        mapView?.delegate = self
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
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadBusStopsOnMap() {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            annotation.title = location.name
            annotation.subtitle = location.code
            mapView?.addAnnotation(annotation)
        }
    }
    
    private func setupUserLocationButton() {
        let userLocationButton = createUserLocationButton()
        addButtonToMapView(userLocationButton)
        configureButtonIcon(for: userLocationButton)
        setButtonConstraints(for: userLocationButton)
    }
    
    private func createUserLocationButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(centerMapOnUserButtonTapped), for: .touchUpInside)
        return button
    }
    
    private func configureButtonIcon(for button: UIButton) {
        let largeFont = UIFont.systemFont(ofSize: 60)
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, .base])
        let configuration = UIImage.SymbolConfiguration(font: largeFont).applying(config)
        
        if let locationIcon = UIImage(systemName: "location.circle.fill", withConfiguration: configuration) {
            button.setImage(locationIcon, for: .normal)
        }
    }
    
    private func setButtonConstraints(for button: UIButton) {
        guard let mapView = self.mapView else { return }
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -24),
            button.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            button.widthAnchor.constraint(equalToConstant: 60),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func addButtonToMapView(_ button: UIButton) {
        mapView?.addSubview(button)
    }
    
    @objc private func centerMapOnUserButtonTapped() {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView?.setRegion(region, animated: true)
        }
    }
    
    private func centerMapOnUserLocation() {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            if let currentLocation = locationManager.location?.coordinate {
                let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView?.setRegion(region, animated: true)
            }
        }
    }
}

// MARK: - Extensions
extension LiveMapScreen: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            presentLocationAccessAlert("Location Access Denied", "Please enable location services in Settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            if let currentLocation = locationManager.location?.coordinate {
                centerMapOn(currentLocation)
            } else {
                presentLocationAccessAlert("Location Unavailable", "Your current location cannot be determined.")
            }
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
        presentLocationAccessAlert("Location Error", "Failed to obtain location.")
    }

    private func presentLocationAccessAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    private func centerMapOn(_ location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView?.setRegion(region, animated: true)
    }
}

extension LiveMapScreen: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "MyMarker"
        var annotationView: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView.markerTintColor = UIColor.alternate
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation,
           let busStopCode = annotation.subtitle {
            fetchArrivalTimes(forBusStop: busStopCode)
        }
    }
    
    private func fetchArrivalTimes(forBusStop busStopCode: String) {
        Task {
            await viewModel.fetchBusStopArrivalTimes(stopID: busStopCode)
        }
    }
}

extension LiveMapScreen: LiveMapViewModelDelegate {
    func busArrivalTimesFetched(_ arrivalTimes: ArrivalTimesResponse, _ stopID: String) {
        DispatchQueue.main.async {
            let vc = BusStopDetailsScreen(arrivalTimes: arrivalTimes, stopId: stopID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func locationsFetched(_ locations: Locations) {
        self.locations = locations
        DispatchQueue.main.async {
            self.loadBusStopsOnMap()
        }
    }
    
    func showError(_ error: Error) {
        // TODO: - Error Handling
        print(error)
    }
}
