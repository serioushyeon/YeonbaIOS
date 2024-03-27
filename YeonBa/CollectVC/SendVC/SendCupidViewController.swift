//
//  SendCupidViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/10/24.
//

import UIKit
import Then
import SnapKit
class SendCupidViewController: UIViewController {
    private lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            layout.minimumInteritemSpacing = 6
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
    func initialize() {
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(SendCupidCollectionViewCell.self, forCellWithReuseIdentifier: "SendCupidCell")
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
extension SendCupidViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 12
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendCupidCell", for: indexPath) as? SendCupidCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }

    
}

extension SendCupidViewController : UICollectionViewDelegate {
    
}
extension SendCupidViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 6
        let width = (collectionView.bounds.width - 10 - 10 - spacing) / 2 // 총 가로길이 - leading - trailing - 간격
        let height = (collectionView.bounds.height - 60 - spacing * 2) / 3 // 총 세로길이 - top - bottom - 간격
        return CGSize(width: width, height: height)
    }
}
