import UIKit
import FSCalendar

class HomeViewController: UIViewController {
    
    @IBOutlet weak var RoutineGroupTableView: UITableView!
    var routineGroup: RoutineGroup!
    @IBOutlet weak var fsCalendar: FSCalendar!
    var selectedDate: Date? = Date()
    
    var selectedRoutine: Routine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RoutineGroupTableView.dataSource = self
        RoutineGroupTableView.delegate = self

        fsCalendar.dataSource = self
        fsCalendar.delegate = self

        routineGroup = RoutineGroup(parentNotification: receivingNotification)
        routineGroup.queryRoutine()
        navigationItem.title = "루틴 캘린더"
        
        setCalendarUI()
    }
    
    func receivingNotification(plan: Routine?, action: DbAction?){
        self.RoutineGroupTableView.reloadData()
        fsCalendar.reloadData()
    }
 
}

extension HomeViewController{
    @IBAction func editingPlans1(_ sender: UIBarButtonItem) {
        if RoutineGroupTableView.isEditing == true{
            RoutineGroupTableView.isEditing = false
            sender.title = "편집"
        }else{
            RoutineGroupTableView.isEditing = true
            sender.title = "완료"
        }
    }
}

extension HomeViewController{
    @IBAction func addingPlan1(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddRoutine", sender: self)
    }
}


extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let planGroup = routineGroup{
            return planGroup.getRoutines().count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineTableViewCell")!
        cell.selectionStyle = .none
  
        let routine = routineGroup.getRoutines()[indexPath.row]

        let emojiButton = (cell.contentView.subviews[0] as! UIButton)
        emojiButton.setTitle(routine.emoji, for: .normal)
        
        emojiButton.tag = indexPath.row
        emojiButton.addTarget(self, action: #selector(emojiButtonTapped), for: .touchUpInside)
        
        if let label = cell.contentView.subviews[1] as? UILabel {
            label.text = " "+routine.when
            label.layer.borderWidth = 1.0
            label.layer.cornerRadius = 4.0
        }
        
        if let label = cell.contentView.subviews[2] as? UILabel {
            label.text = " "+routine.content
            label.layer.borderWidth = 1.0
            label.layer.cornerRadius = 4.0
        }
        
        
        let checkButton = (cell.contentView.subviews[3] as! UIButton)
        
        if(routine.isChecked(date: selectedDate!)) {
            checkButton.setTitle("✅", for: .normal)
        } else {
            checkButton.setTitle("", for: .normal)
        }
        
        checkButton.tag = indexPath.row
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func checkButtonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        let routine = routineGroup.getRoutines(/*date: selectedDate*/)[rowIndex]
        routine.toggleCheck(date: selectedDate!)
        routineGroup.saveChange(routine: routine, action: .Modify)
    }
    
    @objc func emojiButtonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        selectedRoutine = routineGroup.getRoutines()[rowIndex]
        self.performSegue(withIdentifier: "ShowCheckCalendar", sender: self)
    }
}


extension HomeViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let plan = self.routineGroup.getRoutines()[indexPath.row]
            let title = "Delete \(plan.content)"
            let message = "진짜로 이 루틴을 삭제할까요?"

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (action:UIAlertAction) -> Void in
                
               
                let plan = self.routineGroup.getRoutines()[indexPath.row]
              
                self.routineGroup.saveChange(routine: plan, action: .Delete)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let from = routineGroup.getRoutines()[sourceIndexPath.row]
        let to = routineGroup.getRoutines()[destinationIndexPath.row]
        routineGroup.changeRoutine(from: from, to: to)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

extension HomeViewController{

    func saveChange(plan: Routine){


        if RoutineGroupTableView.indexPathForSelectedRow != nil{
            routineGroup.saveChange(routine: plan, action: .Modify)
        }else{
            routineGroup.saveChange(routine: plan, action: .Add)
        }
    }
}

extension HomeViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowRoutine"{
            let routineDetailViewController = segue.destination as! RoutineDetailViewController
            
            routineDetailViewController.saveChangeDelegate = saveChange
            
            if let row = RoutineGroupTableView.indexPathForSelectedRow?.row{
                routineDetailViewController.routine = routineGroup.getRoutines()[row].clone()
            }
        }
        if segue.identifier == "AddRoutine"{
            let routineDetailViewController = segue.destination as! RoutineDetailViewController
            routineDetailViewController.saveChangeDelegate = saveChange
            
            routineDetailViewController.routine = Routine()
            RoutineGroupTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
        }
        
        if segue.identifier == "ShowCheckCalendar"{
            let checkCalendarViewController = segue.destination as! CheckCalendarViewController
            checkCalendarViewController.routine = selectedRoutine
            checkCalendarViewController.routineGroup = routineGroup
            checkCalendarViewController.selectedDate = selectedDate
        }

    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func setCalendarUI() {
        self.fsCalendar.appearance.subtitleFont = .systemFont(ofSize: 12)
        self.fsCalendar.appearance.titleTodayColor = .black
        self.fsCalendar.appearance.subtitleTodayColor = .black
        self.fsCalendar.appearance.borderDefaultColor = .black
        self.fsCalendar.appearance.borderSelectionColor = .black
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date.setCurrentTime()
        self.RoutineGroupTableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        selectedDate = calendar.currentPage
        self.RoutineGroupTableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let checkCount = routineGroup.checkCount(date: date)
        let routineCount = routineGroup.routines.count
        return "\(checkCount)/\(routineCount)"
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        let checkCount = routineGroup.checkCount(date: date)
        let routineCount = routineGroup.routines.count
        
        let completionPercentage = Double(checkCount) / Double(routineCount) * 100
        
        if completionPercentage < 50 {
            return .red // Red color for below 50%
        } else if completionPercentage < 80 {
            return .yellow // Yellow color for 50% to 79%
        } else {
            return .green // Green color for 80% and above
        }
    }
}
