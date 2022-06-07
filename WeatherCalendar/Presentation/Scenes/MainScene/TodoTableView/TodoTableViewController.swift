//
//  TodoTableViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/13.
//

import UIKit

class TodoTableViewController: UIViewController {
    @IBOutlet weak var todoTable: UITableView!
    
    var todoList = [TodoItem]()
    
    weak var calendarDelegate: CalendarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTable.dataSource = self
        todoTable.delegate = self
        
        reloadTodoList(selected: Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calendarDelegate = self.parent as? MainViewController
    }
    
    func reloadTodoList(selected date: Date?) {
        todoList = TodoService().fetchList(by: date ?? Date())
        todoTable.reloadSections(IndexSet(0...0), with: .none)
    }
}

// MARK: - UITableView DataSource & Delegate
extension TodoTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")

        var config = cell.defaultContentConfiguration()
        config.text = todoList[indexPath.row].content

        cell.contentConfiguration = config

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [self] in
            let targetItem = todoList[indexPath.row]
            TodoService().delete(item: targetItem)
            reloadTodoList(selected: targetItem.date)
            if todoList.isEmpty {
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
        reloadTodoList(selected: date)
    }
    
    func scrollToBottom() {
        let numOfRows = todoTable.numberOfRows(inSection: 0)
        guard (1...todoList.count).contains(numOfRows) else { return }
        let indexPath = IndexPath(row: numOfRows - 1, section: 0)
        todoTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
