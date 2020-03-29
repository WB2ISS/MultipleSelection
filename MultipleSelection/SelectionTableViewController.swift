//
//  SelectionTableViewController.swift
//  MultipleSelection
//
//  Created by Barry P. Medoff on 3/28/20.
//  Copyright © 2020 Barry P. Medoff. All rights reserved.
//

import UIKit

let rowContents = ["Zero", "One", "Two", "Three"]

class SelectionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multiple Selection"
        let exportButtonItem  = UIBarButtonItem(title:"Export", style: .plain, target: self, action: #selector(startExporting))
        self.navigationItem.setLeftBarButtonItems([exportButtonItem], animated: true)
    }

    @objc func startExporting() {
        let cancelButtonItem  = UIBarButtonItem(title:"Cancel", style: .plain, target: self, action: #selector(cancel))
        cancelButtonItem.style = .done
        navigationItem.setLeftBarButtonItems([cancelButtonItem], animated: true)
        tableView.allowsMultipleSelectionDuringEditing = true
        super.setEditing(true, animated: true)
        tableView.setEditing(true, animated: true)
    }
    
    @objc func cancel() {
        let exportButtonItem  = UIBarButtonItem(title:"Export", style: .plain, target: self, action: #selector(startExporting))
        self.navigationItem.setLeftBarButtonItems([exportButtonItem], animated: true)
        tableView.allowsMultipleSelectionDuringEditing = false
        super.setEditing(true, animated: false)
        tableView.setEditing(true, animated: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowContents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath)
        cell.textLabel?.text = rowContents[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt indexPath.row = \(indexPath.row)")
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           print("didDeselectRowAt indexPath.row = \(indexPath.row)")
    }
}
