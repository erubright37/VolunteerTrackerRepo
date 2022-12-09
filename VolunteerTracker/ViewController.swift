//
//  ViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 11/29/22.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var goalHours: Double = 10.0
    var progress: Float = 0.0
    var totalHours: Double = 0.0
    var volunteerLogs = [HourLog]()
    var logToSend: HourLog!
    var currentIndex = 0
    var lastIndex = 0
    var categories = [String]()
    
    let ref = Database.database().reference(withPath: "Users")
    var userRef: DatabaseReference!
    
    var uid = ""
    var signedIn = false

    //UI Elements
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var goalProgressBar: UIProgressView!
    @IBOutlet weak var goalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tableview
        tableview.dataSource = self
        tableview.delegate = self
        
        if signedIn == false {
            volunteerLogs.removeAll()
            tableview.reloadData()
            
            categories.append("Tutoring")
            categories.append("Serving Food")
            categories.append("Clean Up")
        }
        
        if let user = FirebaseAuth.Auth.auth().currentUser {
            volunteerLogs.removeAll()
            
            uid = user.uid
            userRef = ref.child(uid).child("Logs")
            signedIn = true
            
            
            if let user = FirebaseAuth.Auth.auth().currentUser {
                uid = user.uid
                userRef = ref.child(uid)
                signedIn = true
                
                userRef.getData(completion: { error, snapshot in
                    guard error == nil else {
                      print(error!.localizedDescription)
                      return;
                    }
                    
                    if let entries = snapshot?.value as? [String : Any] {
                        for entry in entries {
                            if entry.key == "Goal" {
                                guard let goal = entry.value as? [String : Any]
                                else { return }
                                for item in goal {
                                    self.goalHours = item.value as! Double
                                }
                            }
                            
                            if entry.key == "Progress" {
                                guard let progress = entry.value as? [String : Any]
                                else { return }
                                for item in progress {
                                    self.totalHours = item.value as! Double
                                }
                            }
                            
                            if entry.key == "Cat" {
                                guard let cat = entry.value as? [String: Any]
                                else { return }
                                self.categories.removeAll()
                                for category in cat {
                                    guard let cats = category.value as? [String : Any]
                                    else { return }
                                    for item in cats {
                                        let categoryToAdd = item.value as! String
                                        self.categories.append(categoryToAdd)
                                    }
                                }
                            }
                        }
                        
                    }
                    
                });
                
                userRef.child("Logs").observe(.childAdded, with: { (snapshot) in
                    
                    if let logs = snapshot.value as? [String : Any] {
                        for item in logs {
                            guard let log = item.value as? [String : Any]
                            else { return }
                            
                            guard let logPath = log["ID"] as? String,
                                  let title = log["title"] as? String,
                                  let organization = log["organization"] as? String,
                                  let supervisor = log["supervisor"] as? String,
                                  let category = log["category"] as? String,
                                  let date = log["date"] as? String,
                                  let time = log["time"] as? String
                            else { return }
                            
                            var skill = [String]()
                            if let skills = log["Skills"] as? [String: Any] {
                                for thing in skills {
                                    let skillToAdd = thing.value as! String
                                    skill.append(skillToAdd)
                                }
                            }
                            
                            let logIndex = Int(logPath)
                            
                            self.volunteerLogs.append(HourLog(logID: logIndex!, title: title, organization: organization, supervisor: supervisor, time: Double(time)!, date: date, category: category, skills: skill))
                            
                            self.lastIndex = logIndex! + 1
                        }
                    }
                    self.tableview.reloadData()
                    
                    // Goal and Total Hours
                    self.CalculateSum()
                    if self.totalHours > self.goalHours {
                        self.progress = 1.0
                    } else {
                        self.progress = Float(self.totalHours)/Float(self.goalHours)
                    }
                    self.goalProgressBar.setProgress(Float(self.progress), animated: true)
                    self.goalLabel.text = "Goal Progress: \(self.totalHours)/\(self.goalHours)"
                });
            }
        }
        
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
        if signedIn == true {
            return volunteerLogs.count
        } else {
            return 1
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id1", for: indexPath)
        
        if signedIn == true {
            // Configure
            cell.textLabel?.text = volunteerLogs[indexPath.row].title
            cell.detailTextLabel?.text = "\(volunteerLogs[indexPath.row].time) Hours"
        } else {
            cell.textLabel?.text = "Please Sign In to See Your Log"
        }
        
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
        if signedIn == true {
            self.performSegue(withIdentifier: "toNewLogScreen", sender: self)
        } else {
            let alert = UIAlertController(title: "Please Sign In to Add New Log", message: "You must sign in before the log can be changed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Canel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (action:UIAlertAction) in
                self.performSegue(withIdentifier: "toSignInScreen", sender: self)

            }))

            present(alert, animated: true)
        }
    }
    
    // Send data through segue to edit screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewLogScreen" {
            let destination = segue.destination as? HourLogViewController
            //destination?.Logs = volunteerLogs
            destination?.logIndex = lastIndex
            destination?.categories = categories
        }
        
        if segue.identifier == "toEditLogScreen" {
            let destination = segue.destination as? EditLogViewController
            destination?.Logs = volunteerLogs
            destination?.currentLog = logToSend
            destination?.currentIndex = currentIndex
            destination?.categories = categories
            destination?.uid = uid
        }
        
        if segue.identifier == "toSettngsScreen" {
            let destination = segue.destination as? SettingsViewController
            destination?.currentGoal = goalHours
            destination?.currentProgress = totalHours
            destination?.categories = categories
            destination?.volunteerLogs = volunteerLogs
            destination?.uid = uid
        }
    }
    
    // Selected row triggers segue to article details view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if signedIn == true {
            logToSend = volunteerLogs[indexPath.row]
            currentIndex = indexPath.row
            
            self.performSegue(withIdentifier: "toEditLogScreen", sender: self)
        } else {
            let alert = UIAlertController(title: "Please Sign In to Edit Log", message: "You must sign in before the log can be changed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Canel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (action:UIAlertAction) in
                self.performSegue(withIdentifier: "toSignInScreen", sender: self)

            }))

            present(alert, animated: true)
        }
    }
    
    // Unwind from back button on Edit Log Screen
    @IBAction func unwindfromEditLog(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? EditLogViewController {
            volunteerLogs = sourceViewController.Logs
            tableview.reloadData()
            
            var logPath = ""
            for log in sourceViewController.Logs {
                
                        if log.logID <= 100 {
                            logPath = "log\(log.logID)"
                        }else if log.logID >= 10 {
                            logPath = "log0\(log.logID)"
                        } else {
                            logPath = "log00\(log.logID)"
                        }
                
                let reference  = Database.database().reference().child("Users").child(uid).child("Logs").child(logPath)
                let logDict: [String : [String : String]] = [logPath: ["ID": log.logID.description, "title": log.title, "organization": log.organization, "supervisor": log.supervisor, "time": log.time.description, "date": log.date.description, "category": log.category]]
                
                reference.updateChildValues(logDict)
                
                let skillRef = reference.child(logPath).child("Skills")
                var skillIndex = 0
                var skillDict = [String: String]()
                for skill in log.skills {
                    skillDict["Skill\(skillIndex)"] = skill
                    skillIndex += 1
                }
                
                skillRef.setValue(skillDict) {
                  (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                      print("Data could not be saved: \(error).")
                    } else {
                      print("Data saved successfully!")
                    }
                  }
            }
        }

    }
    
    // Unwind from back button on New Log Screen
    @IBAction func unwindfromNewLog(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? HourLogViewController {
            //volunteerLogs += sourceViewController.Logs
            lastIndex = sourceViewController.logIndex
            
            var logPath = ""
            for log in sourceViewController.Logs {
                
                        if log.logID <= 100 {
                            logPath = "log\(log.logID)"
                        }else if log.logID >= 10 {
                            logPath = "log0\(log.logID)"
                        } else {
                            logPath = "log00\(log.logID)"
                        }
                
                let reference  = Database.database().reference().child("Users").child(uid).child("Logs").child(logPath)
                let logDict: [String : [String : String]] = [logPath: ["ID": log.logID.description, "title": log.title, "organization": log.organization, "supervisor": log.supervisor, "time": log.time.description, "date": log.date.description, "category": log.category]]
                
                reference.setValue(logDict)
                
                let skillRef = reference.child(logPath).child("Skills")
                var skillIndex = 0
                var skillDict = [String: String]()
                for skill in log.skills {
                    skillDict["Skill\(skillIndex)"] = skill
                    skillIndex += 1
                }
                
                skillRef.setValue(skillDict) {
                  (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                      print("Data could not be saved: \(error).")
                    } else {
                      print("Data saved successfully!")
                    }
                  }
            }
        }
        // Goal and Total Hours
        self.CalculateSum()
        if self.totalHours > self.goalHours {
            self.progress = 1.0
        } else {
            self.progress = Float(self.totalHours)/Float(self.goalHours)
        }
        self.goalProgressBar.setProgress(Float(self.progress), animated: true)
        self.goalLabel.text = "Goal Progress: \(self.totalHours)/\(self.goalHours)"
    }

    // Unwind from back button (doing nothing)
    @IBAction func unwindfromSettings(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? SettingsViewController {
            volunteerLogs = sourceViewController.volunteerLogs
            categories = sourceViewController.categories
            goalHours = sourceViewController.currentGoal
            totalHours = sourceViewController.currentProgress
            
            let reference  = Database.database().reference().child("Users").child(uid)
            
            let goalDict: [String: Double] = ["Goal": goalHours]
            reference.child("Goal").setValue(goalDict)
            
            let progressDict: [String: Double] = ["Progress": totalHours]
            reference.child("Progress").setValue(progressDict)
            
            let catRef = reference.child("Cat").child("Categories")
            var catIndex = 0
            var catDict = [String: String]()
            for cat in categories {
                catDict["Skill\(catIndex)"] = cat
                catIndex += 1
            }
            
            catRef.setValue(catDict) {
              (error:Error?, ref:DatabaseReference) in
                if let error = error {
                  print("Data could not be saved: \(error).")
                } else {
                  print("Data saved successfully!")
                }
              }
            
        }
        
        // Reset view
        tableview.reloadData()
    }
    
    // Unwind from back button (doing nothing)
    @IBAction func unwindfromBack(unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? SignInViewController {
            signedIn = sourceViewController.signedIn
            uid = sourceViewController.uid
        }
        
        // Reset view
        tableview.reloadData()
    }
    
}

