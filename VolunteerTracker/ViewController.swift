//
//  ViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 11/29/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var volunteerLogs = [HourLog]()

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "2016/10/08 22:31")!
        
        volunteerLogs.append(HourLog(title: "LOG 1", time: 2.0, date: someDateTime))
        
        tableview.dataSource = self
        tableview.delegate = self
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

    @IBAction func unwindfromBack(unwindSegue: UIStoryboardSegue) {
        // Reset view
        viewDidLoad()
    }
}

