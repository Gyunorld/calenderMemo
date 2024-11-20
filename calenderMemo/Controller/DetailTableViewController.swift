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
    
    var selectedDate: Date?
    
    var letters: Results<Letter>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllLetters()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return letters?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            writeVC.selectedDate = self.selectedDate
        }
    }
    
    //MARK: - Load Data
    
    func loadAllLetters() {
        letters = realm.objects(Letter.self)
        tableView.reloadData()
    }
}
