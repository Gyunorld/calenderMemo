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
        letterTitle.text = selectedLetter?.Title
        letterCategory.text = selectedLetter?.category
        letterBody.text = selectedLetter?.Body
        letterBody.isEditable = false
    }

}
