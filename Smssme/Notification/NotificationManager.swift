//
//  NotificationManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/29/24.
//

import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    // 알림 권한 요청 -> 최초 앱 실행 시에만 나타나며 이후 권한 수정은 아이폰 '설정->알림'에서 사용자가 직접 변경.
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
    
    // 테스트
    func test() {
        let content = UNMutableNotificationContent()
        content.title = "이번 달에도 잘해냈어요!👍"
        content.body = "돈 관리, 나의 새로운 취미! 🎨 하지만 돈이 없으면 취미도 없다구요...빨리 들어오세요!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 등록 중 오류 발생: \(error)")
            }
        }
    }
        
    // 마이페이지 알림 토글 활성화 설정
    func setNotificationEnabled(userID: String?) {
        if let userId = userID {
            FirebaseFirestoreManager.shared.fetchUserData(uid: userId) { [weak self] result in
                switch result {
                case .success(let data):
                    if let isEnabled = data["notificationsEnabled"] as? Bool , isEnabled {
                        // 알림 설정이 활성화된 경우
                        self?.test()
                        self?.firstDayOfMonthNotification()
                        self?.lastDayOfMonthNotification()
                    }
                case .failure(let error):
                    print("사용자 데이터를 가져오는 도중 오류 발생:\(error.localizedDescription)")
                }
            }
        } else {
            // 비회원 로그인 시 알림 설정
            self.test()
            self.firstDayOfMonthNotification()
            self.lastDayOfMonthNotification()
        }
        
        
    }
    
    // 알림 생성
    func createNotification(identifier: String, title: String, body: String, trigger: UNNotificationTrigger?, repeats: Bool) {
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
        dateComponents.hour = 10
        dateComponents.minute = 0
        
        // repeats를 true로 설정하여 매월 1일에 반복되도록 설정
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        createNotification(identifier: "firstDayOfMonth", title: "작심삼일 10번이면 한달이에요! 😎", body: "이번 달 예산안 작성을 3분 안에 끝내보세요!", trigger: trigger, repeats: true)
    }
    
    // 매월 말일 알림 설정
    func lastDayOfMonthNotification() {
        let trigger = UNCalendarNotificationTrigger(dateMatching: getLastDayOfMonth(), repeats: true)
        createNotification(identifier: "lastDayOfMonth", title: "이번 달에도 잘해냈어요!👍", body: "마지막으로 지출 내역 정리하고 뿌듯한 이번 달을 마무리해보세요!", trigger: trigger, repeats: true)
    }
    
    // 매월 마지막 날 계산 함수
    func getLastDayOfMonth() -> DateComponents {
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
