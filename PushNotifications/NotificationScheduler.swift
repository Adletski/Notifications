
import UIKit
import UserNotifications

protocol NotificationScheduler {
  func scheduleNotification(trigger: UNNotificationTrigger, titleTextField: UITextField, sound: Bool, badge: String?)
}

extension NotificationScheduler where Self: UIViewController {
  func scheduleNotification(trigger: UNNotificationTrigger, titleTextField: UITextField, sound: Bool, badge: String?) {
    guard let title = titleTextField.toTrimmedString() else {
      UIAlertController.okWithMessage("Please specify a title.", presentingViewController: self)
      return
    }
    let content = UNMutableNotificationContent()
    content.title = title
    if sound {
      content.sound = UNNotificationSound.default()
    }
    if let badge = badge, let number = Int(badge) {
      content.badge = NSNumber(value: number)
    }
    
    let id = UUID().uuidString
    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { [weak self] error in
      if let error = error {
        DispatchQueue.main.async {
          let message = "Fail \(error.localizedDescription)"
          UIAlertController.okWithMessage(message, presentingViewController: self)
        }
        
      } else {
        DispatchQueue.main.async {
          self?.navigationController?.popViewController(animated: true)
        }
      }
    }
  }
}
