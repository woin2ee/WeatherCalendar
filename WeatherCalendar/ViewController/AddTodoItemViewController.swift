//
//  AddTodoItemViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/16.
//

import UIKit

class AddTodoItemViewController: UIViewController {
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedDate: Date?
    weak var calendarDelegate: CalendarDelegate?
    
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
        let formattedDate = TodoDateFormatter().string(from: datePicker.date)
        let item = TodoItem.create(date: formattedDate, content: self.content.text ?? "")
        TodoService.save(item: item)
        calendarDelegate?.showTodoList(date: datePicker.date)
        presentingViewController?.dismiss(animated: true)
    }
}
