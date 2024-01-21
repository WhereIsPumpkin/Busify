//
//  WalletViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import MapKit



class WalletViewController: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!
        var selectedAnnotation: MKPointAnnotation?

        override func viewDidLoad() {
            super.viewDidLoad()

            mapView = MKMapView(frame: view.bounds)
            mapView.delegate = self
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(mapView)

            let coordinatesAndNames: [(Double, Double, String)] = [
                (41.78398907191343, 44.79957461357117, "მ/ს \"სარაჯიშვილი\" - [4018]"),
                (41.78574506714074, 44.79168355464935, "წყალსადენის ქუჩა - [1944]"),
                (41.78675504260968, 44.78240847587585, "ბობ უოლშის ქუჩა - [4165]"),
                (41.78730502256016, 44.77815985679627, "ქართულ-ამერიკული მეგობრობის გამზირი #23 - [4572]"),
                (41.78748501497378, 44.773428440094, "ქართულ ამერიკული მეგობრობის გამზირი #33 - [1537]"),
                (41.78750901392408, 44.76568222045898, "ანბანის სკვერი - [4267]"),
                (41.78906892642352, 44.76493656635285, "გიორგი ბრწყინვალის ქუჩა - [1180]"),
                (41.79210464731829, 44.7649472951889, "იოანე პეტრიწის ქუჩა - [2501]")
            ]

            for (latitude, longitude, name) in coordinatesAndNames {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = name
                mapView.addAnnotation(annotation)
            }

            if let initialCoordinate = coordinatesAndNames.first {
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: initialCoordinate.0, longitude: initialCoordinate.1), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                mapView.setRegion(region, animated: true)
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "pin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true

                let button = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = button
            } else {
                annotationView!.annotation = annotation
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                // A pin's callout accessory button was tapped
                if let annotation = view.annotation as? MKPointAnnotation {
                    // Store the selected annotation for use in the modal presentation
                    selectedAnnotation = annotation

                    // Show the modal
                    presentModal()
                }
            }
        }

        func presentModal() {
            // Implement your modal presentation logic here
            if let selectedAnnotation = selectedAnnotation {
                let alertController = UIAlertController(title: "Location Details", message: selectedAnnotation.title, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
}
