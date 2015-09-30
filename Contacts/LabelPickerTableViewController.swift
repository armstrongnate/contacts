//
//  LabelPickerTableViewController.swift
//  Rumple
//
//  Created by Nate Armstrong on 9/18/15.
//  Copyright © 2015 Rumple. All rights reserved.
//

import UIKit

protocol LabelPickerTableViewControllerDelegate {
    func labelPicker(picker: LabelPickerTableViewController, didSelectLabels labels: [String])
}

class LabelPickerTableViewController: UITableViewController {
    
    let labels: [String]
    var delegate: LabelPickerTableViewControllerDelegate?
    var activeLabels: [String] {
        get {
            return labels.filter { activeIndexes[labels.indexOf($0)!] }
        }
        set {
            for label in newValue {
                if let index = labels.indexOf(label) {
                    activeIndexes[index] = true
                }
            }
            tableView.reloadData()
        }
    }
    var activeIndexes: [Bool]
    var allowsMultipleSelection = true

    init(labels: [String]) {
        self.labels = labels
        self.activeIndexes = Array(count: labels.count, repeatedValue: false)
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "labelCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
    }

    func done() {
        delegate?.labelPicker(self, didSelectLabels: activeLabels)
    }
    
}

// MARK: - UITableViewDataSource
extension LabelPickerTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("labelCell")!
        cell.textLabel!.text = labels[indexPath.row]
        cell.accessoryType = .None
        if activeIndexes[indexPath.row] {
            cell.accessoryType = .Checkmark
        }
        return cell
    }

}

// MARK: - UITableViewDelegate
extension LabelPickerTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if !allowsMultipleSelection {
            activeIndexes[indexPath.row] = true
            delegate?.labelPicker(self, didSelectLabels: activeLabels)
            return
        }
        activeIndexes[indexPath.row] = !activeIndexes[indexPath.row]
        tableView.reloadData()
    }

}
