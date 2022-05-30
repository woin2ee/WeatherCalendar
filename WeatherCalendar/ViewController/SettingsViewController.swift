//
//  SettingsViewController.swift
//  WeatherCalendar
//
//  Created by Jaewon on 2022/05/28.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        settingsTable.dataSource = self
        settingsTable.delegate = self
        
        
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell") as! SettingsTableViewSwitchCell

        var config = cell.defaultContentConfiguration()
        config.text = "\(indexPath)"
        config.image = UIImage(systemName: "line.3.horizontal")
        config.secondaryText = indexPath.description
        
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(indexPath.description)
    }
}
