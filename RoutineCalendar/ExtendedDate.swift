import Foundation

extension Date{
    
    static  let calendar = Calendar(identifier: .gregorian)
    static  let dateFormatter = DateFormatter()
    
    func setCurrentTime() -> Date{
        let current = Date.calendar.dateComponents([.hour, .minute, .second], from: Date())
        var components = Date.calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(current.hour, for: .hour)
        components.setValue(current.minute, for: .minute)
        components.setValue(current.second, for: .second)
        return Date.calendar.date(from: components)!
    }
    
    func toStringDate() -> String{
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        return Date.dateFormatter.string(from: self)
    }
}
