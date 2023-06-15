import Foundation

class Routine {

    var key: String
    
    var content: String
    var emoji: String
    var when: String
    var checkedDates: [String: Bool]
    
    init(content: String, emoji: String, when: String, checkedDates: [String: Bool]){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.

        self.content = content
        self.emoji = emoji
        self.when = when
        self.checkedDates = checkedDates
        
    }
    
 
}

extension Routine{
    convenience init(){

        self.init(content: "", emoji: "🏅", when: "", checkedDates: [:])
    }
}

extension Routine{
    func clone() -> Routine {
        let clonee = Routine()

        clonee.key = self.key
        clonee.content = self.content
        clonee.emoji = self.emoji
        clonee.when = self.when
        clonee.checkedDates = self.checkedDates
        return clonee
    }
}

extension Routine {
    func toDict() -> [String: Any?]{
        var dict: [String: Any?] = [:]
        
        dict["key"] = key
        dict["content"] = content
        dict["emoji"] = emoji
        dict["when"] = when
        return dict
    }
    
    func toRoutine(dict: [String: Any?]) {
        key = dict["key"] as! String
        content = dict["content"] as! String
        emoji = dict["emoji"] as! String
        when = dict["when"] as! String
    }
}

extension Routine {
    
    func toggleCheck(date: Date) {
        checkedDates[date.toStringDate()] = !(checkedDates[date.toStringDate()] ?? false)
    }
    
    func isChecked(date: Date) -> Bool {
        return checkedDates[date.toStringDate()] ?? false
    }
}

