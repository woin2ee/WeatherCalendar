//
//  ViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/04/11.
//

import UIKit
import FSCalendar // https://github.com/WenchaoD/FSCalendar

enum APIOptions {
    case current, hourly, daily
}

class ViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var weatherStack: UIStackView!
    let todoItem = ["One", "Two"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDataSourceAndDelegate()
        setAppearance(of: calendar.appearance)
        
        // weekday 한/영 설정
        calendar.locale = Locale(identifier: "ko_KR")
//        calendar.locale = Locale(identifier: "en_EN")
        
        Task {
            // Asia/Seoul - (lat: 37.5683 , lon: 126.9778)
            try? await getWeatherInfo(lat: 37.5683, lon: 126.9778, .current)?.current?.printDataTime()
            try? await getWeatherInfo(lat: 37.5683, lon: 126.9778, .hourly)?.hourly?.first?.printDataTime()
            try? await getWeatherInfo(lat: 37.5683, lon: 126.9778, .daily)?.daily?.first?.printDataTime()
            try? await getWeatherInfo(lat: 37.5683, lon: 126.9778, .daily)?.daily?.last?.printDataTime()
        }

    }
    
    private func setDataSourceAndDelegate() {
        calendar.dataSource = self
        calendar.delegate = self
        todoTable.dataSource = self
        todoTable.delegate = self
    }
    
    /// - Parameter options: [current: 현재 시각의 날씨 데이터, hourly: 현재 시각 기준 48시간의 예측 데이터, daily: 오늘 기준 7일 동안의 예측 데이터]
    private func getWeatherInfo(lat: Double, lon: Double, _ option: APIOptions) async throws -> WeatherInfo? {
        let excludeString: String
        switch option {
        case .current:
            excludeString = "minutely,alerts,hourly,daily"
        case .hourly:
            excludeString = "minutely,alerts,current,daily"
        case .daily:
            excludeString = "minutely,alerts,hourly,current"
        }
        // URL 형식 참조: https://openweathermap.org/api/one-call-api
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=\(excludeString)&appid=\(Storage.API_KEY)")
        else {
            debugPrint(#function)
            return nil
        }
        let (data, response) = try await URLSession.shared.data(from: url) // url 요청이 실패하면 throw
        let successRange = 200..<300
        guard successRange.contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
            debugPrint(#function)
            return nil
        }
        return try JSONDecoder().decode(WeatherInfo.self, from: data) // decode 실패하면 throw
    }
//
//    private func 날짜가선택됨() {
//        스택뷰에로딩표시()
//        날씨정보를받아옴()
//        날씨정보로시간별서브뷰배열생성()
//        스택뷰에로딩표시지움()
//        스택뷰에일괄추가()
//    }
}

// FSCalender extension
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
