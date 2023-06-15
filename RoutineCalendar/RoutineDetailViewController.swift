import UIKit
import MCEmojiPicker

class RoutineDetailViewController: UIViewController {
    
    @IBAction func pressedOkButton(_ sender: UIButton) {
        routine!.when = whenTextField.text!
        routine!.content = contentTextField.text!
        routine!.emoji = tempEmojiString!
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
    
    @IBOutlet weak var whenTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    
    var routine: Routine?
    var saveChangeDelegate: ((Routine)-> Void)?
    var tempEmojiString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routine = routine ?? Routine()
        
        if let routine = routine {
            whenTextField.text = routine.when
            contentTextField.text = routine.content
            emojiButton.setTitle(routine.emoji, for: .normal)
            tempEmojiString = routine.emoji
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.title = "루틴 정하기"
    }
    
}

extension RoutineDetailViewController {
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        contentTextField.resignFirstResponder()
    }
}

extension RoutineDetailViewController: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
        tempEmojiString = emoji
    }
}
