import UIKit
import SnapKit
import Then

protocol BodyShapeViewControllerDelegate: AnyObject {
    func didSelectBodyShape(_ bodyShape: String)
}

class BodyShapeViewController: UIViewController {
    weak var delegate: BodyShapeViewControllerDelegate?

    let bodyshapeLabel = UILabel().then {
        $0.text = "체형"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 24)
    }

    let promptLabel = UILabel().then {
        $0.text = "프로필에 체형을 추가해보세요."
        $0.textColor = .gray
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }

    let bodyShapeContainer = UIView().then {
        $0.backgroundColor = .white
    }

    let bodyShapeOptions: [String] = ["마른 체형", "보통 체형", "조금 통통", "통통 체형"]
    
    let doneButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.black, for: .normal) // 버튼의 글씨색을 검정색으로 설정
       // $0.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(bodyshapeLabel)
        view.addSubview(promptLabel)
        view.addSubview(bodyShapeContainer)
        view.addSubview(doneButton)

        doneButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        bodyshapeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(51)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        
        promptLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyshapeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }

        bodyShapeContainer.snp.makeConstraints { make in
            make.top.equalTo(promptLabel.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        var previousButton: UIButton?

        for (index, bodyShape) in bodyShapeOptions.enumerated() {
            let button = UIButton(type: .system).then {
                $0.setTitle(bodyShape, for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.titleLabel?.font = UIFont.pretendardMedium(size: 16)
                $0.tag = index
                $0.backgroundColor = .white // 배경색을 흰색으로 설정
                $0.layer.borderWidth = 1.0
                $0.layer.borderColor = UIColor.gray.cgColor
                $0.layer.cornerRadius = 10 // 버튼의 모서리를 둥글게
                $0.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16) // 내부 여백 설정
                //$0.addTarget(self, action: #selector(selectedShape), for: .touchUpInside)
            }

            bodyShapeContainer.addSubview(button)

            button.snp.makeConstraints { make in
                make.top.equalTo(previousButton?.snp.bottom ?? bodyShapeContainer.snp.top).offset(10) // 이전 버튼의 아래에 10pt 간격
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(44) // 버튼의 높이
            }

            previousButton = button // 이전 버튼을 현재 버튼으로 업데이트
        }
        
        // 마지막 버튼이면 바닥에 붙도록 설정
        previousButton?.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview() // 바닥에 붙지 않고, 더 많은 버튼이 있으면 간격을 줄 수 있음
        }
        }
    }

//private func bodyShapeSelected(sender: UIButton) {
//        let selectedShape = bodyShapeOptions[sender.tag]
//        delegate?.didSelectBodyShape(selectedShape)
//        // 모달을 닫거나 다음 화면으로 이동할 수 있습니다.
//    }
//    
//    @objc private func dismissModal() {
//        self.dismiss(animated: true, completion: nil)
//    }
//}
