//
//  CategoriesViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 12/9/22.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories = [String]()
    
    @IBOutlet weak var catTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        catTableView.delegate = self
        catTableView.dataSource = self
    }
    
    @IBAction func addCategoryClick(_ sender: Any) {
        let alert = UIAlertController(title: "Add Category", message: "Type the category you'd like to add", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Skill"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first?.text
            else {
                return
            }
            self.categories.append(textField)
            self.catTableView.reloadData()
        }))
        present(alert, animated: true)
        
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cat_cell", for: indexPath)
        
        // Configure
        cell.textLabel?.text = categories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // add alert
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // add buttons to alert
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                // delete from table
                self.categories.remove(at: indexPath.row)
                self.catTableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            
            // present alert
            self.present(alert, animated: true)
        }
        
        return [delete]
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
