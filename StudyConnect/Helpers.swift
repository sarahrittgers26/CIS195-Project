//
//  Helpers.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/13/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import Foundation
import UIKit
import EventKit

struct Helpers {
    
    static func showErrorAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        return alert
    }
    
    static func sizeLabelToFit(label: UILabel) {
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
    }
    
    static func addCalendarEvent(title: String, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted: Bool, error: Error?) in
            if (granted && error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    static func formatDateAsString(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy hh:mm a"
        return dateformatter.string(from: date)
    }
    
}
