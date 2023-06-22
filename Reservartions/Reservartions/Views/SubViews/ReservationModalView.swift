//
//  ReservationModalView.swift
//  Reservartions
//
//  Created by HHS on 10/09/2022.
//

import SwiftUI

struct ReservationModalView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    
    @State var reservation: ReservationModal
    var body: some View {
        
        VStack (alignment: .leading){
            HStack {
                Text("Name: \(reservation.name)")
                
                Spacer()
            }
            HStack {
                Text("Game time: \(reservation.startHour)->\(reservation.endHour)")
                Spacer()
            }
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}


struct ReservationModalView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationModalView(reservation: ReservationModal(id: "", name: "Hello", startHour: "8:00 PM", endHour: "9:00 PM", date: "friday 21 oct"))
    }
}
