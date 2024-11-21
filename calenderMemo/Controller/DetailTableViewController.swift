//
//  DetailTableViewController.swift
//  calenderMemo
//
//  Created by 김민규 on 11/10/24.
//

import UIKit
import RealmSwift

class DetailTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var formattedDate: String?
    
    var letters: Results<Letter>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDateLetters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDateLetters()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let letters = letters, letters.isEmpty {
            return 1
        }
        return letters?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let letters = letters, letters.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
            cell.textLabel?.text = "작성된 글이 없습니다. 글을 작성해 주세요."
            cell.textLabel?.textColor = .lightGray
            cell.textLabel?.textAlignment = .center
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        if let letter = letters?[indexPath.row] {
            cell.textLabel?.text = letter.Title
        }
        return cell
    }
    
    //MARK: - Table View Delegate
    
    @IBAction func writeNew(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToWrite", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWrite", let writeVC = segue.destination as? WriteViewController {
            writeVC.createdDate = formattedDate
        } else if segue.identifier == "goToLetter", let letterVC = segue.destination as? LetterViewController, let indexPath = tableView.indexPathForSelectedRow {
            letterVC.selectedLetter = letters?[indexPath.row]
        }
    }
    
    
    //MARK: - Load Data
    
    func loadDateLetters() {
        guard let formattedDate = formattedDate else { return }
        letters = realm.objects(Letter.self).filter("createdAt == %@",formattedDate)
        tableView.reloadData()
    }
}
