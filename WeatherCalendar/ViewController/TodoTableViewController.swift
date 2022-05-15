//
//  TodoTableViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/13.
//

import UIKit

class TodoTableViewController: UIViewController {
    @IBOutlet weak var todoTable: UITableView!
    
    private var todoItem = ["One", "Two"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTable.dataSource = self
        todoTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setTodoItem(accordingTo date: Date) {
        let date = CustomDateFormatter.forTodo().string(from: date)
        todoItem = Todo().fetchList(by: date)
        todoTable.reloadSections(IndexSet(0...0), with: .none)
    }
    
    @IBAction func AddTodoItem(_ sender: UIBarButtonItem) {
        let todo = Todo()
        
        // save 테스트
        let item = todo.createItem(date: "2022. 5. 11.", content: "TestItem 11일")
        todo.save(item: item)

        print("Success Add Todo Item!")
        
        // fetch 테스트
        todo.showAllTodoList()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TodoTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")

        var config = cell.defaultContentConfiguration()
        config.text = todoItem[indexPath.row]

        cell.contentConfiguration = config

        return cell
    }
}
