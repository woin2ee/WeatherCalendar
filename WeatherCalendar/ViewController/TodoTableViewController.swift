//
//  TodoTableViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/13.
//

import UIKit

class TodoTableViewController: UIViewController {
    @IBOutlet weak var todoTable: UITableView!
    
    var todoList = TodoList(date: TodoDateFormatter().string(from: Date()), list: [""])
    
    weak var calendarDelegate: CalendarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoTable.dataSource = self
        todoTable.delegate = self
        
        reloadTodoList(selected: TodoDateFormatter().string(from: Date()))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calendarDelegate = self.parent as? MainViewController
        (self.parent as? MainViewController)?.todoTableDelegate = self
    }
    
    func reloadTodoList(selected date: String) {
        todoList = TodoList(date: date, list: TodoService().fetchList(by: date))
        todoTable.reloadSections(IndexSet(0...0), with: .none)
    }
}

// MARK: - UITableView DataSource & Delegate
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
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [self] in
            TodoService().delete(date: todoList.date, content: todoList[indexPath.row])
            reloadTodoList(selected: todoList.date)
            if todoList.list.isEmpty {
                calendarDelegate?.updateEventDot()
            }
            $2(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - TodoTableDelegate 구현

extension TodoTableViewController: TodoTableDelegate {
    func loadTodoList(selected date: Date) {
        let formattedDate = TodoDateFormatter().string(from: date)
        reloadTodoList(selected: formattedDate)
    }
    
    func scrollToBottom() {
        let numOfRows = todoTable.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: numOfRows - 1, section: 0)
        todoTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
