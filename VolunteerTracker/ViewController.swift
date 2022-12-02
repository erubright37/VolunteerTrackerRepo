//
//  ViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 11/29/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var goalHours: Double = 10.0
    var progress: Float = 0.0
    var totalHours: Double = 0.0
    var volunteerLogs = [HourLog]()

    //UI Elements
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var goalProgressBar: UIProgressView!
    @IBOutlet weak var goalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Goal and Total Hours
        CalculateSum()
        if totalHours > goalHours {
            progress = 1.0
        } else {
            progress = Float(totalHours)/Float(goalHours)
        }
        goalProgressBar.setProgress(Float(progress), animated: true)
        goalLabel.text = "Goal Progress: \(totalHours)/\(goalHours)"
        
        // Tableview
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    // Calculate sum of volunteer hours
    func CalculateSum() {
        totalHours = 0.0
        for item in volunteerLogs {
            totalHours += item.time
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return volunteerLogs.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id1", for: indexPath)
        
        // Configure
        cell.textLabel?.text = volunteerLogs[indexPath.row].title
        cell.detailTextLabel?.text = "\(volunteerLogs[indexPath.row].time) Hours"
        
        return cell
    }
    
    // Header Methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Logs"
    }
    
    // Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    // Unwind from back button on New Log Screen
    @IBAction func unwindfromNewLog(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? HourLogViewController {
            volunteerLogs += sourceViewController.Logs
        }
        tableview.reloadData()
        
        // Reset view
        viewDidLoad()
    }

    // Unwind from back button (doing nothing)
    @IBAction func unwindfromBack(unwindSegue: UIStoryboardSegue) {
        // Reset view
        viewDidLoad()
    }
}

