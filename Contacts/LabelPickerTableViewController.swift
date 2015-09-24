//
//  LabelPickerTableViewController.swift
//  Rumple
//
//  Created by Nate Armstrong on 9/18/15.
//  Copyright © 2015 Rumple. All rights reserved.
//

import UIKit

protocol LabelPickerTableViewControllerDelegate {
    func labelPicker(picker: LabelPickerTableViewController, didSelectLabel label: String)
}

class LabelPickerTableViewController: UITableViewController {
    
    var labels: [String]
    var delegate: LabelPickerTableViewControllerDelegate?
    var activeLabel: String? {
        didSet {
            tableView.reloadData()
        }
    }
    var activeIndex: Int? {
        guard let active = activeLabel else {
            return nil
        }
        return labels.indexOf(active)
    }
    
    init(labels: [String]) {
        self.labels = labels
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "labelCell")
        cell.textLabel!.text = labels[indexPath.row]
        cell.accessoryType = .None
        if let activeIndex = activeIndex where activeIndex == indexPath.row {
            cell.accessoryType = .Checkmark
        }
        return cell
    }

}

// MARK: - UITableViewDelegate
extension LabelPickerTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        activeLabel = labels[indexPath.row]
        delegate?.labelPicker(self, didSelectLabel: activeLabel!)
    }

}
