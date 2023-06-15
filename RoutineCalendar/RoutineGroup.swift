import Foundation

class RoutineGroup{
    var routines = [Routine]()
    var fromDate, toDate: Date?
    var database: Database!
    var parentNotification: ((Routine?, DbAction?) -> Void)?
    
    init(parentNotification: ((Routine?, DbAction?) -> Void)? ){
        
        self.parentNotification = parentNotification
        
        database = DbFirebase(parentNotification: receivingNotification)
    }
    func receivingNotification(routine: Routine?, action: DbAction?){
        
        if let routine = routine{
            switch(action){
            case .Add: addRoutine(routine: routine)
            case .Modify: modifyRoutine(modifiedRoutine: routine)
            case .Delete: removeRoutine(removedRoutine: routine)
            default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(routine, action)
        }
    }
}

extension RoutineGroup{
    
    func queryRoutine(){
        routines.removeAll()
        database.queryRoutine()
    }
    
    func saveChange(routine: Routine, action: DbAction){
        database.saveChange(routine: routine, action: action)
    }
}

extension RoutineGroup{
    func getRoutines() -> [Routine] {
        return routines
    }
}

extension RoutineGroup{     // PlanGroup.swift
    
    private func count() -> Int{ return routines.count }
    
    private func find(_ key: String) -> Int?{
        for i in 0..<routines.count{
            if key == routines[i].key{
                return i
            }
        }
        return nil
    }
}

extension RoutineGroup{
    private func addRoutine(routine:Routine){ routines.append(routine) }
    private func modifyRoutine(modifiedRoutine: Routine){
        if let index = find(modifiedRoutine.key){
            routines[index] = modifiedRoutine
        }
    }
    private func removeRoutine(removedRoutine: Routine){
        if let index = find(removedRoutine.key){
            routines.remove(at: index)
        }
    }
    func changeRoutine(from: Routine, to: Routine){
        if let fromIndex = find(from.key), let toIndex = find(to.key) {
            routines[fromIndex] = to
            routines[toIndex] = from
        }
    }
}

extension RoutineGroup {
    func checkCount(date: Date) -> Int {
        var count = 0
        for r in routines {
            if(r.isChecked(date: date)) {
                count += 1;
            }
        }
        return count;
    }
}
