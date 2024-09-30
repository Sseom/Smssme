//
//  NotificationManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/29/24.
//

import UserNotifications //사용자에게 허락 받기 위함
import FirebaseAuth

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    // 알림 권한 요청
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error)")
                completion(false)
            } else {
                print("알림 권한 요청 성공")
                completion(granted)
            }
        }
    }
    
    // 알림 생성
    func setupNotification(identifier: String, title: String, body: String, trigger: UNNotificationTrigger?, repeats: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 등록 실패: \(error)")
            } else {
                print("알림 등록 성공: \(identifier)")
            }
        }
    }
 
    // 매월 1일 오전 10시 알림 설정
        func firstDayOfMonthNotification() {
            var dateComponents = DateComponents()
            dateComponents.day = 1
            dateComponents.hour = 13
            dateComponents.minute = 0
            
            // repeats를 true로 설정하여 매월 1일에 반복되도록 설정
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            setupNotification(identifier: "firstDayOfMonth", title: "작심삼일은 멋진 시작이에요! 😎.", body: "작심삼일 10번 할 수 있잖아 완전 럭키비키잖앙🍀 이번 달 예산안 작성을 3분 안에 끝내보세요!", trigger: trigger, repeats: true)
        }
        
        // 매월 말일 알림 설정
        func lastDayOfMonthNotification() {
            let trigger = UNCalendarNotificationTrigger(dateMatching: getLastDayOfMonth(), repeats: true)
            setupNotification(identifier: "lastDayOfMonth", title: "이번 달에도 잘해냈어요!👍", body: "돈 관리, 나의 새로운 취미! 🎨 하지만 돈이 없으면 취미도 없다구요...빨리 들어오세요", trigger: trigger, repeats: true)
        }
        
        // 매월 마지막 날 계산 함수
        private func getLastDayOfMonth() -> DateComponents {
            let currentDate = Date()
            let calendar = Calendar.current
            
            // 현재 월의 마지막 날 구하기
            if let range = calendar.range(of: .day, in: .month, for: currentDate) {
                let lastDay = range.count
                var dateComponents = calendar.dateComponents([.year, .month], from: currentDate)
                dateComponents.day = lastDay
                dateComponents.hour = 21  // 오후 9시
                dateComponents.minute = 0
                
                return dateComponents
            }
            return DateComponents()
        }
    
    
    // 테스트
    func test() {
        let content = UNMutableNotificationContent()
        content.title = "가계부 작성 알림 테스트"
        content.body = "배가고파요!!!!"
        content.sound = .default
        content.badge = 1
        
        // 시간 간격으로 설정 -> 60초뒤에 실행!
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 등록 중 오류 발생: \(error)")
            }
        }
    }
    
    // 모든 알림 요청 취소
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("모든 알림 요청이 취소되었습니다.")
    }
    
    // 특정 알림 요청 취소
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("알림 요청이 취소되었습니다: \(identifier)")
    }

}
