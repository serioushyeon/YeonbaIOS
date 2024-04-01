//
//  LocationModalViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/19/24.
//

import UIKit
import Then
import SnapKit

protocol LocationViewControllerDelegate: AnyObject {
    func locationSelectedRowAt(indexPath: Int)
}
class LocationModalViewController: UIViewController {
    weak var delegate: LocationViewControllerDelegate?
    private let currentMode: LocationMode
    //MARK: -- UI Component
    private let allLabel = UILabel().then {
        $0.text = "지역"
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 26)
    }
    private let searchView = UIView().then {
        $0.backgroundColor = UIColor.gray3
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = true
        tableView.register(LocationTableViewCell.self,
                           forCellReuseIdentifier: "modalCell")
        return tableView
    }()
    private let finishButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 15)
        $0.setTitleColor(UIColor.customgray3, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.backgroundColor = UIColor.gray2?.cgColor
    }
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 15)
        $0.setTitleColor(UIColor.customgray3, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.backgroundColor = UIColor.gray2?.cgColor
    }
    init(passMode: LocationMode) {
        self.currentMode = passMode
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20 // 모달 창의 테두리를 둥글게 설정
        view.layer.masksToBounds = true
                
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = view.bounds.height / 15
    }
    
    

}
//MARK: -- 지역 UITableViewDelegate,UITableViewDataSource

extension LocationModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "modalCell",
                                                       for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: .none)
        }
        let mode = LocationMode.allCases[indexPath.row]
        // 이미지를 설정하여 셀에 전달
        cell.setup(label: mode.title)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        delegate?.locationSelectedRowAt(indexPath: indexPath.row)
        //dismissView()
    }
    
}
extension LocationModalViewController {
    private func setupViews() {
        addSubviews()
        setupTableView()
        configUI()
    }
    func addSubviews() {
        view.addSubview(allLabel)
        view.addSubview(searchView)
        view.addSubview(tableView)
//        view.addSubview(finishButton)
//        view.addSubview(nextButton)
    }
    func configUI() {
        allLabel.snp.makeConstraints {
        $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        $0.leading.equalToSuperview().inset(20)
        $0.height.equalTo(35)
            
        }
        searchView.snp.makeConstraints {
            $0.top.equalTo(allLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(51)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
       
    }
}
