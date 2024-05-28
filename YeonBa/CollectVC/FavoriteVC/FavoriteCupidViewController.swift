//
//  FavoriteCupidViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/10/24.
//

import UIKit
import Then
import SnapKit
import Alamofire
class FavoriteCupidViewController: UIViewController {
    
    var colletModel : [UserProfileResponse]? = [
        UserProfileResponse(id: 1, profilePhotoUrl: "https://static.news.zumst.com/images/58/2023/10/23/0cb287d9a1e2447ea120fc5f3b0fcc11.jpg", nickname: "존잘남", age: 20, receivedArrows: 11, lookAlikeAnimal: "강아지상", photoSyncRate: 80, activityArea: "서울", height: 180, vocalRange: "저음", isFavorite: false )]
    
    // MARK: - UI Components
    private let bodyStackView = UIStackView().then {
      $0.axis = .vertical
      $0.spacing = 24
    }
    private let heartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "Bigheart")
    }
    private let contentLabel = UILabel().then {
        $0.text = "아직 아무도 없어요.\n 마음에 드는 이성을 찾아 보세요!"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
        }
        return collectionView
    }()
    
    func apiFavoriteList() -> Void{
        let userListRequest = UserListRequest.init(type: "FAVORITES", page: 0)
        NetworkService.shared.otherProfileService.userList(bodyDTO: userListRequest) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                if(data.users.isEmpty){
                    self.addEmptySubviews()
                    self.configEmptyUI()
                }
                else{
                    print(data.users)
                    self.colletModel = data.users
                    self.addSubviews()
                    self.configUI()
                    self.initialize()
                    self.collectionview.reloadData()
                }
                
            default:
                print("프로필 조회 실패")
                // 유저 데이터가 없는 경우
                self.addEmptySubviews()
                self.configEmptyUI()

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiFavoriteList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func initialize() {
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteCell")
    }
    func addSubviews() {
        view.addSubview(collectionview)
    }
    func configUI() {
        collectionview.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
    func addEmptySubviews() {
        view.addSubview(bodyStackView)
        [self.heartImage, self.contentLabel]
          .forEach(self.bodyStackView.addArrangedSubview(_:))
    }
    func configEmptyUI() {
        self.bodyStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
}
extension FavoriteCupidViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colletModel?.count ?? 1
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            return UICollectionViewCell()
        }
        // colletModel 배열의 indexPath.row에 해당하는 모델을 가져와서 셀에 전달
        let model = colletModel?[indexPath.row]
        cell.configure(with: model ??  UserProfileResponse(id: 1, profilePhotoUrl: "https://static.news.zumst.com/images/58/2023/10/23/0cb287d9a1e2447ea120fc5f3b0fcc11.jpg", nickname: "존잘남", age: 20, receivedArrows: 11, lookAlikeAnimal: "강아지상", photoSyncRate: 80, activityArea: "서울", height: 180, vocalRange: "저음", isFavorite: false ))
        return cell
    }
}

extension FavoriteCupidViewController : UICollectionViewDelegate {
    //셀 클릭 시 이동
    func collectionView(_ collectionview: UICollectionView, didSelectItemAt indexPath : IndexPath) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.id = "\(colletModel![indexPath.row].id)"
        otherProfileVC.isFavorite = colletModel![indexPath.row].isFavorite
        self.navigationController?.pushViewController(otherProfileVC, animated: true)
    }
}
extension FavoriteCupidViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let width = (collectionView.bounds.width - 8 - 8 - spacing) / 2 // 총 가로길이 - leading - trailing - 간격
        let height = (collectionView.bounds.height - 60 - spacing * 2) / 3 // 총 세로길이 - top - bottom - 간격
        return CGSize(width: width, height: height)
    }
}
