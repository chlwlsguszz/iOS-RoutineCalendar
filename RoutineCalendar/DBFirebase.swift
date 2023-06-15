import Foundation
import FirebaseFirestore

class DbFirebase: Database {
    
    var reference: CollectionReference
    var parentNotification: ((Routine?, DbAction?) -> Void)?
    var existQuery: ListenerRegistration?
    
    required init(parentNotification: ((Routine?, DbAction?) -> Void)?) {
        self.parentNotification = parentNotification
        reference = Firestore.firestore().collection("routines")
    }
}

extension DbFirebase{
    
    func saveChange(routine: Routine, action: DbAction){
        if action == .Delete{
            reference.document(routine.key).delete()
            return
        }
        
        let storeData: [String : Any] = ["data": routine.toDict(), "checkedDates": routine.checkedDates]
        reference.document(routine.key).setData(storeData)
    }
}

extension DbFirebase{
    
    func queryRoutine() {
        
        if let existQuery = existQuery{    // 이미 적용 쿼리가 있으면 제거, 중복 방지
            existQuery.remove()
        }
        
        existQuery = reference.addSnapshotListener(onChangingData)
    }
}

extension DbFirebase{
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?){
        guard let querySnapshot = querySnapshot else{ return }
        if(querySnapshot.documentChanges.count <= 0){
            if let parentNotification = parentNotification { parentNotification(nil, nil)}
        }
        for documentChange in querySnapshot.documentChanges {
            let data = documentChange.document.data()
            let routine = Routine()
            routine.checkedDates = data["checkedDates"] as! [String: Bool]
            if let dictData = data["data"] as? [String: Any] {
                routine.toRoutine(dict: dictData)
            }
            var action: DbAction?
            switch(documentChange.type){
            case .added: action = .Add
            case .modified: action = .Modify
            case .removed: action = .Delete
            }
            if let parentNotification = parentNotification { parentNotification(routine, action) }
            
            
        }
    }
}
