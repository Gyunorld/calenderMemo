//
//  WriteViewController.swift
//  calenderMemo
//
//  Created by 김민규 on 11/18/24.
//

import UIKit

class WriteViewController: UIViewController {
    
    
    @IBOutlet weak var categorySelect: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCategory()
        setCategoryStyle()
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
        print("선택된 카테고리: \(category.rawValue)")
        // 선택한 카테고리에 따라 동작 추가
        categorySelect.setTitle(category.rawValue, for: .normal) // 버튼 텍스트 변경
    }
    
    func setCategoryStyle() {
        categorySelect.setTitle("카테고리", for: .normal)
        categorySelect.layer.borderWidth = 0.5
        categorySelect.layer.borderColor = UIColor.black.cgColor
        categorySelect.layer.cornerRadius = 10
    }
    
}


