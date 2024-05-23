import Foundation

class ArrowCountManager {
    static let shared = ArrowCountManager()
    private init() {}
    
    private(set) var arrowCount: Int = 31 {
        didSet {
            NotificationCenter.default.post(name: .arrowCountDidChange, object: nil)
        }
    }
    
    func incrementArrowCount(by amount: Int) {
        arrowCount += amount
    }
    
    func setArrowCount(to newValue: Int) {
        arrowCount = newValue
    }
    
    func updateArrowCountFromServer() {
        guard let url = URL(string: "https://api.yeonba.co.kr/User/arrows") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Received JSON: \(json)") // 전체 JSON 출력
                    
                    if let data = json["data"] as? [String: Any],
                       let arrows = data["arrows"] as? Int {
                        DispatchQueue.main.async {
                            self.setArrowCount(to: arrows)
                            print("Successfully updated arrow count to \(arrows)")
                        }
                    } else {
                        print("Failed to parse JSON or no 'arrows' field in JSON")
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }
        
        task.resume()
    }
}

extension Notification.Name {
    static let arrowCountDidChange = Notification.Name("arrowCountDidChange")
}
