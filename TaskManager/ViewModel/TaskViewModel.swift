//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by kazunari_ueeda on 2022/01/10.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var storedTasks: [Task] = [
        Task(title: "English", description: "Room 207", doneFlag: false, date: Date(timeInterval: 60, since: Date.now)),
        Task(title: "Pre-Calculus 12", description: "Room 305", doneFlag: false, date: Date(timeInterval: 60*5, since: Date.now)),
        Task(title: "Law", description: "Room 217", doneFlag: false, date: Date(timeInterval: 60*10, since: Date.now)),
        Task(title: "lunch", description: "", doneFlag: false, date: Date(timeInterval: 60*15, since: Date.now)),
        Task(title: "Careers", description: "Room 201", doneFlag: false, date: Date(timeInterval: 60*20, since: Date.now)),

    ]
    
    // MARK: - Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: - Filtering Today Tasks
    @Published var filteredTasks: [Task]?
    
    // MARK: - Initializing
    init() {
        filterTodayTasks()
    }
    
    // MARK: - Filter Today Tasks
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.date, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.date > task1.date
                }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }
    
    // MARK: - Checking if the currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
