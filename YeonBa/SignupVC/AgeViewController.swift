//
//  AgeViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 5/7/24.
//

import UIKit
import SnapKit

class AgeViewController: UIViewController {
  private let slider: JKSlider = {
    let slider = JKSlider()
    slider.minValue = 20
    slider.maxValue = 40
    slider.lower = 20
    slider.upper = 40
    slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    return slider
  }()
  private let label: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    self.view.addSubview(self.slider)
    self.view.addSubview(self.label)
    
    self.slider.snp.makeConstraints {
      $0.height.equalTo(40)
      $0.width.equalTo(300)
      $0.center.equalToSuperview()
    }
    self.label.snp.makeConstraints {
      $0.top.equalToSuperview().inset(80)
      $0.centerX.equalToSuperview()
    }
  }
  
  @objc private func changeValue() {
    self.label.text = "\(Int(self.slider.lower)) ~ \(Int(self.slider.upper))"
  }
}
