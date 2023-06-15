//
//  PlanGroup.swift
//  ch09-최진현-tableView
//
//  Created by 최진현 on 2023/05/01.
//

import Foundation

class RoutineGroup: NSObject{
    var routines = [Routine]()            // var plans: [Plan] = []와 동일, 퀴리를 만족하는 plan들만 저장한다.
    var fromDate, toDate: Date?     // queryPlan 함수에서 주어진다.
    var database: Database!
    var parentNotification: ((Routine?, DbAction?) -> Void)?
    
    init(parentNotification: ((Routine?, DbAction?) -> Void)? ){
        super.init()
        self.parentNotification = parentNotification
        //database = DbMemory(parentNotification: receivingNotification) // 데이터베이스 생성
        database = DbFirebase(parentNotification: receivingNotification) // 데이터베이스 생성
    }
    func receivingNotification(routine: Routine?, action: DbAction?){
        // 데이터베이스로부터 메시지를 받고 이를 부모에게 전달한다
        if let routine = routine{
            switch(action){    // 액션에 따라 적절히     plans에 적용한다
                case .Add: addRoutine(routine: routine)
                case .Modify: modifyRoutine(modifiedRoutine: routine)
                case .Delete: removeRoutine(removedRoutine: routine)
                default: break
            }
        }
        if let parentNotification = parentNotification{
            parentNotification(routine, action) // 역시 부모에게 알림내용을 전달한다.
        }
    }
}

extension RoutineGroup{    // PlanGroup.swift
    
    func queryRoutine(date: Date){
        routines.removeAll()    // 새로운 쿼리에 맞는 데이터를 채우기 위해 기존 데이터를 전부 지운다
        
        // date가 속한 1개월 +-알파만큼 가져온다
        fromDate = date.firstOfMonth().firstOfWeek()// 1일이 속한 일요일을 시작시간
        toDate = date.lastOfMonth().lastOfWeek()    // 이달 마지막일이 속한 토요일을 마감시간
        database.queryRoutine(fromDate: fromDate!, toDate: toDate!)
    }
    
    func saveChange(routine: Routine, action: DbAction){
        // 단순히 데이터베이스에 변경요청을 하고 plans에 대해서는
        // 데이터베이스가 변경알림을 호출하는 receivingNotification에서 적용한다
        database.saveChange(routine: routine, action: action)
    }
}

extension RoutineGroup{     // PlanGroup.swift
    func getRoutines(date: Date? = nil) -> [Routine] {
        
        // plans중에서 date날짜에 있는 것만 리턴한다
        if let date = date{
            var planForDate: [Routine] = []
            let start = date.firstOfDay()    // yyyy:mm:dd 00:00:00
            let end = date.lastOfDay()    // yyyy:mm”dd 23:59:59
            for plan in routines{
                if plan.date >= start && plan.date <= end {
                    planForDate.append(plan)
                }
            }
            return planForDate
        }
        return routines
    }
}

extension RoutineGroup{     // PlanGroup.swift
    
    private func count() -> Int{ return routines.count }
    
    func isIn(date: Date) -> Bool{
        if let from = fromDate, let to = toDate{
            return (date >= from && date <= to) ? true: false
        }
        return false
    }
    
    private func find(_ key: String) -> Int?{
        for i in 0..<routines.count{
            if key == routines[i].key{
                return i
            }
        }
        return nil
    }
}

extension RoutineGroup{         // PlanGroup.swift
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


