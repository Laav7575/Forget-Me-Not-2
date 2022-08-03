//
//  ViewController.swift
//  Forget Me Not 2
//
//  Created by CoopStudent on 7/18/22.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet var table: UITableView!
    
    var models = [Reminders] ()
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.stopUpdatingLocation()
        locationManager.distanceFilter = 100
        // Do any additional setup after loading the view.
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(43.61871, -122.406417), radius: 100, identifier: "You're home. Take you medication")
        locationManager.startMonitoring(for: geoFenceRegion)
    }

    @IBAction func dipTapAdd() {
        //show add vc
        //guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else {
         //   return
       // }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else { return}
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = Reminders(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                let request = UNNotificationRequest(identifier: "somelongid", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dipTapLocation() {
        //show add vc
        //guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? LocationVC else { return}
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? LocationVC else {return}
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionL = {title, body, alt, long in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let date = Date()
                let new = Reminders(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                let request = UNNotificationRequest(identifier: "somelongid", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dipTapTest() {
        //run test notif
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                //schedule test
                self.scheduleTest()
            } else if error != nil {
                print("error occurred")
                
            }
        })
       
    }
    
    func scheduleTest () {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "My long body. My long body. My long body. My long body. My long body."
        
        let targetDate = Date().addingTimeInterval(10)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "somelongid", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for currentLocation in locations{
            print("\(index): \(currentLocation)")
            // "0: [locations]"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered: \(region.identifier)")
        postLocalNotifications(eventTitle: "Entered: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited: \(region.identifier)")
        postLocalNotifications(eventTitle: "Exited: \(region.identifier)")
    }
    
    
}

extension ViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY @ hh:mm"
        print(date)
        
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
}

func postLocalNotifications(eventTitle:String){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = "You've entered a new region"
    content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let notificationRequest:UNNotificationRequest = UNNotificationRequest(identifier: "Region", content: content, trigger: trigger)
        
        center.add(notificationRequest, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
                print(error)
            }
            else{
                print("added")
            }
        })
    }
    

struct Reminders {
    let title: String
    let date: Date
    let identifier: String
}
struct RemindersL {
    let title: String
    let locationAlt: Int
    let locationLat: Int
    let identifier: String
}
