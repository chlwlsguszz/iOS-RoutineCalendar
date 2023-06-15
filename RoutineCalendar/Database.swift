import Foundation

enum DbAction{
    case Add, Delete, Modify // 데이터베이스 변경의 유형
}
protocol Database{
    init(parentNotification: ((Routine?, DbAction?) -> Void)? )
    
    func queryRoutine()
    
    func saveChange(routine: Routine, action: DbAction)
}
