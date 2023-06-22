//
//  AddingReservation.swift
//  Reservartions
//
//  Created by HHS on 10/09/2022.
//

import SwiftUI

struct AddingReservation: View {
    
    // MARK: Proprities
    @ObservedObject private var firestoreManger = FirestoreManager()

    @Binding var isPresented: Bool
    @State var username = ""
    @State var reservationStartTime = Date()
    @State var reservationEndTime = Date()
    @State var reservstionDate =  Date()

    @State var shouldAnimate = false

    // MARK: FUNCTIONS
    func saveResevation(){

        shouldAnimate = true
        let startTime = reservationStartTime.formatted(date: .omitted, time: .shortened)
        let endTime = reservationEndTime.formatted(date: .omitted, time: .shortened)
        let date = reservstionDate.formatted(date: .complete, time: .omitted)
        
        let reservationModal = ReservationModal(id: "", name: username, startHour: startTime, endHour: endTime, date: date)
        
        firestoreManger.saveReservation(reservationInfo: reservationModal) {
            firestoreManger.setTheReservationID {
                shouldAnimate = false
                isPresented.toggle()
            }

        }
        
    }
    
    var body: some View {
        ZStack{
            VStack{
                GroupBox{
                    HStack{
                        Text("Name:")
                        Spacer()
                        TextField("", text: $username)
                            .padding(.horizontal)
                        
                    }
                    
                }
                GroupBox{
                    HStack{
                        Text("Time: ")
                        
                        DatePicker("", selection: $reservationStartTime, displayedComponents: .hourAndMinute)
                        
                        Text("->")
                        DatePicker("", selection: $reservationEndTime, displayedComponents: .hourAndMinute)
                    }
                }
                GroupBox{
                    HStack{
                        Text("Day: ")
                        DatePicker("", selection: $reservstionDate, in: Date()..., displayedComponents: .date)
                    }
                }
                HStack{
                    if shouldAnimate == true{
                        ActivityIndicator(shouldAnimate: $shouldAnimate)
                    }else{
                        Button {
                            saveResevation()
                        } label: {
                            Text("   Save reservation   ")
                        }.buttonStyle(CustomButtonStyle())
                            .padding()
                    }
                    
                    
                }
            }.padding()
        }.ignoresSafeArea()
    }
}

struct AddingReservation_Previews: PreviewProvider {
    @State static var tempbool = true
    static var previews: some View {
        AddingReservation(isPresented: $tempbool)
    }
}
