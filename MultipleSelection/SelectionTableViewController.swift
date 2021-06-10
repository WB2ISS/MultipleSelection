//
//  SelectionTableViewController.swift
//  MultipleSelection
//
//  Created by Barry P. Medoff on 3/28/20.
//  Copyright © 2020 Barry P. Medoff. All rights reserved.
//

import UIKit

let rowContents = ["Zero", "One", "Two", "Three", "Four", "Five"]

class SelectionTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multiple Selection"
        let exportButtonItem  = UIBarButtonItem(title:"Export", style: .plain, target: self, action: #selector(startExporting))
        self.navigationItem.setLeftBarButtonItems([exportButtonItem], animated: true)
    }

    @objc func startExporting() {
        let selectButtonItem  = UIBarButtonItem(title:"Select All", style: .plain, target: self, action: #selector(selectAllItems))
        navigationItem.setRightBarButtonItems([selectButtonItem], animated: true)
        let cancelButtonItem  = UIBarButtonItem(title:"Cancel", style: .plain, target: self, action: #selector(cancel))
        cancelButtonItem.style = .done
        navigationItem.setLeftBarButtonItems([cancelButtonItem], animated: true)
        tableView.allowsMultipleSelectionDuringEditing = true
        super.setEditing(true, animated: true)
        tableView.setEditing(true, animated: true)
    }
    
    @objc func cancel() {
        
        #if targetEnvironment(macCatalyst)
            /* remove highlight set by Mac workaround */
            tableView.indexPathsForSelectedRows?.forEach { tableView.cellForRow(at: $0)?.isHighlighted = false }
        #endif
        
        let exportButtonItem  = UIBarButtonItem(title:"Export", style: .plain, target: self, action: #selector(startExporting))
        self.navigationItem.setLeftBarButtonItems([exportButtonItem], animated: true)
        self.navigationItem.setRightBarButtonItems([], animated: true)
        tableView.allowsMultipleSelectionDuringEditing = false
        super.setEditing(false, animated: true)
        tableView.setEditing(false, animated: true)
    }
    
    @objc func selectAllItems() {
        let rows = tableView.numberOfRows(inSection: 0)
        for i in 0 ..< rows {
            let path = IndexPath(row: i, section: 0)
            tableView.selectRow(at: path, animated: true, scrollPosition: .none)
            tableView(tableView, didSelectRowAt: path)
        }
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
    
    #if targetEnvironment(macCatalyst)
    
    /*
        Workaround from ph1lb4 on SO
        https://stackoverflow.com/a/62061792/165180
     */
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("willSelectRowAt indexPath.row = \(indexPath.row)")
        if let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.contains(indexPath) {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        print("willDeselectRowAt indexPath.row = \(indexPath.row)")
        return nil
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        // the mac sets isHighlighted of each other cell to false before selecting them again which leads to a flickering of the selection. Therefore go through the selected cells and highlight them here manually
        tableView.indexPathsForSelectedRows?.forEach { tableView.cellForRow(at: $0)?.isHighlighted = true }
        return true
    }
    
    #else
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("willSelectRowAt indexPath.row = \(indexPath.row)")
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        print("willDeselectRowAt indexPath.row = \(indexPath.row)")
        return indexPath
    }
    
    #endif
    
    
}
