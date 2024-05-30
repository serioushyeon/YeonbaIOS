//
//  SearchResultViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 4/1/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import Charts

class SearchResultViewController: UIViewController {
    private var preferLocation: String
    private var preferVoice: String
    private let ageRange: String
    private let heightRange: String
    private let ageLowerBound: Int
    private let ageUpperBound: Int
    private let heightLowerBound: Int
    private let heightUpperBound: Int
    private let includePreferredAnimal : Bool
    private var currentPage: Int = 0
    private var totalPage: Int = 1 // 초기값 1로 설정
    init(preferLocation: String, preferVoice: String, ageRange: String, heightRange: String, ageLowerBound: Int, ageUpperBound: Int, heightLowerBound: Int, heightUpperBound: Int, includePreferredAnimal : Bool, totalPage : Int) {
        self.preferLocation = preferLocation
        self.preferVoice = preferVoice
        if(preferLocation.isEmpty){
            self.preferLocation = "전체"
        }
        if(preferVoice.isEmpty){
            self.preferVoice = "전체"
        }
        self.ageRange = ageRange
        self.heightRange = heightRange
        self.ageLowerBound = ageLowerBound
        self.ageUpperBound = ageUpperBound
        self.heightLowerBound = heightLowerBound
        self.heightUpperBound = heightUpperBound
        self.includePreferredAnimal = includePreferredAnimal
        self.totalPage = totalPage
        super.init(nibName: nil, bundle: nil)
    }
    var colletModel : [SearchUsers]? = [
        SearchUsers(id: 1, profilePhotoUrl: "https://static.news.zumst.com/images/58/2023/10/23/0cb287d9a1e2447ea120fc5f3b0fcc11.jpg", nickname: "존잘남", age: 20, receivedArrows: 11, lookAlikeAnimal: "강아지상", photoSyncRate: 80, activityArea: "서울", height: 180, vocalRange: "저음", isFavorite: false )]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: -- UI Component
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 5.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let resetBtn = UIButton().then{
        $0.setImage(UIImage(named: "Reset"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .center
        $0.contentVerticalAlignment = .center
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
    }
    private let barView = UIView().then {
        $0.backgroundColor = .gray3
    }
    private let cupidImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var resultImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 0.5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureCollectionView()
        addSubviews()
        configUI()
        
    }
    func addSubviews() {
        view.addSubview(categoryCollectionView)
        view.addSubview(resetBtn)
        view.addSubview(barView)
        view.addSubview(resultImageCollectionView)
    }
    func configUI() {
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(resetBtn.snp.leading).offset(-5)
            $0.height.equalTo(40)
        }
                
        resetBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(20)
            make.height.width.equalTo(35)
        }
        barView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        resultImageCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(barView.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    func configureCollectionView() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        
        resultImageCollectionView.dataSource = self
        resultImageCollectionView.delegate = self
        resultImageCollectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.reuseIdentifier)
    }
    @objc func resetBtnTapped(_ sender: Any) {
        currentPage += 1
        guard currentPage <= totalPage else { return }
        let searchUserRequest = SearchUserRequest(
            page: currentPage,
            area: preferLocation,
            vocalRange: preferVoice,
            ageLowerBound: ageLowerBound,
            ageUpperBound: ageUpperBound,
            heightLowerBound: heightLowerBound,
            heightUpperBound: heightUpperBound,
            includePreferredAnimal: includePreferredAnimal
        )
        print(searchUserRequest)
        NetworkService.shared.searchService.searchUser(bodyDTO: searchUserRequest) { [self] response in
            switch response {
            case .success(let data):
                print("유저 검색 성공")
                guard let data = data.data else { return }
                self.colletModel = data.users // API 응답에 맞게 수정
                self.totalPage = data.totalPage
                self.resultImageCollectionView.reloadData()
            default:
                print("유저 검색 실패")
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    
}
extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return 4
        } else if collectionView == resultImageCollectionView {
            return colletModel?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == categoryCollectionView {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else {
                    return UICollectionViewCell()
                }
                // Configure cell with search parameters
                switch indexPath.row {
                case 0:
                    cell.configure(with: preferLocation)
                case 1:
                    cell.configure(with: preferVoice)
                case 2:
                    cell.configure(with: ageRange)
                case 3:
                    cell.configure(with: heightRange)
                   
                    
                default:
                    break
                }
                return cell
            } else if collectionView == resultImageCollectionView {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchResultCollectionViewCell else {
                    return UICollectionViewCell()
                }
                // colletModel 배열의 indexPath.row에 해당하는 모델을 가져와서 셀에 전달
                let model = colletModel?[indexPath.row]
                cell.configure(with: model ??  SearchUsers(id: 1, profilePhotoUrl: "https://static.news.zumst.com/images/58/2023/10/23/0cb287d9a1e2447ea120fc5f3b0fcc11.jpg", nickname: "존잘남", age: 20, receivedArrows: 11, lookAlikeAnimal: "강아지상", photoSyncRate: 80, activityArea: "서울", height: 180, vocalRange: "저음", isFavorite: false ))
                cell.nc = self.navigationController
                return cell
            }
            return UICollectionViewCell()
        }
}
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            var text: String
            switch indexPath.row {
            case 0:
                text = preferLocation
            case 1:
                text = preferVoice
            case 2:
                text = ageRange
            case 3:
                text = heightRange
            default:
                text = ""
            }
            let textWidth = (text as NSString).boundingRect(
                with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 35),
                options: .usesLineFragmentOrigin,
                attributes: [.font: UIFont.systemFont(ofSize: 17)],
                context: nil
            ).width
            return CGSize(width: textWidth + 10, height: 35) // Adding some padding
        } else if collectionView == resultImageCollectionView {
            return CGSize(width: 350, height: 460)
        }
        return CGSize(width: 350, height: 460)
    }
}
