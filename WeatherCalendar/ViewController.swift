//
//  ViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/04/11.
//

import UIKit
import FSCalendar // https://github.com/WenchaoD/FSCalendar
import SnapKit

class ViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var weatherSV: UIStackView!
    
    var todoItem = ["One", "Two"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDataSourceAndDelegate()
        initAppearance(with: calendar.appearance)
        initWeatherSV()
        
        // weekday 한/영 설정
        calendar.locale = Locale(identifier: "ko_KR")
//        calendar.locale = Locale(identifier: "en_EN")
        
    }
    
    private func setDataSourceAndDelegate() {
        calendar.dataSource = self
        calendar.delegate = self
        todoTable.dataSource = self
        todoTable.delegate = self
    }
    
    private func initAppearance(with ca: FSCalendarAppearance) {
        ca.headerTitleColor = .red
        ca.weekdayTextColor = .red
        
        ca.eventSelectionColor = .green
        ca.eventDefaultColor = .yellow
        
        ca.selectionColor = .brown
        ca.todayColor = .blue
        
        ca.todaySelectionColor = .red
        
        ca.headerDateFormat = "M월"
        
        ca.headerMinimumDissolvedAlpha = 0.0
        
        ca.borderRadius = 0
    }
    
    private func initWeatherSV() {
        let subViewCount = 10
        Task {
            guard let hourlyInfo = try? await WeatherInfo.of(Location.Asia.Seoul, .hourly)?.hourly else {
                debugPrint("날씨 정보를 불러오지 못했습니다.")
                return
            }
            for subView in weatherSV.arrangedSubviews {
                weatherSV.removeArrangedSubview(subView)
            }
            let startIndex = hourlyInfo.startIndex
            for i in startIndex..<startIndex + subViewCount {
                let subView = WeatherSVSubView.of(dt: Double(hourlyInfo[i].dt), temp: hourlyInfo[i].temp, iconId: hourlyInfo[i].weather[0].icon)
                weatherSV.addArrangedSubview(subView)
                subView.snp.makeConstraints {
                    $0.width.equalTo(60)
                }
            }
        }
    }
}

// FSCalender extension
extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let date = CustomDateFormatter.forTodo().string(from: date)
        todoItem = Todo.getItem(as: date)
        todoTable.reloadSections(IndexSet(0...0), with: .automatic)
    }
}

// TableView extension
extension ViewController: UITableViewDataSource, UITableViewDelegate {
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
