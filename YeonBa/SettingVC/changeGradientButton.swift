import UIKit

class ChangeGradientButton: UIButton {
    private var isActive = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        applyGradient(isActive: isActive)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(isActive: isActive)  // 버튼 크기가 변경될 때마다 그라디언트 업데이트
    }
    
    func applyGradient(isActive: Bool) {
        self.isActive = isActive
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = self.bounds
        
        if isActive {
            gradientLayer.colors = [UIColor.secondary?.cgColor, UIColor.primary?.cgColor]
            self.setTitleColor(.white, for: .normal)  // 활성화 상태에서는 흰색 글씨
        } else {
            gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
            self.setTitleColor(.black, for: .normal)  // 비활성화 상태에서는 검은색 글씨
        }
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.masksToBounds = true
    }

    func activate() {
        applyGradient(isActive: true)
        self.isEnabled = true  // 버튼을 활성화 상태로 만듭니다.
    }

    func deactivate() {
        applyGradient(isActive: false)
        self.isEnabled = false  // 버튼을 비활성화 상태로 만듭니다.
    }
}
