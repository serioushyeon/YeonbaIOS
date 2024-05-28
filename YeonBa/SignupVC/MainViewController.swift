import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 여기에 메인 화면을 구성하는 코드를 추가합니다.

        checkAttendance()
    }

    private func checkAttendance() {
        let lastPopupDateKey = "lastPopupDate"
        let lastPopupDate = UserDefaults.standard.object(forKey: lastPopupDateKey) as? Date ?? Date.distantPast
        let currentDate = Date()
        
        if !Calendar.current.isDate(lastPopupDate, inSameDayAs: currentDate) {
            // 하루가 지났다면 팝업을 띄웁니다.
            showAttendancePopup()
            // 마지막 팝업 본 시간을 현재 시간으로 업데이트
            UserDefaults.standard.set(currentDate, forKey: lastPopupDateKey)
        }
    }

    private func showAttendancePopup() {
        let attendancePopupVC = AttendancePopupViewController()
        attendancePopupVC.modalPresentationStyle = .overFullScreen
        attendancePopupVC.modalTransitionStyle = .crossDissolve
        present(attendancePopupVC, animated: true, completion: nil)
    }
}
