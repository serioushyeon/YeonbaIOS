import UIKit


class BlockingmanagementViewController: UIViewController {
    // MARK: - UI Components
    
    var blockUsers : [BlockUsers] = []
    lazy var tableView = UITableView().then {
        $0.register(UserBlockTableViewCell.self, forCellReuseIdentifier: "UserBlockTableViewCell")
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configUI()
    }
    
    func configUI() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    //MARK: -- Network
    
    func updateBlockUsers() {
        NetworkService.shared.mypageService.blockUsers() { response in
            switch response {
            case .success(let statusResponse):
                if let data = statusResponse.data {
                    print("요청 성공")
                }
            case .requestErr(let statusResponse):
                print("요청 에러: \(statusResponse.message)")
            case .pathErr:
                print("경로 에러")
            case .serverErr:
                print("서버 에러")
            case .networkErr:
                print("네트워크 에러")
            case .failure:
                print("실패")
            }
        }
    }

}

extension BlockingmanagementViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // For example
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserBlockTableViewCell.identifier, for: indexPath) as? UserBlockTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: "박원빈 님")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
    }
}
