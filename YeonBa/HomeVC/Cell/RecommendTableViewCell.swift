//
//  RecommendTableViewCell.swift
//  YeonBa
//
//  Created by 김민솔 on 3/27/24.
//

import UIKit
import Then
import SnapKit
import Charts
import Kingfisher

class RecommendTableViewCell: UITableViewCell {
    static let identifier = "RecommendTableViewCell"
    private let pieChartView = PieChartView() //유사도
    private let myImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    private let myNameLabel = UILabel().then {
        $0.text = "윤정스"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    private let myAgeLabel = UILabel().then {
        $0.text = "27"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 16)
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
    private let favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: "Favorites"), for: .normal)
    }
    private let animalButton = UIButton().then {
        $0.setTitle("강아지 상", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.setTitleColor(.black, for: .normal)
    }
    private let voiceButton = UIButton().then {
        $0.setTitle("저음", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.setTitleColor(.black, for: .normal)
    }
    private let similarityLabel = UILabel().then {
        $0.text = "90%"
        $0.textColor = UIColor.primary
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 13.1)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadImage()
        setupPieChart()
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.addSubview(myImageView)
        myImageView.addSubview(similarityLabel)
        myImageView.addSubview(pieChartView)
        contentView.addSubview(myNameLabel)
        contentView.addSubview(myAgeLabel)
        contentView.addSubview(heartImage)
        contentView.addSubview(heartLabel)
        contentView.addSubview(animalButton)
        contentView.addSubview(voiceButton)
        contentView.addSubview(favoriteButton)
        
        myImageView.snp.makeConstraints {
            $0.width.equalTo(142)
            $0.height.equalTo(142)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(10)
        }
        similarityLabel.snp.makeConstraints {
            $0.bottom.equalTo(myImageView.snp.bottom).offset(-25)
            $0.trailing.equalTo(myImageView.snp.trailing).offset(-15)
        }
        pieChartView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(80)
            $0.bottom.equalToSuperview().inset(-5)
            $0.trailing.equalTo(myImageView.snp.trailing).offset(10)
        }
        myNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(15)
            $0.leading.equalTo(myImageView.snp.trailing).offset(15)
        }
        myAgeLabel.snp.makeConstraints {
            $0.leading.equalTo(myNameLabel.snp.trailing).offset(7)
            $0.bottom.equalTo(myNameLabel.snp.bottom)
        }
        heartImage.snp.makeConstraints {
            $0.top.equalTo(myNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(myNameLabel.snp.leading)
        }
        heartLabel.snp.makeConstraints {
            $0.top.equalTo(heartImage.snp.top)
            $0.leading.equalTo(heartImage.snp.trailing).offset(3)
        }
        animalButton.snp.makeConstraints {
            $0.top.equalTo(heartImage.snp.bottom).offset(10)
            $0.leading.equalTo(heartImage.snp.leading)
        }
        voiceButton.snp.makeConstraints {
            $0.top.equalTo(animalButton.snp.bottom).offset(5)
            $0.leading.equalTo(animalButton.snp.leading)
        }
        favoriteButton.snp.makeConstraints {
            $0.width.equalTo(16)
            $0.height.equalTo(20)
            $0.top.equalTo(contentView.snp.top).offset(15)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-15)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    override func prepareForReuse() {
        super.prepareForReuse()
        loadImage()
        setupPieChart()
       }
    //셀 사이 간격 설정 
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
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
        
        pieChartView.holeRadiusPercent = 0.8
        pieChartView.holeColor = UIColor.clear // 배경색을 투명하게 설정
        
        pieChartView.data = data
        pieChartView.legend.enabled = false
    }
    private func loadImage() {
        guard let url = URL(string:"https://newsimg.sedaily.com/2023/09/12/29UNLQFQT6_1.jpg") else { return }
        myImageView.kf.setImage(with: url)
    }

}
