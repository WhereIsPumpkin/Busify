import UIKit
import MapKit

class LiveMapViewController: UIViewController {
    
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
    
}

// MARK: - Extensions
extension LiveMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        updateCameraPosition(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    private func updateCameraPosition(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DispatchQueue.main.async {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
            self.mapView?.setRegion(region, animated: true)
        }
    }
}

extension LiveMapViewController: MKMapViewDelegate {
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

extension LiveMapViewController: LiveMapViewModelDelegate {
    func busArrivalTimesFetched(_ stopID: ArrivalTimesResponse) {
        DispatchQueue.main.async {
            let vc = BusStopDetailsPage(arrivalTimes: stopID)
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
