//
//  FirestoreManger.swift
//  Reservartions
//
//  Created by HHS on 10/09/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject{
    
    private var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func saveReservation(reservationInfo: ReservationModal,  handler:  @escaping () -> ()) {
        do {
            _ = try db.collection("reservations").addDocument(from: reservationInfo) { err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("Document has been saved!")
                    handler()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setTheReservationID(handler:  @escaping () -> ()){
        db.collection("reservations").whereField(dataBaseFields.id, isEqualTo: "").getDocuments{ (querySnapshot, error) in
            
            for document in querySnapshot!.documents {
                
                let id = document.documentID
                let name = document.get(dataBaseFields.name) as? String
                let startHour = document.get(dataBaseFields.startHour) as? String
                let endHour = document.get(dataBaseFields.endHour) as? String
                let date = document.get(dataBaseFields.date) as? String
                
                let reservation = ReservationModal(id: id, name: name!, startHour: startHour!, endHour: endHour!, date: date!)
               
                do {
                    _ = try self.db.collection("reservations").document(id).setData(from: reservation) { err in
                        if let err = err {
                            print(err.localizedDescription)
                        } else {
                            print("Document has been saved!")
                            handler()
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }

            }
        }
    //MARK: RETURNING Reservation for the specified date
    
    func getDailyReservation(date: String, handler: @escaping (_ reservations: [ReservationModal])  -> ()) {
        db.collection("reservations").whereField(dataBaseFields.date, isEqualTo: date).getDocuments{ (querySnapshot, error) in
            handler(self.returnDailyReservationData(querySnapshot: querySnapshot))
            
        }
    }
    private func returnDailyReservationData(querySnapshot: QuerySnapshot?)  -> [ReservationModal] {
        
        print("hello")
        var reservations : [ReservationModal] = []
        
        for document in querySnapshot!.documents {
            let id = document.get(dataBaseFields.id) as? String
            let name = document.get(dataBaseFields.name) as? String
            let startHour = document.get(dataBaseFields.startHour) as? String
            let endHour = document.get(dataBaseFields.endHour) as? String
            let date = document.get(dataBaseFields.date) as? String
            let reservation = ReservationModal(id: id!, name: name!, startHour: startHour!, endHour: endHour!, date: date!)


            reservations.append(reservation)

        }
        let sortedArray = reservations.sorted{
            $0.startTimeInt < $1.startTimeInt
        }
        return sortedArray
    }
    
    func deleteReservation(reservationObject: ReservationModal, handler: @escaping ()->()){
        
                    db.collection("reservations").document(reservationObject.id).delete { (error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("reservation Deleted")
                                handler()
                            }
                        }
        
    }
    
    
}

