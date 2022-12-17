//
//  SummaryViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 12/17/22.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var summaryView: UITextView!
    var volunteerSummary = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        summaryView.text = volunteerSummary
    }

}
