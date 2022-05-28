//
//  MainViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/04/11.
//

import UIKit
import FSCalendar // https://github.com/WenchaoD/FSCalendar
import SnapKit

class MainViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var hourlyWeatherView: HourlyWeatherView!
    @IBOutlet weak var pullDownMenuButton: UIBarButtonItem!
    
    weak var todoTableDelegate: TodoTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calendar.dataSource = self
        calendar.delegate = self
        
        setupCalendarAppearance()
        setupPullDownMenuButton()
        setupBackBarButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hourlyWeatherView.setupHourlyWeatherView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        
        switch segueId {
        case "AddTodoSegue":
            let nc = segue.destination as? UINavigationController
            let vc = nc?.topViewController as? AddTodoItemViewController
            vc?.calendarDelegate = self
            vc?.selectedDate = calendar.selectedDate
        default:
            debugPrint("해당 segueId 에 대한 처리가 없습니다.")
            return
        }
    }
    
    func setupCalendarAppearance() {
        calendar.appearance.weekdayTextColor = .black
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.eventSelectionColor = .red
        calendar.appearance.eventDefaultColor = .black
        
        calendar.appearance.selectionColor = .blue
        calendar.appearance.todayColor = .brown
    }
    
    func setupPullDownMenuButton() {
        let settings = UIAction(title: "설정", image: UIImage(systemName: "gearshape.fill")) { _ in
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        pullDownMenuButton.menu = UIMenu(children: [settings])
    }
    
    func setupBackBarButtonItem() {
        let backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}

// MARK: - FSCalendar DataSource & Delegate

extension MainViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        todoTableDelegate?.loadTodoList(selected: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let todo = TodoService().fetchAll()
        let formattedDate = TodoDateFormatter().string(from: date)
        return todo[formattedDate]?.count ?? 0 > 0 ? 1 : 0
    }
}

// MARK: - CalendarDelegate 구현

extension MainViewController: CalendarDelegate {
    func updateEventDot() {
        calendar.reloadData()
    }
    
    func showTodoList(date: Date) {
        calendar.reloadData() // Event Dot 을 위해 reload
        calendar(self.calendar, didSelect: date, at: .current) // 해당 날짜 선택 이벤트
        calendar.select(date) // 해당 날짜로 포커스 이동
        todoTableDelegate?.scrollToBottom() // 제일 아래로 스크롤
    }
}
