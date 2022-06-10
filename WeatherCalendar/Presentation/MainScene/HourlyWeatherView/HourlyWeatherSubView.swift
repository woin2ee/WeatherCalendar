//
//  HourlyWeatherSubView.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import UIKit
import SnapKit

struct HourlyWeatherSubView {
    static func of(date: String, kelvin: Double, iconImg: UIImage?) -> UIView {
        let hourLabel: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.text = date
            return lbl
        }()
        let weatherIcon: UIImageView = {
            let icon = UIImageView()
            icon.contentMode = .scaleAspectFit
            icon.image = iconImg
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
            $0.height.equalTo(12)
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
