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
    
    let hourlyWeatherCount = 10
    
    weak var todoTableDelegate: TodoTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.dataSource = self
        calendar.delegate = self
        
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupHourlyWeatherView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
        case "AddTodoSegue":
            let nc = segue.destination as? UINavigationController
            let vc = nc?.topViewController as? AddTodoItemViewController
            vc?.calendarDelegate = self
            vc?.selectedDate = calendar.selectedDate
        default:
            debugPrint("해당 segueId 에 대한 처리가 없습니다.")
            return
        }
    }
    
    func setupAppearance() {
        calendar.appearance.weekdayTextColor = .black
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.eventSelectionColor = .red
        calendar.appearance.eventDefaultColor = .black
        
        calendar.appearance.selectionColor = .blue
        calendar.appearance.todayColor = .brown
    }
    
    func setupHourlyWeatherView() {
        OpenWeatherMapService(location: Location.seoul.coordinates).fetchWeatherData {
            [self] (result: Result<WeatherData, APIRequestError>) in
            switch result {
            case .success(let data):
                drawHourlyWeatherView(by: data.hourly)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func drawHourlyWeatherView(by data: [Hourly]) {
        for i in 0..<hourlyWeatherCount {
            DispatchQueue.main.async {
                let subView = HourlyWeatherSubView.of(
                    dt: Double(data[i].dt),
                    temp: data[i].temp,
                    iconId: data[i].weather[0].icon
                )
                self.hourlyWeatherView.addArrangedSubview(subView)
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
        todoTableDelegate?.loadTodoList(selected: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let todo = TodoService.fetchAll()
        let formattedDate = TodoDateFormatter().string(from: date)
        return todo[formattedDate]?.count ?? 0 > 0 ? 1 : 0
    }
}

// MARK: - CalendarDelegate 구현

extension MainViewController: CalendarDelegate {
    func updateEventDot() {
        calendar.reloadData()
    }
    
    func showTodoList(date: Date) {
        calendar.reloadData() // Event Dot 을 위해 reload
        calendar(self.calendar, didSelect: date, at: .current) // 해당 날짜 선택 이벤트
        calendar.select(date) // 해당 날짜로 포커스 이동
        todoTableDelegate?.scrollToBottom() // 제일 아래로 스크롤
    }
}
