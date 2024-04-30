import UIKit
import SnapKit
import Then

class InterestsViewController: UIViewController {

    var selectedInterestsButton: UIButton?
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    let contentView = UIView()
    
    let numberLabel = UILabel().then {
        $0.text = "5/5"
        $0.textColor = .red
        $0.textAlignment = .left
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.numberOfLines = 0
    }
    
    let titleLabel = UILabel().then {
        $0.text = "어떤 상을 닮았나요?"
        $0.textColor = .black
        $0.font = UIFont.pretendardSemiBold(size: 24)
        $0.textAlignment = .left
    }
    
    let descriptionLabel = UILabel().then {
        $0.text = "매칭을 위해 필수 단계입니다."
        $0.textColor = .gray
        $0.font = UIFont.pretendardRegular(size: 16)
        $0.textAlignment = .left
    }

    let nextButton = ActualGradientButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    var buttons: [UIButton] = []
    let interests = ["강아지 상", "고양이 상", "사슴 상", "황소 상", "여우 상", "곰 상"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupButtons()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.title = "나의 정보"
        setupScrollView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(nextButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleLabel)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-55)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    private func setupScrollView() {
        // 스크롤 뷰와 컨텐츠 뷰 설정을 추가합니다.
    }
    
    
    private func setupButtons() {
        interests.enumerated().forEach { (index, interest) in
            let button = UIButton().then {
                $0.setTitle(interest, for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.backgroundColor = .white
                $0.layer.borderWidth = 1.0
                $0.layer.borderColor = UIColor.lightGray.cgColor
                $0.layer.cornerRadius = 10
                $0.tag = index
                $0.addTarget(self, action: #selector(interestButtonTapped(_:)), for: .touchUpInside)
            }
            buttons.append(button)
            contentView.addSubview(button)
            
            button.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
                } else {
                    make.top.equalTo(buttons[index - 1].snp.bottom).offset(15)
                }
                make.leading.trailing.equalToSuperview().inset(20)
                make.height.equalTo(50)
            }
        }
        
        // contentView의 bottom을 마지막 버튼의 bottom에 연결하여 스크롤뷰의 컨텐츠 사이즈를 결정합니다.
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(buttons.last!.snp.bottom).offset(20)
        }
    }
    
    @objc func interestButtonTapped(_ sender: UIButton) {
        // 버튼의 선택된 상태를 토글합니다.
        if selectedInterestsButton == sender {
            // 선택 해제 로직
            sender.layer.borderColor = UIColor.lightGray.cgColor
            sender.setTitleColor(.black, for: .normal)
            selectedInterestsButton = nil
        } else {
            // 모든 버튼의 상태를 초기화합니다.
            buttons.forEach { button in
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.setTitleColor(.black, for: .normal)
            }
            // 선택된 버튼의 스타일을 업데이트합니다.
            sender.layer.borderColor = UIColor.red.cgColor
            sender.setTitleColor(.red, for: .normal)
            
            selectedInterestsButton = sender
        }
    }
    
    @objc private func nextButtonTapped() {
        if selectedInterestsButton != nil {
            // 선택된 관심사를 처리하는 로직을 여기에 추가합니다.
            // 예를 들어 다음 화면으로 넘어가거나 선택된 관심사 정보를 저장합니다.
        } else {
            // 관심사가 선택되지 않았을 경우 사용자에게 알립니다.
            showAlertForInterestsSelection()
        }
    }
    
    private func showAlertForInterestsSelection() {
        let alert = UIAlertController(title: "관심사 선택", message: "계속하려면 관심사를 선택해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


