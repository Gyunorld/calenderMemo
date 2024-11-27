//
//  LetterViewController.swift
//  calenderMemo
//
//  Created by 김민규 on 11/19/24.
//

import UIKit
import RealmSwift

class LetterViewController: UIViewController {
    
    let realm = try! Realm()

    @IBOutlet weak var letterTitle: UILabel!
    @IBOutlet weak var letterCategory: UILabel!
    @IBOutlet weak var letterBody: UITextView!
    
    var selectedLetter: Letter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLetter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLetter()
    }
    
    func setLetter() {
        letterTitle.text = selectedLetter?.Title
        letterCategory.text = selectedLetter?.category
        letterBody.text = selectedLetter?.Body
        letterBody.isEditable = false
        letterBody.layer.borderWidth = 1
        letterBody.layer.borderColor = UIColor.black.cgColor
        letterBody.layer.cornerRadius = 10
        letterCategory.layer.borderWidth = 1
        letterCategory.layer.borderColor = UIColor.black.cgColor
        letterCategory.layer.cornerRadius = 10
    }
    
    
    
    @IBAction func deleteLetter(_ sender: Any) {
        
        let cautionAlert = UIAlertController(title: "주의⚠️", message: "삭제된 글은 복구되지 않습니다. 정말로 삭제하시겠습니까?", preferredStyle: .alert)
        cautionAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        cautionAlert.addAction(UIAlertAction(title: "삭제", style: .default, handler: { [self] _ in
            do{
                try realm.write {
                    self.realm.delete(self.selectedLetter!)
                }
                let deleteAlert = UIAlertController(title: "삭제🚮", message: "성공적으로 삭제되었습니다.", preferredStyle: .alert)
                deleteAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(deleteAlert, animated: true, completion: nil)
            } catch {
                fatalError("Error deleting letter: \(error)")
            }
        }))
        self.present(cautionAlert, animated: true, completion: nil)
    }
    
    @IBAction func updateLetter(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToUpdate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUpdate", let writeVC = segue.destination as? WriteViewController {
            writeVC.isUpdateLetter = true
            writeVC.updateLetter = selectedLetter
        }
    }
    
}
