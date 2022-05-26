//
//  TodoTableViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/13.
//

import UIKit

protocol CalendarDelegate {
    func updateEventDot()
}

class TodoTableViewController: UIViewController {
    @IBOutlet weak var todoTable: UITableView!
    
    private var todoList = Todo.List(date: Date(), list: [""])
    
    var calendarDelegate: CalendarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoTable.dataSource = self
        todoTable.delegate = self
        
        reloadTodoList(selected: Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarDelegate = self.parent as? MainViewController
        (self.parent as? MainViewController)?.todoTableDelegate = self
    }
    
    func reloadTodoList(selected date: Date) {
        let formattedDate = TodoDateFormatter().string(from: date)
        todoList = Todo.List(date: date, list: Todo.fetchList(by: formattedDate))
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
            Todo.delete(date: todoList.date, content: todoList[indexPath.row])
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
        reloadTodoList(selected: date)
    }
}
