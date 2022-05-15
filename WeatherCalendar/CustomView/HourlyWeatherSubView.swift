//
//  HourlyWeatherSubView.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import UIKit
import SnapKit

class HourlyWeatherSubView {
    static func of(dt: Double, temp kelvin: Double, iconId: String) -> UIView {
        let formatter: DateFormatter = {
            let df = CustomDateFormatter.kr()
            df.dateFormat = "HH:mm"
            return df
        }()
        
        let hourLabel: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            let now = Date(timeIntervalSince1970: dt)
            lbl.text = formatter.string(from: now)
            return lbl
        }()
        let weatherIcon: UIImageView = {
            let icon = UIImageView()
            icon.contentMode = .scaleAspectFit
            let img = UIImage(named: iconId)
            icon.image = img
            return icon
        }()
        let temperatureLabel: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            let celsius = kelvin - 273.16
            lbl.text = "\(Int(celsius))°"
            return lbl
        }()
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
