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
    var logToSend: HourLog!
    var currentIndex = 0

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
    
    // Segue to Edit screen
    @IBAction func AddLogScreenClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toNewLogScreen", sender: self)
    }
    
    // Send data through segue to edit screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewLogScreen" {
            let destination = segue.destination as? HourLogViewController
            destination?.Logs = volunteerLogs
        }
        
        if segue.identifier == "toEditLogScreen" {
            let destination = segue.destination as? EditLogViewController
            destination?.Logs = volunteerLogs
            destination?.currentLog = logToSend
            destination?.currentIndex = currentIndex
        }
    }
    
    // Selected row triggers segue to article details view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        logToSend = volunteerLogs[indexPath.row]
        currentIndex = indexPath.row
        
        self.performSegue(withIdentifier: "toEditLogScreen", sender: self)
    }
    
    // Unwind from back button on Edit Log Screen
    @IBAction func unwindfromEditLog(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? EditLogViewController {
            volunteerLogs = sourceViewController.Logs
        }
        
        // Reset view
        tableview.reloadData()
        viewDidLoad()
    }
    
    // Unwind from back button on New Log Screen
    @IBAction func unwindfromNewLog(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? HourLogViewController {
            volunteerLogs = sourceViewController.Logs
        }
        
        // Reset view
        tableview.reloadData()
        viewDidLoad()
    }

    // Unwind from back button (doing nothing)
    @IBAction func unwindfromBack(unwindSegue: UIStoryboardSegue) {
        // Reset view
        viewDidLoad()
    }
}

