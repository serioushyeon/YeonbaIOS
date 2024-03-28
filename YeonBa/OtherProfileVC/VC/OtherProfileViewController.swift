//
//  OtherProfileViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/27/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import Charts

class OtherProfileViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    //var aboutProfile: [OtherProfile] = defaultAbout
    private let cupidImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let pieChartView = PieChartView() //유사도
    private let similarityLabel = UILabel().then {
        $0.text = "80%"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 19.1)
    }
    private let declareBtn = UIButton().then {
        $0.setImage(UIImage(named: "Declaration"), for: .normal)
        $0.addTarget(self, action: #selector(declarButtonTapped), for: .touchUpInside)
    }
    private let favoriteBtn = UIButton().then {
        $0.setImage(UIImage(named: "PinkFavorites"), for: .normal)
    }
    
    private let heartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "profileheart")
    }
    private let heartLabel = UILabel().then {
        $0.text = "231"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardRegular(size: 13)
    }
    private let nameLabel = UILabel().then {
        $0.text = "쥬하"
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 24)

    }
    private let totalLabel = UILabel().then {
        $0.text = "Total"
        $0.font = UIFont.pretendardSemiBold(size: 16)
        $0.textAlignment = .center
    }
    
    private let barView = UIView().then {
        $0.backgroundColor = .gray3
    }
    //aboutme 컬렉션 뷰
    private lazy var aboutmeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.0 // <- 셀 간격 설정
        layout.minimumInteritemSpacing = 0.5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let aboutLabel = UILabel().then {
        $0.text = "About Me"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let barView2 = UIView().then {
        $0.backgroundColor = .gray3
    }
    private let preferenceLabel = UILabel().then {
        $0.text = "Preference"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    //선호도 컬렉션 뷰
    private lazy var preferenceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.0 // <- 셀 간격 설정
        layout.minimumInteritemSpacing = 0.5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    private let sendBtn = UIButton().then {
        $0.setTitle("화살 보내기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
    }
    private let sendChatBtn = ActualGradientButton().then {
        $0.setTitle("채팅 보내기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    // MARK: - 탭바제거
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 커스텀 탭바를 숨깁니다.
        if let tabBarController = self.tabBarController as? tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 다른 화면으로 넘어갈 때 커스텀 탭바를 다시 보이게 합니다.
        if let tabBarController = self.tabBarController as? tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPieChart()
        addSubviews()
        configUI()
        loadImage()
        configureCollectionView()
        navigationController()
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        view.backgroundColor = .white
    }
    func navigationController() {
        let backbutton = UIBarButtonItem(image: UIImage(named: "back2"), style: .plain, target: self, action: #selector(back(_:)))
        navigationItem.leftBarButtonItem = backbutton
    }
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cupidImageView)
        [declareBtn,similarityLabel,pieChartView,favoriteBtn].forEach {
            cupidImageView.addSubview($0)
        }
        [nameLabel, totalLabel, heartImage, heartLabel, barView, aboutLabel, aboutmeCollectionView].forEach {
            contentView.addSubview($0)
        }
        [barView2,preferenceLabel,preferenceCollectionView].forEach {
            contentView.addSubview($0)
        }
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(sendBtn)
        horizontalStackView.addArrangedSubview(sendChatBtn)
        
    }
    func configureCollectionView() {
        
        aboutmeCollectionView.dataSource = self
        aboutmeCollectionView.delegate = self
        aboutmeCollectionView.register(OtherProfileCollectionViewCell.self, forCellWithReuseIdentifier: OtherProfileCollectionViewCell.reuseIdentifier)
        preferenceCollectionView.dataSource = self
        preferenceCollectionView.delegate = self
        preferenceCollectionView.register(PreferenceCollectionViewCell.self, forCellWithReuseIdentifier: PreferenceCollectionViewCell.reuseIdentifier)
    }
    func configUI() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-55)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(800)
        }
        cupidImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
        }
        declareBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(40)
        }
        similarityLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(45)
            $0.height.equalTo(50)
        }
        pieChartView.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
            $0.height.equalTo(120)
            $0.width.equalTo(120)
        }
        favoriteBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(cupidImageView.snp.bottom).offset(20)
            $0.bottom.equalTo(totalLabel.snp.bottom)
        }
        totalLabel.snp.makeConstraints {
            $0.trailing.equalTo(heartImage.snp.leading).offset(-7)
            $0.top.equalTo(cupidImageView.snp.bottom).offset(30)
        }
        heartImage.snp.makeConstraints {
            $0.trailing.equalTo(heartLabel.snp.leading).offset(-5)
            $0.bottom.equalTo(totalLabel.snp.bottom)
        }
        barView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        aboutLabel.snp.makeConstraints {
            $0.top.equalTo(barView.snp.bottom).offset(20)
            $0.leading.equalTo(nameLabel.snp.leading)
        }
        heartLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(heartImage.snp.bottom)
        }
        aboutmeCollectionView.snp.makeConstraints {
            $0.leading.equalTo(aboutLabel.snp.leading)
            $0.top.equalTo(aboutLabel.snp.bottom).offset(10)
            $0.height.equalTo(150)
            $0.width.equalTo(160)
        }
        barView2.snp.makeConstraints {
            $0.top.equalTo(aboutLabel.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        horizontalStackView.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        preferenceLabel.snp.makeConstraints {
            $0.top.equalTo(barView2.snp.bottom).offset(20)
            $0.leading.equalTo(nameLabel.snp.leading)
        }
        preferenceCollectionView.snp.makeConstraints {
            $0.leading.equalTo(preferenceLabel.snp.leading)
            $0.top.equalTo(preferenceLabel.snp.bottom).offset(10)
            $0.height.equalTo(150)
            $0.width.equalTo(160)
        }
    }
    func setupPieChart() {
        let entries = [PieChartDataEntry(value: 90), PieChartDataEntry(value: 10)]

        let dataSet = PieChartDataSet(entries: entries)
        if let customPinkColor = UIColor.primary {
            let otherColor = UIColor.white
            dataSet.colors = [customPinkColor, otherColor]
        }
        dataSet.drawValuesEnabled = false
        dataSet.drawIconsEnabled = false
        let data = PieChartData(dataSet: dataSet)
        
        pieChartView.holeRadiusPercent = 0.9
        pieChartView.holeColor = UIColor.clear // 배경색을 투명하게 설정
        
        pieChartView.data = data
        pieChartView.legend.enabled = false
    }
    private func loadImage() {
        guard let url = URL(string:"https://static.news.zumst.com/images/58/2023/10/23/0cb287d9a1e2447ea120fc5f3b0fcc11.jpg") else { return }
        cupidImageView.kf.setImage(with: url)
    }
    @objc func declarButtonTapped() {
        
    }
    //뒤로가기
    @objc func back(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
        print("back click")
     }
}
extension OtherProfileViewController: UICollectionViewDelegate {
    
}
extension OtherProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == aboutmeCollectionView {
            return 5
        } else if collectionView == preferenceCollectionView {
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == aboutmeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherProfileCollectionViewCell.reuseIdentifier, for: indexPath) as? OtherProfileCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            return cell
        } else if collectionView == preferenceCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreferenceCollectionViewCell.reuseIdentifier, for: indexPath) as? PreferenceCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
extension OtherProfileViewController: UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(width: 50, height: 35)
        }
        
    }
    
