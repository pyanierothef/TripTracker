//
//  TripViewController.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import UIKit
import MapKit

class TripViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var toggleTrackingButton: UIButton!
    
    private var presenter : TripPresenter!
    
    private var currentPolyline: MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = TripController(tripView: self)
        if presenter.inTrip {
            toggleTrackingButton.setTitle("Stop", for: .normal)
            toggleTrackingButton.backgroundColor = .red
        } else {
            toggleTrackingButton.setTitle("Start", for: .normal)
            toggleTrackingButton.backgroundColor = .green
        }
        
        
        mapView.delegate = self
        
        LocationManager.defaultManager.requestAlwaysAuthorization()
    }
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleTracking(_ sender: Any) {
        if presenter.inTrip {
            presenter.endTrip()
        } else {
            presenter.startTrip()
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TripViewController : TripView {
    func didStartTrip() {
        toggleTrackingButton.setTitle("Stop", for: .normal)
        toggleTrackingButton.backgroundColor = .red
    }
    
    func didEndTrip() {
        toggleTrackingButton.setTitle("Start", for: .normal)
        toggleTrackingButton.backgroundColor = .green
        currentPolyline = nil
    }
    
    func updateTraveledPath(_ path: [CLLocationCoordinate2D]) {
        
        if let polyline = currentPolyline {
            mapView.removeOverlay(polyline)
        }
        currentPolyline = MKPolyline(coordinates: path, count: path.count)
        mapView.addOverlay(currentPolyline!)
        
        mapView.setVisibleMapRect(currentPolyline!.boundingMapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)
    }
}

extension TripViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 2
        
        return renderer
    }
}
