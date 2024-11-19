//
//  WriteViewController.swift
//  calenderMemo
//
//  Created by 김민규 on 11/18/24.
//

import UIKit
import RealmSwift

class WriteViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var TitleEdit: UITextField!
    @IBOutlet weak var BodyEdit: UITextView!
    @IBOutlet weak var categorySelect: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCategory()
        setCategoryStyle()
        setBodyStyle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.BodyEdit.resignFirstResponder()
    }
    
    func setCategory() {
        let menu = UIMenu(title: "종류", children: categoryAction())
        categorySelect.menu = menu
        categorySelect.showsMenuAsPrimaryAction = true
    }
    
    func categoryAction() -> [UIAction] {
        return Letter.Category.allCases.map { category in
            UIAction(title: category.rawValue, handler: { [weak self] _ in
                self?.handleCategorySelection(category)
            })
        }
    }
    
    func handleCategorySelection(_ category: Letter.Category) {
        categorySelect.setTitle(category.rawValue, for: .normal)
    }
    
    func setCategoryStyle() {
        categorySelect.setTitle("카테고리", for: .normal)
        categorySelect.layer.borderWidth = 0.5
        categorySelect.layer.borderColor = UIColor.black.cgColor
        categorySelect.layer.cornerRadius = 10
    }
    
    func setBodyStyle() {
        BodyEdit.delegate = self
        BodyEdit.text = "내용을 입력하세요."
        BodyEdit.textColor = .lightGray
        BodyEdit.layer.borderWidth = 0.5
        BodyEdit.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: - Save Letter
    
    @IBAction func SaveButton(_ sender: UIButton) {
        
        guard let titleText = TitleEdit.text, !titleText.isEmpty else {
            showAlert(message: "제목을 입력해주세요.")
            return
        }
        
        guard let bodyText = BodyEdit.text, bodyText != "내용을 입력하세요." , !bodyText.isEmpty else {
            showAlert(message: "내용을 입력해주세요.")
            return
        }
        
        guard let category = categorySelect.titleLabel?.text, category != "카테고리" else {
            showAlert(message: "카테고리를 선택해주세요.")
            return
        }
        
        do {
            try realm.write {
                let letter = Letter()
                letter.Title = titleText
                letter.category = category
                letter.Body = bodyText
                realm.add(letter)
            }
            showAlert(message: "저장이 완료되었습니다.✅",goBack: true)
        } catch {
            print("Error Saving: \(error)")
        }
    }
    
    func showAlert(message: String, goBack: Bool = false) {
        let alert = UIAlertController(title: "주의⚠️", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            if goBack {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Text View Delegate

extension WriteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if BodyEdit.text.isEmpty {
            BodyEdit.text =  "내용을 입력하세요."
            BodyEdit.textColor = UIColor.lightGray
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if BodyEdit.textColor == UIColor.lightGray {
            BodyEdit.text = nil
            BodyEdit.textColor = UIColor.black
        }
    }
}
