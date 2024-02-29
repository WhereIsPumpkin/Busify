import UIKit
import SwiftUI
import MapKit

final class LiveMapScreen: UIViewController {
    // MARK: - Properties
    let currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
    private let locationManager = CLLocationManager()
    private var mapView: MKMapView?
    private let viewModel = LiveMapViewModel()
    private var locations = Locations()
    private var modeSegmentedControl: UISegmentedControl!
    private let busIcon = UIImage(resource: .busIcon)
    private var busStopAnnotations: [MKAnnotation] = []
    private var busRouteAnnotations: [MKAnnotation] = []
    private var busLocationAnnotations: [MKAnnotation] = []
    private var busNumberTextFieldHostingController: UIHostingController<BusSearchTextField>?
    
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
        setupModeSegmentControl()
        setupDismissKeyboardGesture()
    }
    
    private func setupBackground() {
        view.backgroundColor = .background
    }
    
    private func setupMapView() {
        setupMapViewProperties()
        centerMapOnUserLocation()
        setupUserLocationButton()
        view = mapView
    }
    
    private func setupMapViewProperties() {
        mapView = MKMapView(frame: view.bounds)
        mapView?.showsUserLocation = true
        mapView?.delegate = self
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
        busStopAnnotations.removeAll()
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            annotation.title = location.name
            annotation.subtitle = location.code
            busStopAnnotations.append(annotation)
        }
        mapView?.addAnnotations(busStopAnnotations)
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
        
        if let annotationTitle = annotation.title, annotationTitle?.contains("Bus") ?? false {
            let busAnnotationIdentifier = "BusAnnotation"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: busAnnotationIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: busAnnotationIdentifier)
                annotationView?.canShowCallout = true
            }
            annotationView?.annotation = annotation
            
            annotationView?.image = busIcon.resizeImage(targetSize: CGSize(width: 32, height: 32))
            
            return annotationView
        } else {
            let busStopIdentifier = "BusStopMarker"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: busStopIdentifier) as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: busStopIdentifier)
                annotationView?.canShowCallout = true
            }
            annotationView?.annotation = annotation
            annotationView?.markerTintColor = .alternate
            
            annotationView?.glyphImage = UIImage(resource: .busStopIcon)
            
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation,
           let busStopCode = annotation.subtitle {
            fetchArrivalTimes(forBusStop: busStopCode)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
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
    
    func busRouteFetched(_ route: Route) {
        guard let shape = route.Shape, !shape.isEmpty else { return }
        let coordinates = convertShapeToCoordinates(shapeString: shape)
        drawRoute(with: coordinates)
    }
    
    func busLocationsFetched(_ buses: [Bus]) {
        updateBusLocations(buses)
    }
    
    func updateBusLocations(_ buses: [Bus]) {
        mapView?.removeAnnotations(busLocationAnnotations)
        busLocationAnnotations.removeAll()
        
        let newAnnotations = buses.map { bus -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: bus.lat, longitude: bus.lon)
            annotation.title = "Bus \(bus.routeNumber)"
            return annotation
        }
        mapView?.addAnnotations(newAnnotations)
        busLocationAnnotations.append(contentsOf: newAnnotations)
    }
    
    private func convertShapeToCoordinates(shapeString: String) -> [CLLocationCoordinate2D] {
        let pairs = shapeString.split(separator: ",").map(String.init)
        var coordinates: [CLLocationCoordinate2D] = []
        for pair in pairs {
            let parts = pair.split(separator: ":").map(String.init)
            if parts.count == 2, let lon = Double(parts[0]), let lat = Double(parts[1]) {
                coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            }
        }
        return coordinates
    }
    
    private func drawRoute(with coordinates: [CLLocationCoordinate2D]) {
        DispatchQueue.main.async { [weak self] in
            guard let mapView = self?.mapView else { return }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
}

// MARK: - Segment Control and Mode Handling
private extension LiveMapScreen {
    func setupModeSegmentControl() {
        let headerBackgroundView = UIView()
        headerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        headerBackgroundView.backgroundColor = .background
        headerBackgroundView.isUserInteractionEnabled = true
        
        
        modeSegmentedControl = UISegmentedControl(items: [NSLocalizedString("busStops", comment: ""), NSLocalizedString("busRoutes", comment: "")])
        modeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        modeSegmentedControl.selectedSegmentIndex = 0
        modeSegmentedControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        
        let font: UIFont
        if currentLanguage == "ka" {
            font = AppFont.forLanguage("ka", style: .semibold).uiFont(size: 14)
        } else {
            font = AppFont.forLanguage("en", style: .medium).uiFont(size: 14)
        }
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.gray
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        
        modeSegmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        modeSegmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        view.addSubview(headerBackgroundView)
        headerBackgroundView.addSubview(modeSegmentedControl)
        
        NSLayoutConstraint.activate([
            headerBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            headerBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerBackgroundView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.16),
            
            
            modeSegmentedControl.bottomAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: -20),
            modeSegmentedControl.centerXAnchor.constraint(equalTo: headerBackgroundView.centerXAnchor),
            modeSegmentedControl.widthAnchor.constraint(equalTo: headerBackgroundView.widthAnchor, multiplier: 0.9),
            modeSegmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func modeChanged() {
        updateUIForSelectedMode()
    }
    
    func updateUIForSelectedMode() {
        switch modeSegmentedControl.selectedSegmentIndex {
        case 0:
            mapView?.removeAnnotations(mapView?.annotations ?? [])
            mapView?.addAnnotations(busStopAnnotations)
            clearPreviousRoutesAndLocations()
            removeBusNumberTextField()
        case 1:
            mapView?.removeAnnotations(mapView?.annotations ?? [])
            mapView?.addAnnotations(busRouteAnnotations)
            setupBusNumberTextField()
        default: break
        }
    }
    
    
    func removeBusNumberTextField() {
        busNumberTextFieldHostingController?.view.removeFromSuperview()
        busNumberTextFieldHostingController?.removeFromParent()
        busNumberTextFieldHostingController = nil
    }
    
    func clearPreviousRoutesAndLocations() {
        mapView?.removeOverlays(mapView?.overlays ?? [])
        mapView?.removeAnnotations(busRouteAnnotations)
        mapView?.removeAnnotations(busLocationAnnotations)
        busRouteAnnotations.removeAll()
        busLocationAnnotations.removeAll()
    }
    
}

// MARK: - UI Setup for Bus Number TextField and Fetch Route Button
private extension LiveMapScreen {
    func setupBusNumberTextField() {
        let swiftUIView = BusSearchTextField(onSearch: { text in
            self.dismissKeyboard()
            self.clearPreviousRoutesAndLocations()
            Task {
                await self.viewModel.fetchRouteAndBuses(for: text)
            }
        }, onResend: { text in
            Task {
                await self.viewModel.refreshBusLocations(routeNumber: text)
            }
        })
        
        busNumberTextFieldHostingController = UIHostingController(rootView: swiftUIView)
        guard let busNumberTextFieldView = busNumberTextFieldHostingController?.view else { return }
        
        addChild(busNumberTextFieldHostingController!)
        busNumberTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        busNumberTextFieldView.backgroundColor = .clear
        busNumberTextFieldView.isOpaque = false
        view.addSubview(busNumberTextFieldView)
        busNumberTextFieldHostingController?.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            busNumberTextFieldView.topAnchor.constraint(equalTo: modeSegmentedControl.bottomAnchor, constant: 32),
            busNumberTextFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            busNumberTextFieldView.widthAnchor.constraint(equalToConstant: 160),
            busNumberTextFieldView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}

extension LiveMapScreen {
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
