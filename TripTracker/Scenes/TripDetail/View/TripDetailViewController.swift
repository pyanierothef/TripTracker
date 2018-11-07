//
//  TripDetailViewController.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/7/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import UIKit
import MapKit

class TripDetailViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var presenter : TripDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        drawPath()
    }
    
    func drawPath() {
        let locations = presenter.trip.waypoints.map { waypoint in
            return CLLocationCoordinate2DMake(waypoint.latitude, waypoint.longitude)
        }
        
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyline)
        
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)
    }
    
}

extension TripDetailViewController : TripDetailView {
    
}

extension TripDetailViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 2
        
        return renderer
    }
}
