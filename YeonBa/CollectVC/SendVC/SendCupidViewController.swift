//
//  SendCupidViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/10/24.
//

import UIKit
import Then
import SnapKit
import Alamofire

class SendCupidViewController: UIViewController, APIReloadable {
    private var colletModel: [UserProfileResponse] = []
    private var currentPage: Int = 0
    private var totalPage: Int = 1
    private var isLoading: Bool = false

    func reloadData() {
        currentPage = 0
        totalPage = 1
        colletModel.removeAll()
        apiSentList(page: currentPage)
    }

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
    private lazy var collectionView: UICollectionView = {
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
    private let loadingIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }

    func apiSentList(page: Int) {
        guard !isLoading && page < totalPage else {
            if page >= totalPage {
                print("Reached the last page.")
            }
            return
        }
        isLoading = true
        loadingIndicator.startAnimating()

        let userListRequest = UserListRequest(type: "ARROW_RECEIVERS", page: page)
        NetworkService.shared.otherProfileService.userList(bodyDTO: userListRequest) { [weak self] response in
            guard let self = self else { return }
            self.isLoading = false
            self.loadingIndicator.stopAnimating()

            switch response {
            case .success(let data):
                guard let data = data.data else { return }
                if data.users.isEmpty {
                    if self.currentPage == 0 {
                        self.addEmptySubviews()
                        self.configEmptyUI()
                    }
                } else {
                    self.colletModel.append(contentsOf: data.users)
                    self.totalPage = data.totalPage
                    self.addSubviews()
                    self.configUI()
                    self.initialize()
                    self.totalPage = data.totalPage// Ensure totalPages is set correctly
                    self.currentPage += 1
                    self.collectionView.reloadData()
                }
            default:
                print("프로필 조회 실패")
                if self.currentPage == 0 {
                    self.addEmptySubviews()
                    self.configEmptyUI()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func initialize() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SendCupidCollectionViewCell.self, forCellWithReuseIdentifier: "SendCupidCell")
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func addEmptySubviews() {
        view.addSubview(bodyStackView)
        [heartImage, contentLabel].forEach(bodyStackView.addArrangedSubview(_:))
    }

    func configEmptyUI() {
        bodyStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }

    func addSubviews() {
        view.addSubview(collectionView)
    }

    func configUI() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }
}

extension SendCupidViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colletModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendCupidCell", for: indexPath) as? SendCupidCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = colletModel[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension SendCupidViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.id = "\(colletModel[indexPath.row].id)"
        otherProfileVC.isFavorite = colletModel[indexPath.row].isFavorite
        self.navigationController?.pushViewController(otherProfileVC, animated: true)
    }
}

extension SendCupidViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let width = (collectionView.bounds.width - 8 - 8 - spacing) / 2
        let height = (collectionView.bounds.height - 60 - spacing * 2) / 3
        return CGSize(width: width, height: height)
    }
}

extension SendCupidViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            apiSentList(page: currentPage)
        }
    }
}
