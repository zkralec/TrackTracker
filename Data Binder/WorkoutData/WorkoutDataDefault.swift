//
//  WorkoutDataDefault.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 10/17/24.
//

import Foundation

extension WorkoutData {
    var metersString: String {
        return meters.map { "\($0)" }.joined(separator: ", ")
    }
    
    var timesString: String {
        return times.map { "\($0)" }.joined(separator: ", ")
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}

