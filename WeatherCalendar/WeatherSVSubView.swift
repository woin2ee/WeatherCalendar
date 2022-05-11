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
        return icon
    }()
    var temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func of(dt: Double, temp kelvin: Double) -> UIView {
        let now = Date(timeIntervalSince1970: dt)
        // 이미지 파싱 추가
        let celsius = kelvin - 273.16
        
        hourLabel.text = formatter.string(from: now)
        weatherIcon.image = UIImage(systemName: "sun.min.fill")
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
