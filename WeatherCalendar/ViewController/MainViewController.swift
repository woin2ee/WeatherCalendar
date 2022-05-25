//
//  MainViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/04/11.
//

import UIKit
import FSCalendar // https://github.com/WenchaoD/FSCalendar
import SnapKit

class MainViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var hourlyWeatherView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.dataSource = self
        calendar.delegate = self
        guard let todoTableVC = children.first as? TodoTableViewController else {
            return
        }
        todoTableVC.delegate = self
        
        initAppearance(with: calendar.appearance)
        initHourlyWeatherView()
        
        // weekday 한/영 설정
        calendar.locale = Locale(identifier: "ko_KR")
//        calendar.locale = Locale(identifier: "en_EN")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let nc = segue.destination as? UINavigationController,
            let addTodoItemVC = nc.topViewController as? AddTodoItemViewController
        else { return }
        addTodoItemVC.delegate = self
        addTodoItemVC.selectedDate = calendar.selectedDate
    }
    
    // MARK: - Private Method
    
    private func initAppearance(with ca: FSCalendarAppearance) {
        ca.headerTitleColor = .red
        ca.weekdayTextColor = .red
        
        ca.eventSelectionColor = .green
        ca.eventDefaultColor = .magenta
        
        ca.selectionColor = .brown
        ca.todayColor = .blue
        
        ca.todaySelectionColor = .red
        
        ca.headerDateFormat = ""
        
        ca.headerMinimumDissolvedAlpha = 0.0
        
//        ca.borderRadius = 0
    }
    
    private func initHourlyWeatherView() {
        let subViewCount = 10
        Task {
            guard let weatherInfo = try? await WeatherInfo.of(Location.Asia.Seoul)?.hourly else {
                return
            }
            
            for view in hourlyWeatherView.arrangedSubviews {
                hourlyWeatherView.removeArrangedSubview(view)
            }
            let startIndex = weatherInfo.startIndex
            for i in startIndex..<startIndex + subViewCount {
                let subView = HourlyWeatherSubView.of(dt: Double(weatherInfo[i].dt), temp: weatherInfo[i].temp, iconId: weatherInfo[i].weather[0].icon)
                hourlyWeatherView.addArrangedSubview(subView)
                subView.snp.makeConstraints {
                    $0.width.equalTo(60)
                }
            }
        }
    }
}

// MARK: - FSCalendar DataSource & Delegate

extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let todoTableVC = children.first as? TodoTableViewController else {
            return
        }
        todoTableVC.setTodoList(accordingTo: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let todo = Todo.fetchAll()
        let formattedDate = TodoDateFormatter().string(from: date)
        return todo[formattedDate]?.count ?? 0 > 0 ? 1 : 0
    }
}

// MARK: - Delegate로 Data 전달

extension MainViewController: SendDateDelegate {
    func send(date: Date) {
        calendar.reloadData()
        calendar(self.calendar, didSelect: date, at: .current)
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        guard let todoTableVC = children.first as? TodoTableViewController else {
            return
        }
        let numOfRows = todoTableVC.todoTable.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: numOfRows - 1, section: 0)
        todoTableVC.todoTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: -
extension MainViewController: ActionRequestDelegate {
    func updateCalendar() {
        calendar.reloadData()
    }
}
