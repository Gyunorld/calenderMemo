//
//  DetailTableViewController.swift
//  calenderMemo
//
//  Created by 김민규 on 11/10/24.
//

import UIKit

class DetailTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBAction func writeNew(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToWrite", sender: self)
    }
    
    
}
