import UIKit
import SnapKit
import Then

class BodyInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let instructionLabel = UILabel().then {
        $0.text = "신체정보를 입력해 주세요."
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }
    
    let addinstructionLabel = UILabel().then {
        $0.text = "매칭을 위해 필수 단계입니다. 이후 변경이 불가합니다."
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 16)
        $0.numberOfLines = 1
    }
    
    let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.isScrollEnabled = false // Disable scrolling if the table is short
    }
    
    let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.layer.cornerRadius = 30
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "나의 정보"
    }
    
    private func setupViews() {
        view.addSubview(instructionLabel)
        view.addSubview(addinstructionLabel)
        view.addSubview(tableView)
        view.addSubview(nextButton)
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addinstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(addinstructionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            let tableViewHeight = tableView.numberOfRows(inSection: 0) * 60 // 셀의 개수와 각 셀의 높이를 곱한 값
            make.height.equalTo(tableViewHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.bottom).offset(90)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // TableView DataSource and Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // Two cells for height and weight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        if indexPath.row == 0 {
            cell.textLabel?.text = "키가 어떻게 되세요?"
        } else {
            cell.textLabel?.text = "체형이 어떻게 되세요?"
        }
        return cell
    }
    
    
    
    // You can customize tableView delegate methods as needed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection for entering height and weight
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // 셀의 높이를 설정하는 메서드입니다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // 예상한 셀의 높이로 설정하세요.
    }

    // 섹션 헤더의 높이를 설정하는 메서드입니다.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude // 섹션 헤더를 사용하지 않는다면 최소한으로 설정
    }

    // 섹션 푸터의 높이를 설정하는 메서드입니다.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude // 섹션 푸터를 사용하지 않는다면 최소한으로 설정
    }

    
    @objc func nextButtonTapped() {
        // Validate the information and move to the next screen
    }
}
