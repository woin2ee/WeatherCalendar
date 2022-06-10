//
//  HourlyWeatherView.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/29.
//

import UIKit

class HourlyWeatherView: UIStackView {
    let weatherService: WeatherService
    
    let displayingCount = 20
    
    required init(coder: NSCoder) {
        weatherService = OpenWeatherMapService(location: Location.seoul.coordinates)
        super.init(coder: coder)
    }
    
    func updateView() {
        removeFullyAllArrangedSubviews()
        weatherService.fetchHourlyWeatherData {
            [self] (result: Result<[HourlyWeatherDTO], APIRequestError>) in
            switch result {
            case .success(let data):
                setSubViews(by: data)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func setSubViews(by data: [HourlyWeatherDTO]) {
        for i in 0..<displayingCount {
            DispatchQueue.main.async {
                let subView = HourlyWeatherSubView.of(
                    date: data[i].date,
                    kelvin: data[i].kelvin,
                    iconImg: data[i].iconImg
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
