//
//  TodoTableViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/13.
//

import UIKit

protocol ActionRequestDelegate {
    func updateCalendar()
}

class TodoTableViewController: UIViewController {
    @IBOutlet weak var todoTable: UITableView!
    
    private var todoList = Todo.List(date: Date(), list: [""])
    var delegate: ActionRequestDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoTable.dataSource = self
        todoTable.delegate = self
        
        self.setTodoList(accordingTo: Date())
    }
    
    func setTodoList(accordingTo date: Date) {
        let formattedDate = CustomDateFormatter.forTodo().string(from: date)
        todoList = Todo.List(date: date, list: Todo.fetchList(by: formattedDate))
        todoTable.reloadSections(IndexSet(0...0), with: .none)
    }
}


// MARK: - DataSource & Delegate
extension TodoTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")

        var config = cell.defaultContentConfiguration()
        config.text = self.todoList[indexPath.row]

        cell.contentConfiguration = config

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") {
            Todo.delete(date: self.todoList.date, content: self.todoList[indexPath.row])
            self.setTodoList(accordingTo: self.todoList.date)
            self.delegate?.updateCalendar()
            $2(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
