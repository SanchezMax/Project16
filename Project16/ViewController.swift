//
//  ViewController.swift
//  Project16
//
//  Created by Aleksey Novikov on 01.09.2023.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    var mapType: MKMapType = .standard {
        didSet {
            mapView.mapType = mapType
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMapType))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .purple
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        if let vc = storyboard?.instantiateViewController(identifier: "Website") as? WebViewController {
            vc.city = placeName
            navigationController?.pushViewController(vc, animated: true)
        }
        
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }
    
    @objc func changeMapType() {
        let ac = UIAlertController(title: "Choose a type of a map:", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Standart", style: .default) { _ in
            self.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { _ in
            self.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { _ in
            self.mapType = .hybrid
        })
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default) { _ in
            self.mapType = .satelliteFlyover
        })
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default) { _ in
            self.mapType = .hybridFlyover
        })
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default) { _ in
            self.mapType = .mutedStandard
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

