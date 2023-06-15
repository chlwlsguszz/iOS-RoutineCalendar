//
//  ViewController.swift
//  ch09-최진현-tableView
//
//  Created by 최진현 on 2023/05/01.
//

import UIKit
import FSCalendar

class CheckCalendarViewController: UIViewController {
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    var routineGroup: RoutineGroup!
    var routine: Routine!
    var selectedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fsCalendar.dataSource = self                // 칼렌다의 데이터소스로 등록
        fsCalendar.delegate = self                  // 칼렌다의 딜리게이트로 등록

        //planGroupTableView.isEditing = true

        // 단순히 planGroup객체만 생성한다
        //routineGroup.queryRoutine(/*date: Date()*/)       // 이달의 데이터를 가져온다. 데이터가 오면 planGroupListener가 호출된다.
        navigationItem.title = "성취 달력"
        
        setCalendarUI()
    }
//    override func viewDidAppear(_ animated: Bool) {
//        // 여기서 호출하는 이유는 present라는 함수 ViewController의 함수인데 이함수는 ViewController의 Layout이 완료된 이후에만 동작하기 때문
//        Owner.loadOwner(sender: self)
//    }

    /*
    func receivingNotification(plan: Routine?, action: DbAction?){
        // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        self.RoutineGroupTableView.reloadData()  // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
        fsCalendar.reloadData()     // 뱃지의 내용을 업데이트 한다
    }*/
 
}

//extension HomeViewController{
//    @IBAction func editingPlans1(_ sender: UIBarButtonItem) {
//        if RoutineGroupTableView.isEditing == true{
//            RoutineGroupTableView.isEditing = false
//            //sender.setTitle("Edit", for: .normal)
//            sender.title = "편집"
//        }else{
//            RoutineGroupTableView.isEditing = true
//            //sender.setTitle("Done", for: .normal)
//            sender.title = "완료"
//        }
//    }
//}
//
//extension HomeViewController{
//    @IBAction func addingPlan1(_ sender: UIBarButtonItem) {
//        self.performSegue(withIdentifier: "AddPlan", sender: self)
//    }
//}


//extension HomeViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if let planGroup = routineGroup{
//            return planGroup.getRoutines(/*date: selectedDate*/).count
//        }
//        return 0    // planGroup가 생성되기전에 호출될 수도 있다
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "") // TableViewCell을 생성한다
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell")!
//        cell.selectionStyle = .none
//
//        // planGroup는 대략 1개월의 플랜을 가지고 있다.
//        let routine = routineGroup.getRoutines(/*date: selectedDate*/)[indexPath.row] // Date를 주지않으면 전체 plan을 가지고 온다
//
//        // 적절히 cell에 데이터를 채움
//        //cell.textLabel!.text = plan.date.toStringDateTime()
//        //cell.detailTextLabel?.text = plan.content
//
////        (cell.contentView.subviews[2] as! UILabel).text = plan.date.toStringDateTime()
//        //(cell.contentView.subviews[1] as! UILabel).text = plan.owner
//
//        (cell.contentView.subviews[0] as! UIButton).setTitle(routine.emoji, for: .normal)
//
//        if let label = cell.contentView.subviews[1] as? UILabel {
//            label.text = " "+routine.when
//            label.layer.borderWidth = 1.0
//            label.layer.cornerRadius = 4.0
//        }
//
//        if let label = cell.contentView.subviews[2] as? UILabel {
//            label.text = " "+routine.content
//            label.layer.borderWidth = 1.0
//            label.layer.cornerRadius = 4.0
//        }
//
//
//        let checkButton = (cell.contentView.subviews[3] as! UIButton)
//
//        if(routine.isChecked(date: selectedDate!)) {
//            //print("debug:\(selectedDate?.toStringDate()) checked")
//            checkButton.setTitle("✅", for: .normal)
//        } else {
//            //print("debug:\(selectedDate?.toStringDate()) unchecked")
//            checkButton.setTitle("", for: .normal)
//        }
//
//        checkButton.tag = indexPath.row
//        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
//
////        cell.accessoryType = .none
////        cell.accessoryView = nil
////        if indexPath.row % 2 == 0 {
////            cell.accessoryType = .detailDisclosureButton    // type
////        }else{
////            cell.accessoryView = UISwitch(frame: CGRect())  // View
////        }
//
//        return cell
//    }
//
//    @objc func checkButtonTapped(_ sender: UIButton) {
//        let rowIndex = sender.tag
//        let routine = routineGroup.getRoutines(/*date: selectedDate*/)[rowIndex]
//        routine.toggleCheck(date: selectedDate!)
//        routineGroup.saveChange(routine: routine, action: .Modify)
//    }
//}


//extension HomeViewController: UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete{
//
//            let plan = self.routineGroup.getRoutines(/*date: selectedDate*/)[indexPath.row]
//            let title = "Delete \(plan.content)"
//            let message = "진짜로 이 루틴을 삭제할까요?"
//
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (action:UIAlertAction) -> Void in
//
//                // 선택된 row의 플랜을 가져온다
//                let plan = self.routineGroup.getRoutines(/*date: selectedDate*/)[indexPath.row]
//                // 단순히 데이터베이스에 지우기만 하면된다. 그러면 꺼꾸로 데이터베이스에서 지워졌음을 알려준다
//                self.routineGroup.saveChange(routine: plan, action: .Delete)
//            })
//
//            alertController.addAction(cancelAction)
//            alertController.addAction(deleteAction)
//            present(alertController, animated: true, completion: nil) //여기서 waiting 하지 않는다
//        }
//    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//        // 이것은 데이터베이스에 까지 영향을 미치지 않는다. 그래서 planGroup에서만 위치 변경
//        let from = routineGroup.getRoutines(/*date: selectedDate*/)[sourceIndexPath.row]
//        let to = routineGroup.getRoutines(/*date: selectedDate*/)[destinationIndexPath.row]
//        routineGroup.changeRoutine(from: from, to: to)
//        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
//    }
//}
//
//extension HomeViewController{    // PlanGroupViewController.swift
//
//    // prepare함수에서 PlanDetailViewController에게 전달한다
//    func saveChange(plan: Routine){
//
//        // 만약 현재 planGroupTableView에서 선택된 row가 있다면,
//        // 즉, planGroupTableView의 row를 클릭하여 PlanDetailViewController로 전이 한다면
//        if RoutineGroupTableView.indexPathForSelectedRow != nil{
//            routineGroup.saveChange(routine: plan, action: .Modify)
//        }else{
//            // 이경우는 나중에 사용할 것이다.
//            routineGroup.saveChange(routine: plan, action: .Add)
//        }
//    }
//}

//extension HomeViewController{     // PlanGroupViewController.swift
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "ShowPlan"{
//            let routineDetailViewController = segue.destination as! RoutineDetailViewController
//            // plan이 수정되면 이 saveChangeDelegate를 호출한다
//            routineDetailViewController.saveChangeDelegate = saveChange
//
//            // 선택된 row가 있어야 한다
//            if let row = RoutineGroupTableView.indexPathForSelectedRow?.row{
//                // plan을 복제하여 전달한다. 왜냐하면 수정후 취소를 할 수 있으므로
//                routineDetailViewController.routine = routineGroup.getRoutines(/*date: selectedDate*/)[row].clone()
//            }
//        }
//        if segue.identifier == "AddPlan"{
//            let routineDetailViewController = segue.destination as! RoutineDetailViewController
//            routineDetailViewController.saveChangeDelegate = saveChange
//
//            // 빈 plan을 생성하여 전달한다
//            routineDetailViewController.routine = Routine(/*date:nil, withData: false*/)
//            RoutineGroupTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
//        }
//
//
//    }
//}

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
        // 날짜가 선택되면 호출된다
        selectedDate = date.setCurrentTime()
        //print(selectedDate?.toStringDate())
        //routineGroup.queryRoutine(date: date)
    }
    
//
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // 스와이프로 월이 변경되면 호출된다
        selectedDate = calendar.currentPage
        //print(selectedDate?.toStringDate())
        //self.RoutineGroupTableView.reloadData()
        //routineGroup.queryRoutine(date: calendar.currentPage)
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        if routine.isChecked(date: date) {
//            return routine.emoji
//        }
//        else {
//            return .none
//        }
//    }
    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if routine.isChecked(date: date) {
            return routine.emoji
        }
        else {
            return ""
        }
    }
    
//     이함수를 fsCalendar.reloadData()에 의하여 모든 날짜에 대하여 호출된다.
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        //print(selectedDate?.toStringDate())
//        let checkCount = routineGroup.checkCount(date: date)
//        let routineCount = routineGroup.routines.count
//        return "\(checkCount)/\(routineCount)"    // date에 해당한 plans의 갯수를 뱃지로 출력한다
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        return .white
//    }
////
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//        .darkGray
//    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleOffsetFor date: Date) -> CGPoint {
//        <#code#>
//    }
    // 선택된 날짜 테두리 색상
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
//        return UIColor.black.withAlphaComponent(1.0)
//    }
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
////        let fromDate = selectedDate!.firstOfMonth()// 1일이 속한 일요일을 시작시간
////        let toDate = selectedDate!.lastOfMonth()    // 이달 마지막일이 속한 토요일을 마감시간
////
////        print(fromDate)
////        print(toDate)
////        if date < fromDate || date > toDate {
////            return .white
////        }
//        return .black
//    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
//        return .black
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
//        return .black
//    }
    
}
