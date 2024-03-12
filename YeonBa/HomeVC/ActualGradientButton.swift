//
//  ActualGradientButton.swift
//  YeonBa
//
//  Created by 김민솔 on 3/6/24.
//

import UIKit

class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.colors = [UIColor.secondary?.cgColor, UIColor.primary?.cgColor]
        l.startPoint = CGPoint(x: 0.5, y: 0)
        l.endPoint = CGPoint(x: 0.5, y: 1)
        l.cornerRadius = 16
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
