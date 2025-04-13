//
//  NotificationHelper.swift
//  PishiDino
//
//  Created by ala omidfar on 4/12/25.
//

import UserNotifications
import CoreData

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleDailyMemoryNotification(memories: [MemoryEntity]) {
        guard let randomMemory = memories.randomElement(),
              let title = randomMemory.title else {
            print("No memory to schedule.")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Memory of the Day"
        content.body = title
        content.sound = .default

        // Set time to 10 AM every day
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "dailyMemory",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Scheduled daily memory notification")
            }
        }
    }
}
