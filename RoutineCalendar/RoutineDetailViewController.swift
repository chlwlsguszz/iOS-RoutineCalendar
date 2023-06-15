//
//  PlanDetailViewController.swift
//  ch10-최진현-stackView
//
//  Created by 최진현 on 2023/05/08.
//

import UIKit
import MCEmojiPicker

class RoutineDetailViewController: UIViewController {
    
    @IBAction func pressedOkButton(_ sender: UIButton) {
        routine!.content = contentTextField.text!
        saveChangeDelegate?(routine!)
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var emojiButton: UIButton!
    @IBAction func selectEmojiAction(_ sender: UIButton) {
        let viewController = MCEmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = sender
        present(viewController, animated: true)
    }
    
    @IBOutlet weak var contentTextField: UITextField!
    
    
    var routine: Routine? // 나중에 PlanGroupViewController로부터 데이터를 전달받는다
    var saveChangeDelegate: ((Routine)-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //typePicker.dataSource = self
        //typePicker.delegate = self
        
        routine = routine ?? Routine(date: Date(), withData: true)
        //dateDatePicker.date = routine?.date ?? Date()
        //ownerLabel.text = routine?.owner       // plan!.owner과 차이는? optional chainingtype
        
        // typePickerView 초기화
        //if let routine = routine{
        //    typePicker.selectRow(routine.kind.rawValue, inComponent: 0, animated: false)
        //}
        //contentTextView.text = routine?.content
        
        if let routine = routine {
            contentTextField.text = routine.content
            emojiButton.setTitle(routine.emoji, for: .normal)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        //let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        //contentTextView.addGestureRecognizer(longPressGesture)

        navigationItem.title = "루틴 정하기"
    }
    
}

extension RoutineDetailViewController {
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        contentTextField.resignFirstResponder()
    }
    
    //@objc func longPress(sender: UILongPressGestureRecognizer){
    //    if sender.state == .began {
    //        performSegue(withIdentifier: "ShowContent", sender: nil)
    //    }
    //}
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    if segue.identifier == "ShowContent" {
    //        let selectContentViewController = segue.destination as! SelectContentViewController
    //        selectContentViewController.planDetailViewController = self
    //    }
    //}

}

//extension RoutineDetailViewController:UIPickerViewDelegate, UIPickerViewDataSource{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return Routine.Kind.count   // Plan.swift파일에서 count를 확인하라
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let type = Routine.Kind(rawValue: row)    // 정수를 해당 Kind 타입으로 변환하는 것이다.
//        return type!.toString()
//    }
//}

extension RoutineDetailViewController{

//    @IBAction func gotoBack(_ sender: UIButton) {
//
//        plan!.date = dateDatePicker.date
//        plan!.owner = ownerLabel.text    // 수정할 수 없는 UILabel이므로 필요없는 연산임
//        plan!.kind = Plan.Kind(rawValue: typePicker.selectedRow(inComponent: 0))!
//        plan!.content = contentTextView.text
//
//        saveChangeDelegate?(plan!)
//        //dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
//
//    }
    override func viewDidDisappear(_ animated: Bool) {
//        routine!.date = dateDatePicker.date
//        routine!.owner = ownerLabel.text
//        routine!.kind = Routine.Kind(rawValue: typePicker.selectedRow(inComponent: 0))!
//        routine!.content = contentTextField.text!
//        saveChangeDelegate?(routine!)
    }

}

extension RoutineDetailViewController: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
        routine!.emoji = emoji
    }
}
