//
//  HourLog.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 12/1/22.
//

import Foundation

class HourLog {
    
    var title: String
    var organization: String
    var supervisor: String
    var time: Double
    var date: Date
    var category: String
    var skills: [String]
    
    init(title: String, organization: String = "None", supervisor: String = "None", time: Double, date: Date, category: String = "None", skills: [String] = [String]()) {
        self.title = title
        self.organization = organization
        self.supervisor = supervisor
        self.time = time
        self.date = date
        self.category = category
        self.skills = skills
    }
}
