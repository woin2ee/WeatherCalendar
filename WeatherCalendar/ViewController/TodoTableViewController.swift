//
//  TodoTableViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/13.
//

import UIKit

class TodoTableViewController: UIViewController {
    @IBOutlet weak var todoTable: UITableView!
    
    private var todoList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoTable.dataSource = self
        todoTable.delegate = self
        
        self.setTodoList(accordingTo: Date())
    }
    
    func setTodoList(accordingTo date: Date) {
        let date = CustomDateFormatter.forTodo().string(from: date)
        todoList = Todo().fetchList(by: date)
        todoTable.reloadSections(IndexSet(0...0), with: .none)
    }
}


// MARK: - DataSource & Delegate
extension TodoTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")

        var config = cell.defaultContentConfiguration()
        config.text = todoList[indexPath.row]

        cell.contentConfiguration = config

        return cell
    }
}
