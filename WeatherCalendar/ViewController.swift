//
//  ViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/04/11.
//

import UIKit
import FSCalendar // https://github.com/WenchaoD/FSCalendar
import SnapKit

enum APIOptions {
    case current, hourly, daily
}

class ViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var todoTable: UITableView!
    @IBOutlet weak var weatherSV: UIStackView!
    let todoItem = ["One", "Two"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDataSourceAndDelegate()
        setAppearance(of: calendar.appearance)
        setWeatherSV()
        
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
    
    private func setWeatherSV() {
        Task {
            guard let hourlyInfo = try? await getWeatherInfo(lat: 37.5683, lon: 126.9778, .hourly)?.hourly else {
                debugPrint("날씨 정보를 불러오지 못했습니다.")
                return
            }
            let formatter = KRDateFormatter()
            formatter.dateFormat = "HH:mm"
            
            for i in 0..<10 {
                let now = Date(timeIntervalSince1970: Double(hourlyInfo[i].dt))
                let hourLabel: UILabel = {
                    let lbl = UILabel()
                    lbl.text = formatter.string(from: now)
                    lbl.textAlignment = .center
                    
                    return lbl
                }()
                
                let weatherIcon: UIImageView = {
                    let icon = UIImageView()
                    icon.image = UIImage(systemName: "sun.min.fill")
                    
                    return icon
                }()
                
                let kelvin = hourlyInfo[i].temp
                let celsius = kelvin - 273.16
                let temperatureLabel: UILabel = {
                    let lbl = UILabel()
                    lbl.text = "\(Int(celsius))°"
                    lbl.textAlignment = .center
                    
                    return lbl
                }()
                
                let view: UIView = {
                    let view = UIView()
                    view.addSubview(hourLabel)
                    view.addSubview(weatherIcon)
                    view.addSubview(temperatureLabel)
                    
                    return view
                }()
                
                weatherSV.addArrangedSubview(view)
                
                hourLabel.snp.makeConstraints {
                    $0.leading.trailing.top.equalToSuperview()
                    $0.height.equalTo(15)
                }
                weatherIcon.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.top.equalTo(hourLabel.snp.bottom).offset(2)
                    $0.height.equalTo(40)
                }
                temperatureLabel.snp.makeConstraints {
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.top.equalTo(weatherIcon.snp.bottom).offset(2)
                }
                view.snp.makeConstraints {
                    $0.width.equalTo(60)
                }
            }
        }
    }
    
    /// - Parameter options: [current: 현재 시각의 날씨 데이터, hourly: 현재 시각 기준 48시간의 예측 데이터, daily: 오늘 기준 7일 동안의 예측 데이터]
    fileprivate func getWeatherInfo(lat: Double, lon: Double, _ option: APIOptions) async throws -> WeatherInfo? {
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
        // Asia/Seoul - (lat: 37.5683 , lon: 126.9778)
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
