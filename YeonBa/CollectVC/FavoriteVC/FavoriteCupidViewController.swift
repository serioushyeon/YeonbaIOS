//
//  FavoriteCupidViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/10/24.
//

import UIKit
import Then
import SnapKit
class FavoriteCupidViewController: UIViewController {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configUI()
        initialize()
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
  
}
extension FavoriteCupidViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 셀을 dequeue 하고, SendCupidCollectionViewCell 타입으로 타입 캐스팅합니다.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCollectionViewCell else {
            // 캐스팅에 실패하면 기본 UICollectionViewCell을 반환합니다.
            return UICollectionViewCell()
        }
        return cell
    }

    
}

extension FavoriteCupidViewController : UICollectionViewDelegate {
    //셀 클릭 시 이동
    func collectionView(_ collectionview: UICollectionView, didSelectItemAt indexPath : IndexPath) {
        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
}
extension FavoriteCupidViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 170, height: 200)
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 9
        }
}
