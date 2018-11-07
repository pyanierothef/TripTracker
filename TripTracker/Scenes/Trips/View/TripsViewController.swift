//
//  TripsViewController.swift
//  TripTracker
//
//  Created by Pablo Yaniero on 11/6/18.
//  Copyright © 2018 THEF. All rights reserved.
//

import UIKit

class TripsViewController: UITableViewController {

    var presenter : TripsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = TripsController(tripsView: self)
        presenter.updateTrips()
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tripDetailVC = segue.destination as? TripDetailViewController,
            let selectedRow = tableView.indexPathForSelectedRow?.row {
            tripDetailVC.presenter = TripDetailController(view: tripDetailVC, trip: presenter.trips[selectedRow])
        }
    }
 

}

extension TripsViewController : TripsView {
    func didUpdateTrips() {
        self.tableView.reloadData()
    }
}

extension TripsViewController  {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.trips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let trip = presenter.trips[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        
        cell.textLabel?.text = formatter.string(from: trip.startDate) + " - " + formatter.string(from: trip.endDate)
        
        return cell
    }
}

