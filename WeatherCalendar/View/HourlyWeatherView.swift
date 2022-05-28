//
//  HourlyWeatherView.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/29.
//

import UIKit

class HourlyWeatherView: UIStackView {
    let hourlyWeatherCount = 10
    
    func setupHourlyWeatherView() {
        removeFullyAllArrangedSubviews()
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
                
                self.addArrangedSubview(subView)
                
                subView.snp.makeConstraints {
                    $0.width.equalTo(60)
                }
            }
        }
    }
    
    func removeFully(view: UIView) {
        self.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        self.arrangedSubviews.forEach {
            removeFully(view: $0)
        }
    }
}
