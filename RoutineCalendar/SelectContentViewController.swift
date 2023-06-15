//
//  SelectContentViewController.swift
//  ch10-최진현-stackView
//
//  Created by 최진현 on 2023/05/08.
//
/*
import UIKit

class SelectContentViewController: UIViewController {
    
    
    @IBAction func unselectContent(_ sender: UIButton) {
        planDetailViewController?.contentTextView.text = tempString
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectContent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var selectContentTableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    let contents = [
        "엄마 도와 드리기",
        "아르바이트",
        "청소하기",
        "학교 가서 밥먹기",
        "iOS 즐겁게 숙제하기",
        "친구와 까페가기",
        "데이트 하기"
    ]
    
    var tempString = ""
    
    var planDetailViewController: RoutineDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectContentTableView.dataSource = self // SelectContentViewController
        selectContentTableView.delegate = self
        
        stackView.layer.borderWidth = 1
        tempString = (planDetailViewController?.contentTextView.text)!
    }
}

extension SelectContentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectContentCell")!
        (cell.contentView.subviews[0] as! UILabel).text = contents[indexPath.row]
        return cell
    }
}

extension SelectContentViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        planDetailViewController?.contentTextView.text = contents[indexPath.row]
    }
}
*/
