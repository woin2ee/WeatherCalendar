//
//  ViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/04/11.
//

import UIKit
import FSCalendar // https://github.com/WenchaoD/FSCalendar

class ViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var todoTable: UITableView!
    
    let todoItem = ["One", "Two"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.dataSource = self
        calendar.delegate = self
        todoTable.dataSource = self
        todoTable.delegate = self
        
        self.setAppearance(of: calendar.appearance)
        
        // weekday 한/영 설정
        calendar.locale = Locale(identifier: "ko_KR")
//        calendar.locale = Locale(identifier: "en_EN")
        
        
        
        // Asia/Seoul 오늘 날씨 가져오기
        getCurrentWeatherInfo(lat: 37.5683, lon: 126.9778)
        
        
    }
    
    // Asia/Seoul : 37.5683 , 126.9778
    // https://openweathermap.org/api/one-call-api
    private func getCurrentWeatherInfo(lat: Double, lon: Double) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,daily,alerts&appid=\(Storage.API_KEY)") else {
            debugPrint("유효하지 않은 URL입니다.")
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, urlResponse, error in
            guard let data = data, error == nil else {
                debugPrint("data를 가져오지 못했습니다.")
                return
            }
            guard let weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: data) else {
                debugPrint("decode 실패")
                return
            }
            
            print(weatherInfo.current.printCurrentTime())
            
        }.resume()
        
    }
    
}

extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        print(dateFormatter.string(from: date) + "선택 됨")
        
    }
    
    func setAppearance(of ca: FSCalendarAppearance) {
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
}

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
