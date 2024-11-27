//
//  DetailTableViewController.swift
//  calenderMemo
//
//  Created by 김민규 on 11/10/24.
//

import UIKit
import RealmSwift

class DetailTableViewController: SwipeTableViewController {
    
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
        return letters?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let letter = letters?[indexPath.row] {
            cell.textLabel?.text = letter.Title
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .justified
            tableView.separatorStyle = .singleLine
            tableView.allowsSelection = true
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
    
    //MARK: - Swipe Delete
    
    override func updateModel(at indexPath: IndexPath) {
        if let letterDelete = letters?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(letterDelete)
                }
            } catch {
                print("Error Delete Swipe: \(error)")
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData() 
        }
    }
}
