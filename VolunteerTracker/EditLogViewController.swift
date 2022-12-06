//
//  EditLogViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 12/6/22.
//

import UIKit

class EditLogViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var Logs = [HourLog]()
    var currentLog: HourLog!
    var currentIndex = 0
    var categories = [String]()
    var skills = [String]()

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var organizationText: UITextField!
    @IBOutlet weak var supervisorText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var skillTableview: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories.append("Tutoring")
        categories.append("Serving Food")
        categories.append("Outdoors")
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        skillTableview.dataSource = self
        skillTableview.delegate = self
        skills = currentLog.skills
        skillTableview.reloadData()
        
        titleText.text = currentLog.title
        organizationText.text = currentLog.organization
        supervisorText.text = currentLog.supervisor
        timeText.text = currentLog.time.description
        //datePicker.date = currentLog.date.
    }
    
    @IBAction func SaveLogClicked(_ sender: UIButton) {
        guard let title = titleText.text,
              let hours = timeText.text,
              let time = Double(hours)
        else {
            let alert = UIAlertController(title: "Please Complete Required Fields", message: "Title, Total Hours, and Date are required.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        var organization = ""
        var supervisor = ""
        var category = ""
        
        if organizationText.text != nil {
            organization = organizationText.text!
        }
        
        if supervisorText.text != nil {
            supervisor = supervisorText.text!
        }
        
        if categories[categoryPicker.selectedRow(inComponent: 0)] != nil {
            category = categories[categoryPicker.selectedRow(inComponent: 0)]
        }
        Logs.remove(at: currentIndex)
        
        Logs.insert(HourLog(title: title, organization: organization, supervisor: supervisor, time: time, date: datePicker.date.description, category: category, skills: skills), at: currentIndex)
        
        // Clear UI Elements
        titleText.text = ""
        organizationText.text = ""
        supervisorText.text = ""
        timeText.text = ""
        skills.removeAll()
        skillTableview.reloadData()
        
        backBtn.sendActions(for: .touchUpInside)
    }
    
    @IBAction func DeleteLogClicked(_ sender: UIButton) {
        Logs.remove(at: currentIndex)
        
        // Clear UI Elements
        titleText.text = ""
        organizationText.text = ""
        supervisorText.text = ""
        timeText.text = ""
        skills.removeAll()
        skillTableview.reloadData()
        
        backBtn.sendActions(for: .touchUpInside)
    }
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skill_cell", for: indexPath)
        
        // Configure
        cell.textLabel?.text = skills[indexPath.row]
        
        return cell
    }
    
    @IBAction func AddSkillClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Skill", message: "Type the skill you'd like to add", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Skill"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first?.text
            else {
                return
            }
            self.skills.append(textField)
            self.skillTableview.reloadData()
        }))
        present(alert, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
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