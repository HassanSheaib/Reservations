//
//  LandingScreen.swift
//  Reservartions
//
//  Created by HHS on 10/09/2022.
//


import SwiftUI
import FirebaseFirestore

struct LandingScreen: View {
    @ObservedObject private var firestoreManger = FirestoreManager()
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var day =  Date()
    @State var isPresented = false
    @State var dailyReservations : [ReservationModal] = []
    
    @State private var shouldAnimate = false
    @State private var showingAlert = false
    
    @State var indicies : IndexSet?
    

    
    func getdailyReservations(date: Date){
        
        
        let reservationdate = date.formatted(date: .complete, time: .omitted)
        
        firestoreManger.getDailyReservation(date: reservationdate) { reservations in
            
            for reservation in reservations {
                
                if reservation.id == ""{
                    print(reservation)
                    firestoreManger.setTheReservationID {
                        getdailyReservations(date: date)
                    }
                }
            }
            dailyReservations = reservations
            shouldAnimate = false
        }
    }

    func deleteReservation(indices: IndexSet) {
        shouldAnimate = true

        for index in indices{
            print(index)
            let reservation = dailyReservations[index]
            firestoreManger.deleteReservation(reservationObject: reservation) {
                getdailyReservations(date: day)
                shouldAnimate = false
            }
        }
    }
    
    
    
    var body: some View {
        VStack{
            DatePicker("", selection: $day, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(height: 350)
            
            VStack{
                HStack{
                    Text("Number of reservations: \(dailyReservations.count)")
                        .bold()
                        .font(.headline)
                    Spacer()

                }.padding()
                if shouldAnimate == true{
                    ActivityIndicator(shouldAnimate: $shouldAnimate)
                }else{
                    if dailyReservations.isEmpty{
                        Text("No Reservations for today!!")
                        Spacer()
                    }else{
                        List{
                            ForEach(dailyReservations, id: \.self){ reservation in
                                
                                ReservationModalView(reservation: reservation)
                                    .padding(.bottom)
                            }
                            .onDelete  { indices in
                                
                                showingAlert.toggle()
                                indicies = indices
                            }
                        }
                        
                    }
                }
                Spacer()
            }.border(colorScheme == .dark ? .white : .black, width: 3)
            Spacer()
            
            Button {
                isPresented.toggle()
            } label: {
                Text("    Add Reservation    ")
                    .bold()
                
            }
        }
        .onChange(of: day, perform: { newValue in
            shouldAnimate = true
            getdailyReservations(date: newValue)
        })
        
        
        .task {
            shouldAnimate = true
            getdailyReservations(date: day)
            
        }
        .sheet(isPresented: $isPresented) {
            getdailyReservations(date: day)
        } content: {
            AddingReservation(isPresented: $isPresented)
        }
        .alert(isPresented:$showingAlert) {
            Alert(
                title: Text("Are you sure your want to delete the reservation"),
                message: Text("Deleted Reservations cannot be recovered"),
                
                primaryButton: .destructive(Text("Delete")) {
                    
                    self.deleteReservation(indices: indicies!)
                    dailyReservations.remove(atOffsets: indicies!)
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct LandingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LandingScreen( dailyReservations: [])
    }
}
