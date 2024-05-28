//
//  JKSlider.swift
//  YeonBa
//
//  Created by 김민솔 on 3/13/24.
//

import UIKit
import SnapKit
import Then

protocol JKSliderDelegate: AnyObject {
    func sliderValueChanged(lowerValue: Double, upperValue: Double)
}


final class JKSlider: UIControl {
    weak var delegate: JKSliderDelegate?

    // MARK: Constant
    private enum Constant {
        static let barRatio = 4.0/10.0
    }

    // MARK: UI
    private let lowerThumbButton: ThumbButton = {
        let button = ThumbButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    private let upperThumbButton: ThumbButton = {
        let button = ThumbButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    private let trackTintView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.secondary?.cgColor, UIColor.primary?.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }()

    // MARK: Properties
    var minValue = 0.0 {
        didSet { self.lower = self.minValue }
    }
    var maxValue = 10.0 {
        didSet { self.upper = self.maxValue }
    }
    var lower = 0.0 {
        didSet { self.updateLayout(self.lower, true) }
    }
    var upper = 0.0 {
        didSet { self.updateLayout(self.upper, false) }
    }
    var lowerThumbColor = UIColor.white {
        didSet { self.lowerThumbButton.backgroundColor = self.lowerThumbColor }
    }
    var upperThumbColor = UIColor.white {
        didSet { self.upperThumbButton.backgroundColor = self.upperThumbColor }
    }
    var trackColor = UIColor.gray {
        didSet { self.trackView.backgroundColor = self.trackColor }
    }
    var trackTintColor = UIColor.green {
        didSet { self.trackTintView.backgroundColor = self.trackTintColor }
    }
    private var previousTouchPoint = CGPoint.zero
    private var isLowerThumbViewTouched = false
    private var isUpperThumbViewTouched = false
    private var leftConstraint: Constraint?
    private var rightConstraint: Constraint?
    private var thumbViewLength: Double {
        Double(self.bounds.height)
    }

    // MARK: Init
    required init?(coder: NSCoder) {
        fatalError("xib is not implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(trackView, trackTintView, lowerThumbButton, upperThumbButton)

        self.lowerThumbButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.lessThanOrEqualTo(self.upperThumbButton.snp.left)
            $0.left.greaterThanOrEqualToSuperview()
            $0.width.equalTo(self.snp.height)
            self.leftConstraint = $0.left.equalTo(self.snp.left).priority(999).constraint
        }
        self.upperThumbButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.greaterThanOrEqualTo(self.lowerThumbButton.snp.right)
            $0.right.lessThanOrEqualToSuperview()
            $0.width.equalTo(self.snp.height)
            self.rightConstraint = $0.left.equalTo(self.snp.left).priority(999).constraint
        }
        self.trackView.snp.makeConstraints {
            $0.left.right.centerY.equalToSuperview()
            $0.height.equalTo(self).multipliedBy(Constant.barRatio)
        }
        self.trackTintView.snp.makeConstraints {
            $0.left.equalTo(self.lowerThumbButton.snp.right)
            $0.right.equalTo(self.upperThumbButton.snp.left)
            $0.top.bottom.equalTo(self.trackView)
        }

        self.trackTintView.layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = trackTintView.bounds
    }

    // MARK: Touch
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        return self.lowerThumbButton.frame.contains(point) || self.upperThumbButton.frame.contains(point)
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        self.previousTouchPoint = touch.location(in: self)
        self.isLowerThumbViewTouched = self.lowerThumbButton.frame.contains(self.previousTouchPoint)
        self.isUpperThumbViewTouched = self.upperThumbButton.frame.contains(self.previousTouchPoint)
        
        if self.isLowerThumbViewTouched {
            self.lowerThumbButton.isSelected = true
        } else {
            self.upperThumbButton.isSelected = true
        }
        
        return self.isLowerThumbViewTouched || self.isUpperThumbViewTouched
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let touchPoint = touch.location(in: self)
        
        let drag = Double(touchPoint.x - self.previousTouchPoint.x)
        let scale = self.maxValue - self.minValue
        let scaledDrag = scale * drag / Double(self.bounds.width - self.thumbViewLength)
        print(scaledDrag)

        if self.isLowerThumbViewTouched {
            self.lower = (self.lower + scaledDrag)
                .clamped(to: (self.minValue...self.upper))
        } else {
            self.upper = (self.upper + scaledDrag)
                .clamped(to: (self.lower...self.maxValue))
        }
        
        self.previousTouchPoint = touchPoint
        self.sendActions(for: .valueChanged)
        delegate?.sliderValueChanged(lowerValue: self.lower, upperValue: self.upper)

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        self.sendActions(for: .valueChanged)
        
        self.lowerThumbButton.isSelected = false
        self.upperThumbButton.isSelected = false
    }

    // MARK: Method
    private func updateLayout(_ value: Double, _ isLowerThumb: Bool) {
        DispatchQueue.main.async {
            let startValue = value - self.minValue
            let length = self.bounds.width - self.thumbViewLength
            let offset = startValue * length / (self.maxValue - self.minValue)
            
            if isLowerThumb {
                self.leftConstraint?.update(offset: offset)
            } else {
                self.rightConstraint?.update(offset: offset)
            }
        }
    }
}

class RoundableButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
class ThumbButton: RoundableButton {
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .white
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.secondary?.cgColor ?? UIColor.blue.cgColor, UIColor.primary?.cgColor ?? UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        shapeLayer.lineWidth = 6.0
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        gradientLayer.mask = shapeLayer
        self.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        shapeLayer.frame = self.bounds
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: shapeLayer.lineWidth / 2, dy: shapeLayer.lineWidth / 2), cornerRadius: self.layer.cornerRadius).cgPath
    }
}


private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

