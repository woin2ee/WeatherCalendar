//
//  StubTodoTableViewController.swift
//  WeatherCalendarTests
//
//  Created by Jaewon on 2022/05/28.
//

import Foundation
import UIKit

class StubTodoTableViewController: UIViewController {
    let count = 10
    
    let todoTable = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
    
    override func viewDidLoad() {
        todoTable.delegate = self
        todoTable.dataSource = self
    }
    
    func scrollToBottom(numOfRows: Int) {
        guard (1...count).contains(numOfRows) else { return }
        let indexPath = IndexPath(row: numOfRows - 1, section: 0)
        todoTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension StubTodoTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")

        var config = cell.defaultContentConfiguration()
        config.text = indexPath.description

        cell.contentConfiguration = config

        return cell
    }
    
    
}
