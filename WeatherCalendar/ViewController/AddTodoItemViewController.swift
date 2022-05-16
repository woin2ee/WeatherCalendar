//
//  AddTodoItemViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/16.
//

import UIKit

// date 데이터를 전달 받는 곳에서 구현해주면 됨
protocol SendDateDelegate {
    func send(date: Date)
}

class AddTodoItemViewController: UIViewController {
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedDate: Date?
    var delegate: SendDateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initDatePicker()
    }

    private func initDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.date = self.selectedDate ?? Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1000, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -1000, to: Date())
    }
    
    // 취소 버튼
    @IBAction func dismissModal(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    // 추가 버튼
    @IBAction func addTodoItem(_ sender: Any) {
        let formattedDate = CustomDateFormatter.forTodo().string(from: datePicker.date)
        let todo = Todo()
        let item = todo.createItem(date: formattedDate, content: self.content.text ?? "")
        todo.save(item: item)
        delegate?.send(date: datePicker.date)
        presentingViewController?.dismiss(animated: true)
    }
}
