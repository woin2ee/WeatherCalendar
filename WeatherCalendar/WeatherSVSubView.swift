//
//  WeatherSVSubView.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/12.
//

import UIKit
import SnapKit

class WeatherSVSubView: UIView {
    let formatter: KRDateFormatter = {
        let formatter = KRDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var hourLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    var weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    var temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    class WeatherIcon: UIImage {
        static func from(id: String) throws -> UIImage? {
            let url = URL(string: "http://openweathermap.org/img/wn/\(id)@2x.png")
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func of(dt: Double, temp kelvin: Double, iconId: String) -> UIView {
        let now = Date(timeIntervalSince1970: dt)
        let icon = try? WeatherIcon.from(id: iconId)
        let celsius = kelvin - 273.16
        
        hourLabel.text = formatter.string(from: now)
        weatherIcon.image = icon
        temperatureLabel.text = "\(Int(celsius))°"
        
        let subView: UIView = {
            let view = UIView()
            view.addSubview(hourLabel)
            view.addSubview(weatherIcon)
            view.addSubview(temperatureLabel)
            return view
        }()
        
        setConstraintsOfSubViews()
        
        return subView
    }
    
    private func setConstraintsOfSubViews() {
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
    }
}
