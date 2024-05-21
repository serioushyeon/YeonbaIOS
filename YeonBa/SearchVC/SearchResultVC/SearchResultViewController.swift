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
    private let preferLocation: String
    private let preferVoice: String
    private let ageRange: String
    private let heightRange: String
    init(preferLocation: String, preferVoice: String, ageRange: String, heightRange: String) {
        self.preferLocation = preferLocation
        self.preferVoice = preferVoice
        self.ageRange = ageRange
        self.heightRange = heightRange
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: -- UI Component
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
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
        view.addSubview(barView)
        view.addSubview(resultImageCollectionView)
    }
    func configUI() {
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
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
    
}

extension SearchResultViewController: UICollectionViewDelegate {
    
}
extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return 4
        } else if collectionView == resultImageCollectionView {
            return 4
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
            return CGSize(width: textWidth + 20, height: 35) // Adding some padding
        } else if collectionView == resultImageCollectionView {
            return CGSize(width: 350, height: 460)
        }
        return CGSize(width: 350, height: 460)
    }
}
