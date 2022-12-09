//
//  SettingsViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 11/30/22.
//

import UIKit
import FirebaseDatabase
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var currentGoalLabel: UILabel!
    @IBOutlet weak var currentProgressLabel: UILabel!
    
    var currentGoal: Double = 0.0
    var currentProgress: Double = 0.0
    var categories = [String]()
    var volunteerLogs = [HourLog]()
    var uid = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentGoalLabel.text = "Current Goal: \(currentGoal) Hours"
        currentProgressLabel.text = "Current Progress: \(currentProgress) Hours"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ChangeGoalClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Change Current Goal", message: "Type the new goal you'd like to have", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter New Goal"
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first?.text,
                  let newGoal = Double(textField)
            else {
                return
            }

            self.currentGoal = newGoal
            self.currentGoalLabel.text = "Current Goal: \(self.currentGoal) Hours"
            
        }))
        present(alert, animated: true)
    }
    
    @IBAction func ResetGoalProgressClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Progress?", message: "Are you sure you want to reset your goal progress to 0?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (action:UIAlertAction) in
            self.currentProgress = 0
            self.currentProgressLabel.text = "Current Goal: \(self.currentProgress) Hours"
        }))
        present(alert, animated: true)
        
    }
    
    @IBAction func EditCategoriesClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCategoriesScreen", sender: self)
    }
    
    @IBAction func ResetLogClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Volunteer Log?", message: "Are you sure you want to reset your Log? All saved logs and progress will be deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (action:UIAlertAction) in
            self.volunteerLogs.removeAll()
            let reference  = Database.database().reference().child("Users").child(self.uid)
            reference.removeValue()
        }))
        present(alert, animated: true)
    }
    
    
    // Send data through segue to edit screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategoriesScreen" {
            let destination = segue.destination as? CategoriesViewController
            //destination?.Logs = volunteerLogs
            destination?.categories = categories
        }
    }

}
