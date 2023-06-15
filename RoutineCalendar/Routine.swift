//
//  Plan.swift
//  ch09-최진현-tableView
//
//  Created by 최진현 on 2023/05/01.
//

import Foundation
import FirebaseFirestore

class Routine /*NSObject, NSCoding*/{
//    enum Kind: Int {
//        case Todo = 0, Meeting, Study, Etc
//        func toString() -> String{
//            switch self {
//                case .Todo: return "할일";     case .Meeting: return "미팅"
//                case .Study: return "공부";    case .Etc: return "기타"
//            }
//        }
//        static var count: Int { return Kind.Etc.rawValue + 1}
//    }
    var key: String;        //var date: Date
    //var owner: String?;     var kind: Kind
    var content: String;    var emoji: String
    var when: String;
    
    init(/*date: Date, owner: String?, kind: Kind, */content: String, emoji: String, when: String){
        self.key = UUID().uuidString   // 거의 unique한 id를 만들어 낸다.
//        self.date = Date(timeInterval: 0, since: date)
//        self.owner = Owner.getOwner()
//        self.kind = kind;
        self.content = content
        self.emoji = emoji
        self.when = when
        //super.init()
    }
    
    /*
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")       // 내부적으로 String의 encode가 호출된다
        aCoder.encode(date, forKey: "date")
        aCoder.encode(owner, forKey: "owner")
        aCoder.encode(kind.rawValue, forKey: "kind")
        aCoder.encode(content, forKey: "content")
    }
    // unarchiving할때 호출된다
    required init(coder aDecoder: NSCoder) {
        key = aDecoder.decodeObject(forKey: "key") as! String? ?? "" // 내부적으로 String.init가 호출된다
        date = aDecoder.decodeObject(forKey: "date") as! Date
        owner = aDecoder.decodeObject(forKey: "owner") as? String
        let rawValue = aDecoder.decodeInteger(forKey: "kind")
        kind = Kind(rawValue: rawValue)!
        content = aDecoder.decodeObject(forKey: "content") as! String? ?? ""
        super.init()
    }
     */
}

extension Routine{
    convenience init(date: Date? = nil, withData: Bool = false){
//        if withData == true{
//            var index = Int(arc4random_uniform(UInt32(Kind.count)))
//            let kind = Kind(rawValue: index)! // 이것의 타입은 옵셔널이다. Option+click해보라
//
//            let contents = ["iOS 숙제", "졸업 프로젝트", "아르바이트","데이트","엄마 도와드리기"]
//            index = Int(arc4random_uniform(UInt32(contents.count)))
//            let content = contents[index]
//
//            self.init(date: date ?? Date(), owner: "me", kind: kind, content: content, emoji: "🏅", when: "")
//
//        }else{
//            self.init(date: date ?? Date(), owner: "me", kind: .Etc, content: "", emoji: "🏅", when: "")
//
//        }
        self.init(/*date: date ?? Date(), owner: "me", kind: .Etc,*/ content: "", emoji: "🏅", when: "")
    }
}

extension Routine{        // Plan.swift
    func clone() -> Routine {
        let clonee = Routine()

        clonee.key = self.key    // key는 String이고 String은 struct이다. 따라서 복제가 된다
//        clonee.date = Date(timeInterval: 0, since: self.date) // Date는 struct가 아니라 class이기 때문
//        clonee.owner = self.owner
//        clonee.kind = self.kind    // enum도 struct처럼 복제가 된다
        clonee.content = self.content
        clonee.emoji = self.emoji
        clonee.when = self.when
        return clonee
    }
}

extension Routine {
    func toDict() -> [String: Any?]{
        var dict: [String: Any?] = [:]
        
        dict["key"] = key
//        dict["date"] = Timestamp(date: date)
//        dict["owner"] = owner
//        dict["kind"] = kind.rawValue
        dict["content"] = content
        dict["emoji"] = emoji
        dict["when"] = when
        return dict
    }
    
    func toRoutine(dict: [String: Any?]) {
        key = dict["key"] as! String
//        date = Date()
//        if let timestamp = dict["date"] as? Timestamp {
//            date = timestamp.dateValue()
//        }
//        owner = dict["owner"] as? String
//        let rawValue = dict["kind"] as! Int
//        kind = Routine.Kind(rawValue: rawValue)!
        content = dict["content"] as! String
        emoji = dict["emoji"] as! String
        when = dict["when"] as! String
    }
}

