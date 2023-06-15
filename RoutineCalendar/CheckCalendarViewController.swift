import UIKit
import FSCalendar

class CheckCalendarViewController: UIViewController {
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    var routineGroup: RoutineGroup!
    var routine: Routine!
    var selectedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
        
        navigationItem.title = "성취 달력"
        
        setCalendarUI()
    }
}

extension CheckCalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func setCalendarUI() {
        self.fsCalendar.appearance.subtitleFont = .systemFont(ofSize: 24)
        self.fsCalendar.appearance.todayColor = .white
        self.fsCalendar.appearance.titleTodayColor = .black
        self.fsCalendar.appearance.subtitleTodayColor = .black
        self.fsCalendar.appearance.borderDefaultColor = .black
        self.fsCalendar.appearance.borderSelectionColor = .black
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date.setCurrentTime()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        selectedDate = calendar.currentPage
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if routine.isChecked(date: date) {
            return routine.emoji
        }
        else {
            return ""
        }
    }
    
}
