//
//  HourlyWeatherSubView.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import UIKit
import SnapKit

class HourlyWeatherSubView {
    static let formatter: DateFormatter = {
        let df = CustomDateFormatter.kr()
        df.dateFormat = "HH:mm"
        return df
    }()
    
    // 날씨 표시가 오래걸리는 이유? - Assets에 파일로 넣는것 고려
    class WeatherIcon {
        static func from(id: String) throws -> UIImage? {
            let url = URL(string: "http://openweathermap.org/img/wn/\(id)@2x.png")
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)
        }
    }

    static func of(dt: Double, temp kelvin: Double, iconId: String) -> UIView {
        let hourLabel: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            return lbl
        }()
        let weatherIcon: UIImageView = {
            let icon = UIImageView()
            icon.contentMode = .scaleAspectFit
            return icon
        }()
        let temperatureLabel: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            return lbl
        }()
        
        let now = Date(timeIntervalSince1970: dt)
        let icon = try? WeatherIcon.from(id: iconId)
        let celsius = kelvin - 273.16
        
        hourLabel.text = formatter.string(from: now)
        weatherIcon.image = icon
        temperatureLabel.text = "\(Int(celsius))°"
        
        let view: UIView = {
            let view = UIView()
            view.addSubview(hourLabel)
            view.addSubview(weatherIcon)
            view.addSubview(temperatureLabel)
            return view
        }()
        
        setConstraints(of: view.subviews)
        
        return view
    }
    
    private static func setConstraints(of views: [UIView]) {
        views[0].snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(15)
        }
        views[1].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(views[0].snp.bottom).offset(2)
            $0.height.equalTo(40)
        }
        views[2].snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(views[1].snp.bottom).offset(2)
        }
    }
}
