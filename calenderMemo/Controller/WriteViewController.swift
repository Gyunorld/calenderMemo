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
    
    var createdDate: String?
    var isUpdateLetter: Bool = false
    var updateLetter: Letter?
    
    @IBOutlet weak var TitleEdit: UITextField!
    @IBOutlet weak var BodyEdit: UITextView!
    @IBOutlet weak var categorySelect: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCategory()
        setCategoryStyle()
        setBodyStyle()
        
        if isUpdateLetter, let letter = updateLetter {
            TitleEdit.text = letter.Title
            categorySelect.setTitle(letter.category, for: .normal)
            BodyEdit.text = letter.Body
            BodyEdit.textColor = .black
        }
        
    }
    
    //MARK: - Category Button Methods
    
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
        categorySelect.layer.borderWidth = 1
        categorySelect.layer.borderColor = UIColor.black.cgColor
        categorySelect.layer.cornerRadius = 10
    }
    
    //MARK: - BodyEdit Methods
    
    func setBodyStyle() {
        BodyEdit.delegate = self
        BodyEdit.text = "내용을 입력하세요."
        BodyEdit.textColor = .lightGray
        BodyEdit.layer.borderWidth = 1
        BodyEdit.layer.cornerRadius = 10
        BodyEdit.layer.borderColor = UIColor.black.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.BodyEdit.resignFirstResponder()
    }
    
    //MARK: - Save Letter
    
    @IBAction func SaveButton(_ sender: UIButton) {
        
        guard let titleText = TitleEdit.text, !titleText.isEmpty else {
            saveAlert(message: "제목을 입력해주세요.")
            return
        }
        
        guard let bodyText = BodyEdit.text, bodyText != "내용을 입력하세요." , !bodyText.isEmpty else {
            saveAlert(message: "내용을 입력해주세요.")
            return
        }
        
        guard let category = categorySelect.titleLabel?.text, category != "카테고리" else {
            saveAlert(message: "카테고리를 선택해주세요.")
            return
        }
        
        do {
            try realm.write {
                if isUpdateLetter, let letter = updateLetter {
                    letter.Title = titleText
                    letter.category = category
                    letter.Body = bodyText
                } else {
                    guard let createdDate = createdDate else {
                        return
                    }
                    let letter = Letter()
                    letter.Title = titleText
                    letter.category = category
                    letter.Body = bodyText
                    letter.createdAt = createdDate
                    realm.add(letter)
                }
            }
            saveAlert(message: "저장이 완료되었습니다.✅",goBack: true)
        } catch {
            print("Error Saving: \(error)")
        }
    }
    
    func saveAlert(message: String, goBack: Bool = false) {
        let alert = UIAlertController(title: "알림📢", message: message, preferredStyle: .alert)
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
        if BodyEdit.text.isEmpty && !isUpdateLetter {
            BodyEdit.text =  "내용을 입력하세요."
            BodyEdit.textColor = UIColor.lightGray
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if BodyEdit.textColor == UIColor.lightGray && !isUpdateLetter{
            BodyEdit.text = nil
            BodyEdit.textColor = UIColor.black
        }
    }
}
