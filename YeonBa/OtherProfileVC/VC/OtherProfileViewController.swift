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
import Alamofire

class OtherProfileViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var viewMode: DeclareMode = .declare
    private var whyviewMode: WhyMode = .maner
    var id : String?
    var isFavorite : Bool = false
    private var userData : UserProfileResponse?
    var images: [UIImage] = []
    private var aboutData = ["25살", "165cm", "서울", "고음", "토끼 상"]
    private var preferenceData = ["강아지 상", "서울", "저음", "20~25세", "마른체형", "INTP"]
    private let cupidImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let pieChartView = PieChartView() //유사도
    private let similarityLabel = UILabel().then {
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
        $0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    private let heartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "profileheart")
    }
    private let heartLabel = UILabel().then {
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardRegular(size: 13)
    }
    private let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.textColor = .black

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

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    private let bottomBarView = UIView().then {
        
        $0.layer.borderColor = UIColor.gray2?.cgColor
        $0.layer.borderWidth = 1
    }
    private let sendBtn = UIButton().then {
        $0.setTitle("화살 보내기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 19
        $0.addTarget(self, action: #selector(arrowBtnTapped), for: .touchUpInside)
        $0.isHidden = false
    }
    private let sendChatBtn = ActualGradientButton().then {
        $0.setTitle("채팅 보내기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 19
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(apiSendChatRequest), for: .touchUpInside)
    }
    private var sendDoneBtn = UIButton().then {
        $0.setTitle("화살 보내기 완료", for: .normal)
        $0.setTitleColor(UIColor.customgray4, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.masksToBounds = true
        $0.layer.backgroundColor = UIColor.customgray2?.cgColor
        $0.layer.cornerRadius = 25
        $0.isEnabled = false
        $0.isHidden = true
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
    //MARK: - 업로드한 사진이 올라가는 스크롤뷰
    lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = UIColor.lightGray // 기본 페이지 색상
        control.currentPageIndicatorTintColor = UIColor.primary // 현재 페이지 색상
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    lazy var profileScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK: - 탭바제거
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    //MARK: -- UI
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPieChart(pieValue: 80)
        addSubviews()
        configUI()
        configureCollectionView()
        apiOtherProfile()
        addContentScrollView()
        setPageControl()
        tabBarController?.tabBar.isTranslucent = true
        scrollView.delegate = self

        view.backgroundColor = .white
    }
    private func setPageControl() {
        pageControl.numberOfPages = images.count
        
    }
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
//        contentView.addSubview(cupidImageView)
        contentView.addSubviews(profileScrollView,pageControl)
//        [similarityLabel,pieChartView].forEach {
//            cupidImageView.addSubview($0)
//        }
        contentView.addSubview(declareBtn)
        contentView.addSubview(favoriteBtn)
        [nameLabel, totalLabel, heartImage, heartLabel, barView, aboutLabel, aboutmeCollectionView].forEach {
            contentView.addSubview($0)
        }
        [barView2,preferenceLabel,preferenceCollectionView].forEach {
            contentView.addSubview($0)
        }
        view.addSubview(bottomBarView)
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(sendBtn)
        horizontalStackView.addArrangedSubview(sendDoneBtn)
        horizontalStackView.addArrangedSubview(sendChatBtn)
        horizontalStackView.addArrangedSubview(sendChatDoneBtn)
        
        
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-65)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(800)
        }
        profileScrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
            $0.top.equalTo(contentView.snp.top)
        }
        pageControl.snp.makeConstraints {
            $0.top.equalTo(profileScrollView.snp.bottom).offset(-20)
            $0.centerX.equalTo(profileScrollView.snp.centerX)
            $0.height.equalTo(10)
        }
//        cupidImageView.snp.makeConstraints {
//            $0.top.equalTo(contentView.snp.top)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.5)
//        }
        declareBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(40)
        }

        favoriteBtn.snp.makeConstraints {
            $0.top.equalTo(declareBtn.snp.bottom).offset(255)
            $0.trailing.equalToSuperview().inset(20)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(pageControl.snp.bottom).offset(20)
            $0.bottom.equalTo(totalLabel.snp.bottom)
        }
        totalLabel.snp.makeConstraints {
            $0.trailing.equalTo(heartImage.snp.leading).offset(-7)
            $0.top.equalTo(pageControl.snp.bottom).offset(30)
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
        bottomBarView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(horizontalStackView.snp.top).offset(-10)
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
            $0.width.equalTo(180)
        }
    }

    func setupPieChart(pieValue: Double) {
        let entries = [PieChartDataEntry(value: pieValue), PieChartDataEntry(value: 100-pieValue)]

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
    func apiReport(){
        let reportRequest = ReportRequest.init(id: id!, category: "\(String(describing: whyviewMode.title))", reason: "")
        NetworkService.shared.otherProfileService.report(bodyDTO: reportRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                print("신고 성공")
            default:
                print("신고 실패")
                
            }
        }
    }
    func apiBlock() -> Void{
        let blockRequest = BlockRequest.init(id: id!)
        NetworkService.shared.otherProfileService.block(bodyDTO: blockRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                print("차단 성공")
            default:
                print("차단 실패")
                
            }
        }
    }
    func apiSendArrow(){
        let sendArrowRequest = SendArrowRequest.init(id: id!)
        NetworkService.shared.otherProfileService.sendArrow(bodyDTO: sendArrowRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                print("화살 보내기 성공")
                self.sendBtn.isHidden = true
                self.sendDoneBtn.isHidden = false
            default:
                print("화살 보내기 실패")
                
            }
        }
    }
    @objc func apiSendChatRequest(){
        let sendChatRequest = SendChatRequest.init(id: id!)
        NetworkService.shared.otherProfileService.sendChat(bodyDTO: sendChatRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                print("채팅 요청 성공")
                self.sendChatBtn.isHidden = true
                self.sendChatDoneBtn.isHidden = false
            default:
                print("채팅 요청 실패")
                
            }
        }
    }
    func apiOtherProfile() {
        let otherProfileRequest = OtherProfileRequest.init(id: id!)
        NetworkService.shared.otherProfileService.getOtherProfile(bodyDTO: otherProfileRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                print("조회 성공")
                self.configure(data: data)
                self.aboutmeCollectionView.reloadData()
                self.aboutmeCollectionView.setNeedsLayout()
                self.aboutmeCollectionView.layoutIfNeeded()
                self.preferenceCollectionView.reloadData()
                self.preferenceCollectionView.setNeedsLayout()
                self.preferenceCollectionView.layoutIfNeeded()
            default:
                print("프로필 조회 실패")

            }
        }
    }
    
    func apiBookmark(id : String){
        let bookmarkRequest = BookmarkRequest.init(id: id )
        NetworkService.shared.otherProfileService.bookmark(bodyDTO: bookmarkRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
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
                print("북마크 성공")
            default:
                print("북마크 실패")
                
            }
        }
    }
    //MARK: - PageControl 스크롤뷰 메서드
    private func addContentScrollView() {
        profileScrollView.isPagingEnabled = true // 페이지별 스크롤 가능하도록 설정
        
        for i in 0..<images.count {
            let imageView = UIImageView()
            let xPos = profileScrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: profileScrollView.bounds.width, height: profileScrollView.bounds.height)
            imageView.image = images[i]
            imageView.contentMode = .scaleAspectFit
            profileScrollView.addSubview(imageView)
            
            if i == 0 { // 첫 번째 이미지에만 추가
                imageView.addSubview(similarityLabel)
                imageView.addSubview(pieChartView)
                
                similarityLabel.snp.makeConstraints {
                    $0.leading.equalToSuperview().inset(40)
                    $0.bottom.equalToSuperview().inset(45)
                    $0.height.equalTo(50)
                }
                pieChartView.snp.makeConstraints {
                    $0.bottom.equalToSuperview().inset(10)
                    $0.leading.equalToSuperview()
                    $0.height.equalTo(120)
                    $0.width.equalTo(120)
                }
            }
        }
        profileScrollView.contentSize = CGSize(width: profileScrollView.frame.width * CGFloat(images.count), height: profileScrollView.frame.height)
    }
    
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        setPageControlSelectedPage(currentPage: pageIndex)
    }
    func updateUIWithImages() {
        // 이미지를 받아올 때마다 UIScrollView를 초기화합니다.
        profileScrollView.subviews.forEach { $0.removeFromSuperview() }
        
        // 서버에서 받아온 이미지를 UIScrollView에 추가하여 화면에 표시합니다.
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            let xPos = CGFloat(index) * profileScrollView.bounds.width
            imageView.frame = CGRect(x: xPos, y: 0, width: profileScrollView.bounds.width, height: profileScrollView.bounds.height)
            profileScrollView.addSubview(imageView)
            
            if index == 0 { // 첫 번째 이미지에만 추가
                imageView.addSubview(similarityLabel)
                imageView.addSubview(pieChartView)
                
                similarityLabel.snp.makeConstraints {
                    $0.leading.equalToSuperview().inset(40)
                    $0.bottom.equalToSuperview().inset(45)
                    $0.height.equalTo(50)
                }
                pieChartView.snp.makeConstraints {
                    $0.bottom.equalToSuperview().inset(10)
                    $0.leading.equalToSuperview()
                    $0.height.equalTo(120)
                    $0.width.equalTo(120)
                }
            }
        }
        profileScrollView.contentSize = CGSize(width: profileScrollView.bounds.width * CGFloat(images.count), height: profileScrollView.bounds.height)
        
        // 페이지 컨트롤을 업데이트합니다.
        pageControl.numberOfPages = images.count
    }
    func configure(data : OtherProfileResponse) {
        setupPieChart(pieValue: Double(data.photoSyncRate))
        self.nameLabel.text = data.nickname
        self.heartLabel.text = "\(data.arrows)"
        self.similarityLabel.text = "\(data.photoSyncRate)%"
        self.aboutData = ["\(data.age)살", "\(data.height)cm", data.activityArea, data.vocalRange, data.lookAlikeAnimalName]
        if(data.preferredAgeLowerBound != nil && data.preferredAgeUpperBound != nil){
            self.preferenceData = [data.lookAlikeAnimalName,
                                   data.activityArea,
                                   data.vocalRange,
                                   "\(data.preferredAgeLowerBound!)~\(data.preferredAgeUpperBound!)살",
                                   data.preferredBodyType,
                                   data.preferredMbti]
            if(data.preferredHeightLowerBound != nil && data.preferredHeightUpperBound != nil){
                self.preferenceData = [data.lookAlikeAnimalName,
                                       data.activityArea,
                                       data.vocalRange,
                                       "\(data.preferredAgeLowerBound!)~\(data.preferredAgeUpperBound!)살",
                                       "\(data.preferredHeightLowerBound!)~\(data.preferredHeightUpperBound!)cm",
                                       data.preferredBodyType,
                                       data.preferredMbti]
            }
            else{
                self.preferenceData = [data.lookAlikeAnimalName,
                                       data.activityArea,
                                       data.vocalRange,
                                       data.preferredBodyType,
                                       data.preferredMbti]
            }
        }
        let whiteImage = UIImage(named: "WhiteFavorites")
        let pinkImage = UIImage(named: "PinkFavorites")
        self.isFavorite ? self.favoriteBtn.setImage(pinkImage, for: .normal) : self.favoriteBtn.setImage(whiteImage, for: .normal)
        if(data.alreadySentArrow){
            self.sendBtn.isHidden = true
            self.sendDoneBtn.isHidden = false
        }
        else{
            self.sendBtn.isHidden = false
            self.sendDoneBtn.isHidden = true
        }
        if(data.canChat){
            self.sendChatBtn.isHidden = false
            self.sendChatDoneBtn.isHidden = true
        }
        else{
            self.sendChatBtn.isHidden = true
            self.sendChatDoneBtn.isHidden = false
        }
        // 이미지 로딩
        loadProfileImages(urls: data.profilePhotosUrls)
    }
    private func loadProfileImages(urls: [String]) {
            images.removeAll()
            
            let group = DispatchGroup()
            
            for urlString in urls {
                var fullUrlString = urlString
                if let url = URL(string: Config.s3URLPrefix + fullUrlString) {
                    group.enter()
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        switch result {
                        case .success(let value):
                            self.images.append(value.image)
                        case .failure(let error):
                            print("Error loading image: \(error)")
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.updateUIWithImages()
            }
        }
//MARK: -- Action
    @objc func declarButtonTapped() {
        print("declare")
        let declareVC = ModeSelectViewController(passMode: viewMode)
        declareVC.delegate = self
        self.present(declareVC, animated: true)
    }
    @objc func favoriteButtonTapped() {
        if let currentImage = favoriteBtn.imageView?.image {
            if(currentImage == UIImage(named: "PinkFavorites")){
                let newImage = UIImage(named: "WhiteFavorites")
                favoriteBtn.setImage(newImage, for: .normal)
                apiDeleteBookmark(id: id!)
            }
            else {
                let newImage = UIImage(named: "PinkFavorites")
                favoriteBtn.setImage(newImage, for: .normal)
                apiBookmark(id: id!)
            }
        }
    }
    //뒤로가기
    @objc func back(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
        print("back click")
     }
    @objc func arrowBtnTapped() {
        apiSendArrow()
    }
    @objc func chatBtnTapped() {
        apiSendChatRequest()
    }
}
//MARK: -- OtherProfileViewController UICollectionViewDelegate,UICollectionViewDataSource
extension OtherProfileViewController: UICollectionViewDelegate {
    
}
extension OtherProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == aboutmeCollectionView {
            return aboutData.count
        } else if collectionView == preferenceCollectionView {
            return preferenceData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == aboutmeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherProfileCollectionViewCell.reuseIdentifier, for: indexPath) as? OtherProfileCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            cell.configure(with: aboutData[indexPath.row])
            return cell
        } else if collectionView == preferenceCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreferenceCollectionViewCell.reuseIdentifier, for: indexPath) as? PreferenceCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: preferenceData[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
extension OtherProfileViewController: UICollectionViewDelegateFlowLayout {
    // 셀의 크기를 설정합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == aboutmeCollectionView {
            let text = aboutData[indexPath.row]
            let cell = OtherProfileCollectionViewCell()
            cell.configure(with: text)
            cell.layoutIfNeeded()
            let size = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: size.width, height: 35)
        } else if collectionView == preferenceCollectionView {
            let text = preferenceData[indexPath.row]
            let cell = PreferenceCollectionViewCell()
            cell.configure(with: text)
            cell.layoutIfNeeded()
            let size = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return CGSize(width: size.width, height: 35)
        }
        return CGSize(width: 50, height: 35)
    }
    
    // 행 간격을 설정합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0 // 원하는 간격으로 설정합니다.
    }
    
    // 항목 간격을 설정합니다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5 // 원하는 간격으로 설정합니다.
    }
}

// MARK: ModalView Delegate
extension OtherProfileViewController: ModeSelectViewControllerDelegate {
    func didSelectedRowAt(indexPath: Int) {
        guard let mode = DeclareMode(rawValue: indexPath) else { return }
        
        viewMode = mode
        
        
        switch viewMode {
        case .declare:
            // 새로운 모달 창을 표시하기 위한 뷰 컨트롤러 생성
            dismiss(animated: true) {
                let whydeclareVC = WhyDeclareViewController(passMode: self.whyviewMode)
                whydeclareVC.delegate = self
                // 새로운 모달 창 표시
                self.present(whydeclareVC, animated: true)
            }
            print("daily")
        case .cut:
            print("weekly")
            apiBlock()
           
        }
    }
}

extension OtherProfileViewController: WhyDeclareViewControllerDelegate {
    func whydidSelectedRowAt(indexPath: Int) {
        guard let mode = WhyMode(rawValue: indexPath) else { return }
        
        whyviewMode = mode
        apiReport()
    }
}

    
