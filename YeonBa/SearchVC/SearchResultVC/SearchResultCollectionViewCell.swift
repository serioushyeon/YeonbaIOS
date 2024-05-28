//
//  SearchResultCollectionViewCell.swift
//  YeonBa
//
//  Created by 김민솔 on 4/1/24.
//

import UIKit
import Then
import SnapKit
import Charts

class SearchResultCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "searchResultCell"
    var nc : UINavigationController?
    var id : String = "1"
    var isFavorite = false
    //MARK: -- UI Component
    private let cupidImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private let favoriteBtn = UIButton().then {
        $0.setImage(UIImage(named: "WhiteFavorites"), for: .normal)
        $0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private let pieChartView = PieChartView() //유사도
    private let similarityLabel = UILabel().then {
        $0.text = "80%"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 19.1)
    }
    private let nameLabel = UILabel().then {
        $0.text = "쥬하"
        $0.textAlignment = .center
        $0.font = .pretendardSemiBold(size: 26)
        $0.textColor = .white
    }
    private let ageLabel = UILabel().then {
        $0.text = "22"
        $0.textAlignment = .center
        $0.font = .pretendardSemiBold(size: 20)
        $0.textColor = .white
    }
    private let heartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "Homeheart")
    }
    private let heartLabel = UILabel().then {
        $0.text = "231"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardRegular(size: 13)
    }
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    private let watchProfileBtn = UIButton().then {
        $0.setTitle("프로필 보기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.masksToBounds = true
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(tappedBtn), for: .touchUpInside)
    }
    private var sendChatBtn = ActualGradientButton().then {
        $0.setTitle("채팅 보내기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(apiSendChatRequest), for: .touchUpInside)
    }
    private var sendChatDoneBtn = UIButton().then {
        $0.setTitle("채팅 요청 완료", for: .normal)
        $0.setTitleColor(UIColor.customgray4, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.masksToBounds = true
        $0.layer.backgroundColor = UIColor.customgray2?.cgColor
        $0.layer.cornerRadius = 25
        $0.isEnabled = false
        $0.isHidden = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadImage()
        addSubview()
        configUI()
        setupPieChart()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubview() {
        contentView.addSubviews(cupidImageView,favoriteBtn,similarityLabel,pieChartView,nameLabel,ageLabel,heartImage,heartLabel,horizontalStackView)
        horizontalStackView.addArrangedSubview(watchProfileBtn)
        horizontalStackView.addArrangedSubview(sendChatBtn)
        horizontalStackView.addArrangedSubview(sendChatDoneBtn)
        
    }
    private func configUI() {
        cupidImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        favoriteBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        similarityLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(36)
            $0.top.equalToSuperview().inset(53)
        }
        pieChartView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(113)
            $0.width.equalTo(113)
        }
        horizontalStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.top.equalTo(pieChartView.snp.bottom).offset(120)
            
        }
        ageLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(10)
            $0.bottom.equalTo(nameLabel.snp.bottom)
        }
        heartImage.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        heartLabel.snp.makeConstraints {
            $0.leading.equalTo(heartImage.snp.trailing).offset(10)
            $0.top.equalTo(heartImage.snp.top)
        }
    }
    func setupPieChart(pieValue: Int) {
        let entries = [PieChartDataEntry(value: Double(pieValue)), PieChartDataEntry(value: Double(100-pieValue))]

        let dataSet = PieChartDataSet(entries: entries)
        if let customPinkColor = UIColor.primary {
            let otherColor = UIColor.white
            dataSet.colors = [customPinkColor, otherColor]
        }
        dataSet.drawValuesEnabled = false
        dataSet.drawIconsEnabled = false
        let data = PieChartData(dataSet: dataSet)
        
        pieChartView.holeRadiusPercent = 0.8
        pieChartView.holeColor = UIColor.clear // 배경색을 투명하게 설정
        
        pieChartView.data = data
        pieChartView.legend.enabled = false
    }
    func apiBookmark(id : String){
        let bookmarkRequest = BookmarkRequest.init(id: id )
        NetworkService.shared.otherProfileService.bookmark(bodyDTO: bookmarkRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                print("북마크 성공")
            default:
                print("북마크 실패")
                
            }
        }
    }
    func apiDeleteBookmark(id : String){
        let bookmarkRequest = BookmarkRequest.init(id: id )
        NetworkService.shared.otherProfileService.deleteBookmark(bodyDTO: bookmarkRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                print("북마크 성공")
            default:
                print("북마크 실패")
                
            }
        }
    }
    @objc func apiSendChatRequest(){
        let sendChatRequest = SendChatRequest.init(id: id)
        NetworkService.shared.otherProfileService.sendChat(bodyDTO: sendChatRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                print("채팅 요청 성공")
                self.sendChatBtn.isHidden = true
                self.sendChatDoneBtn.isHidden = false
            default:
                print("채팅 요청 실패")
                
            }
        }
    }
    @objc func favoriteButtonTapped() {
        if let currentImage = favoriteBtn.imageView?.image {
            if(currentImage == UIImage(named: "PinkFavorites")){
                let newImage = UIImage(named: "WhiteFavorites")
                favoriteBtn.setImage(newImage, for: .normal)
                apiDeleteBookmark(id: id)
            }
            else {
                let newImage = UIImage(named: "PinkFavorites")
                favoriteBtn.setImage(newImage, for: .normal)
                apiBookmark(id: id)
            }
        }
    }
    func configure(with model: SearchUsers) {
        nameLabel.text = model.nickname
        heartLabel.text = "\(model.receivedArrows)"
        similarityLabel.text = "\(model.photoSyncRate)%"
        setupPieChart(pieValue: model.photoSyncRate)
        id = "\(model.id)"
        isFavorite = model.isFavorite
        let whiteImage = UIImage(named: "WhiteFavorites")
        let pinkImage = UIImage(named: "PinkFavorites")
        isFavorite ? favoriteBtn.setImage(pinkImage, for: .normal) : favoriteBtn.setImage(whiteImage, for: .normal)
        //나이
        ageLabel.text = "\(model.age)"
        // 이미지 로딩
        var profilePhotoUrl = model.profilePhotoUrl           
        if let url = URL(string: Config.s3URLPrefix + profilePhotoUrl) {
            print("Loading image from URL: \(url)")
            cupidImageView.kf.setImage(with: url)
        }else {
            print("Invalid URL: \(Config.s3URLPrefix + profilePhotoUrl)")
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 터치된 지점이 버튼의 영역 안에 있는지 확인
        let buttonPoint = convert(point, to: favoriteBtn)
        if favoriteBtn.bounds.contains(buttonPoint) {
            // 버튼의 영역 안이면 버튼을 반환하여 버튼의 터치 이벤트만 처리하도록 함
            return favoriteBtn
        }
        // 버튼의 영역 밖이면 기존 동작을 유지하도록 함
        return super.hitTest(point, with: event)
    }
    
    private func loadImage() {
        guard let url = URL(string:"https://static.news.zumst.com/images/58/2023/10/23/0cb287d9a1e2447ea120fc5f3b0fcc11.jpg") else { return }
        cupidImageView.kf.setImage(with: url)
    }
    private func setupPieChart() {
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
    
    @objc func tappedBtn() {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.id = "\(id)"
        otherProfileVC.isFavorite = isFavorite
        nc!.pushViewController(otherProfileVC, animated: true)
    }
    
}
