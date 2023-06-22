//
//  ReservationModal.swift
//  Reservartions
//
//  Created by HHS on 10/09/2022.
//

import Foundation

struct ReservationModal : Codable, Hashable {
    
    var id : String
    var name: String
    var startHour: String
    var endHour: String
    var date: String
    
    
    var startTimeInt: Int {

        let index = startHour.index(startHour.startIndex, offsetBy: 2)
        let mySubstring = startHour.prefix(upTo: index)
        var intStartTime = Int(mySubstring)
        
        let index1 = startHour.index(startHour.endIndex, offsetBy: -2)
        let PmOrAM = startHour.suffix(from: index1)
        
        
        if intStartTime == nil{
            let index = startHour.index(startHour.startIndex, offsetBy: 1)
            let mySubstring = startHour.prefix(upTo: index)
            var time = Int(mySubstring)!
            if PmOrAM == "PM" {
                time = time + 12
            }
            return time

        }else{
            if PmOrAM == "PM" {
                intStartTime = intStartTime! + 12
            }
            return intStartTime!
        }
    }
}
