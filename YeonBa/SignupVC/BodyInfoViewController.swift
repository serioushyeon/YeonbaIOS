import UIKit
import SnapKit
import Then



class BodyInfoViewController: UIViewController, HeightPickerViewControllerDelegate, BodyShapeViewControllerDelegate {
    
    var selectedHeight: Int? {
          didSet {
              // 사용자가 키를 선택하면 heightTitleLabel의 텍스트를 업데이트합니다.
              heightTitleLabel.text = "\(selectedHeight!)cm"
          }
      }

    var heightTitleLabel: UILabel!
    var bodyShapeTitleLabel: UILabel!
    
    let numberLabel = UILabel().then {
        $0.text = "1/4"
        $0.textColor = .red
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }
    
    let instructionLabel = UILabel().then {
        $0.text = "신체정보를 입력해 주세요."
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }
    
    let addinstructionLabel = UILabel().then {
        $0.text = "매칭을 위해 필수 단계입니다. 이후 변경이 불가합니다."
        $0.textColor = .gray
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 16)
        $0.numberOfLines = 0
    }
    
    let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor.red
        $0.layer.cornerRadius = 25
        // Add more styling if needed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.title = "나의 정보"
        
        view.addSubview(numberLabel)
        view.addSubview(instructionLabel)
        view.addSubview(addinstructionLabel)
        view.addSubview(verticalStackView)
        view.addSubview(nextButton)
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addinstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(addinstructionLabel.snp.top).offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Create the 'Height' and 'BodyShape' custom views
        let heightView = createCustomView(title: "키가 어떻게 되세요?", for: .height)
        let bodyShapeView = createCustomView(title: "체형이 어떻게 되세요?", for: .bodyShape)
        
        // Add custom views to the stack view
        verticalStackView.addArrangedSubview(heightView)
        verticalStackView.addArrangedSubview(bodyShapeView)
        
        // Set up constraints for the next button
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    private func createCustomView(title: String, for infoType: InfoType) -> UIView {
            
        
        let customView = UIView().then {
           $0.backgroundColor = .white
           $0.layer.borderWidth = 1.0 // Set border width
           $0.layer.borderColor = UIColor.lightGray.cgColor // Set border color
           $0.layer.cornerRadius = 10
       }
       
        let titleLabel = UILabel().then {
          $0.text = title
          $0.textColor = .black
          $0.font = UIFont.pretendardSemiBold(size: 18)
       }
       customView.addSubview(titleLabel)
       titleLabel.snp.makeConstraints { make in
          make.centerY.equalToSuperview()
          make.leading.equalToSuperview().offset(20)
       }
        
       
       let arrowImageView = UIImageView().then {
           $0.image = UIImage(systemName: "chevron.right")
           $0.tintColor = .gray
       }
       
       customView.addSubview(arrowImageView)
       
       arrowImageView.snp.makeConstraints { make in
           make.centerY.equalToSuperview()
           make.trailing.equalToSuperview().offset(-20)
       }
       
        if infoType == .height {
            heightTitleLabel = titleLabel
            customView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showHeightPicker)))
        } else if infoType == .bodyShape {
            bodyShapeTitleLabel = titleLabel
            customView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showBodyShape)))
        }
       // 높이가 지정된 경우 customView에 제약 조건을 설정합니다.
       customView.snp.makeConstraints { make in
           make.height.equalTo(60)
       }
       
       return customView
    }
    
    
    @objc private func customViewTapped(_ sender: UITapGestureRecognizer) {
        // Handle the tap event on the custom view
        let heightPickerVC = HeightPickerViewController()
        heightPickerVC.modalPresentationStyle = .pageSheet
        heightPickerVC.delegate = self

        self.present(heightPickerVC, animated: true, completion: nil)
        
        // iOS 15 이상에서만 사용 가능
        if #available(iOS 15.0, *) {
            if let sheet = heightPickerVC.sheetPresentationController {
                // 사용자가 변경할 수 있는 두 가지 크기(detent)를 설정합니다.
                sheet.detents = [.medium(), .large()]
                // 기본값을 .medium으로 설정합니다.
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersGrabberVisible = true
            }
        }
        
        let bodyShapeVC = BodyShapeViewController()
        bodyShapeVC.modalPresentationStyle = .pageSheet
        bodyShapeVC.delegate = self
        
        self.present(bodyShapeVC, animated: true, completion: nil)
        
        // iOS 15 이상에서만 사용 가능
        if #available(iOS 15.0, *) {
            if let sheet = bodyShapeVC.sheetPresentationController {
                // 사용자가 변경할 수 있는 두 가지 크기(detent)를 설정합니다.
                sheet.detents = [.medium(), .large()]
                // 기본값을 .medium으로 설정합니다.
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersGrabberVisible = true
            }
        }
        
        
        
    }
    @objc func showHeightPicker() {
        let heightPickerVC = HeightPickerViewController()
        heightPickerVC.delegate = self
        present(heightPickerVC, animated: true, completion: nil)
    }
    
    func updateHeightView() {
            // 여기서 heightTitleLabel의 텍스트를 업데이트합니다.
            heightTitleLabel.text = selectedHeight != nil ? "\(selectedHeight!)cm" : "키가 어떻게 되세요?"
        }
    
    func didSelectHeight(_ height: Int) {
        DispatchQueue.main.async {
            self.selectedHeight = height
            self.updateHeightView() // 여기서 키 라벨을 업데이트합니다.
        }
    }

    @objc func showBodyShape() {
        let bodyShapeVC = BodyShapeViewController()
        // bodyShapePickerVC.delegate = self // 필요한 경우 델리게이트 설정
        present(bodyShapeVC, animated: true, completion: nil)
    }
    
    func updateBodyShapeView() {
            
        
        }
    
    // BodyShapeViewControllerDelegate 구현 (예시)
    func didSelectBodyShape(_ bodyShape: String) {
        DispatchQueue.main.async {
            // 이곳에서 선택된 체형을 처리하고 UI를 업데이트합니다.
            self.bodyShapeTitleLabel.text = bodyShape
        }
    }
    
}

enum InfoType {
    case height
    case bodyShape
}

private func customViewTapped(_ sender: UITapGestureRecognizer) {
    // 'customViewTapped' 메소드에서 'HeightPickerViewController'를 제대로 표시하도록 로직을 수정하세요.
    // 예를 들어, 사용자가 'heightView'를 탭했을 때만 'HeightPickerViewController'가 나타나게 할 수 있습니다.
}
