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
    @IBOutlet weak var hourlyWeatherView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.dataSource = self
        calendar.delegate = self
        
        initAppearance(with: calendar.appearance)
        initHourlyWeatherView()
        
        // weekday 한/영 설정
        calendar.locale = Locale(identifier: "ko_KR")
//        calendar.locale = Locale(identifier: "en_EN")
        
    }
    
    private func initAppearance(with ca: FSCalendarAppearance) {
        
        //캘린더 상단부분
        // 상단 월 표시 형태
        ca.headerDateFormat = "M월"
        // 상단 월 양옆에 흐린 글자
        ca.headerMinimumDissolvedAlpha = 0.0
        // 상단 월 글자 색
        ca.headerTitleColor = UIColor(red: 100/255, green: 60/255, blue: 253/255, alpha: 1)
        // 상단 요일 글자 색
        ca.weekdayTextColor = .black
        
        
        // 캘린더 안쪽 부분
        // 캘린더 배경색
        calendar.backgroundColor = UIColor(red:241/255, green: 240/255, blue: 255/255, alpha: 1)
        // 주말 일 글자 색
        ca.titleWeekendColor = .red
        // 선택한 날짜 색
        ca.selectionColor = UIColor(red: 100/255, green: 60/255, blue: 253/255, alpha: 0.5)
        // 선택된 날짜 모서리
        ca.borderRadius = 0.5
        // 오늘 날짜 색
        ca.todayColor = UIColor(red: 100/255, green: 60/255, blue: 230/255, alpha: 1)
        // 오늘 날짜가 선택됐을 때 색
        ca.todaySelectionColor = .red
       
        
        //ca.eventSelectionColor = .green
        //ca.eventDefaultColor = .yellow
        
        
    }
    
    private func initHourlyWeatherView() {
        let subViewCount = 10
        Task {
            guard let hourlyInfo = try? await WeatherInfo.of(Location.Asia.Seoul, .hourly)?.hourly else {
                return
            }
            for view in hourlyWeatherView.arrangedSubviews {
                hourlyWeatherView.removeArrangedSubview(view)
            }
            let startIndex = hourlyInfo.startIndex
            for i in startIndex..<startIndex + subViewCount {
                let subView = HourlyWeatherSubView.of(dt: Double(hourlyInfo[i].dt), temp: hourlyInfo[i].temp, iconId: hourlyInfo[i].weather[0].icon)
                hourlyWeatherView.addArrangedSubview(subView)
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
        guard let todoTableVC = children.first?.children.first as? TodoTableViewController else {
            return
        }
        todoTableVC.setTodoItem(accordingTo: date)
    }
}
