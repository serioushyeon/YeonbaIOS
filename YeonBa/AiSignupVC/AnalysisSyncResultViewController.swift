
import UIKit
import SnapKit
import Then

class AnalysisSyncResultViewController: UIViewController {
    
    // MARK: - UI Components
    let titleLabel = UILabel().then{
        $0.text = "유사도 분석"
        $0.font = UIFont.pretendardMedium(size: 18)
    }
    let backButton = UIButton(type: .system).then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .light)
        let image = UIImage(named: "BackButton")
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor.black
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    let selfieImage = UIImageView().then{
        $0.image = UIImage(named: "GuideGoodImage1")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let profileImage1 = UIImageView().then{
        $0.image = UIImage(named: "GuideGoodImage1")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let profileImage2 = UIImageView().then{
        $0.image = UIImage(named: "GuideGoodImage1")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let text1 = UILabel().then{
        $0.text = "연방님의 유사도는"
        $0.font = UIFont.pretendardExtraBold(size: 32)
    }
    let text2 = UILabel().then{
        $0.text = "40%에요!"
        $0.font = UIFont.pretendardExtraBold(size: 32)
    }
    let explainText = UILabel().then{
        $0.text = "업로드한 사진과 실제 얼굴이 달라요\nAI 포토샵으로 유사도를 높일 수 있어요!"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.pretendardMedium(size: 16)
        $0.textColor = UIColor.gray
    }
    
    let selfieBtn = UIButton().then {
        $0.setTitle("셀카 다시찍기", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1.4
        $0.backgroundColor = UIColor.white
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(reSelfieBtnTapped), for: .touchUpInside)
    }
    let aiBtn = ActualGradientButton().then {
        $0.setTitle("AI 포토샵 하러가기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(aiBtnTapped), for: .touchUpInside)
    }
    
    let startBtn = ActualGradientButton().then {
        $0.setTitle("연바 시작하기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(startBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func aiBtnTapped() {
        let aiVC = AiPhotoshopViewController()
        navigationController?.pushViewController(aiVC, animated: true)
    }
    @objc func reSelfieBtnTapped() {
        let guideVC = GuideViewController()
        navigationController?.pushViewController(guideVC, animated: true)
    }
    @objc func startBtnTapped() {
        print("startBtnTapped")
    }
    @objc func backButtonTapped() {
        // 뒤로 가기 로직을 구현
        dismiss(animated: true, completion: nil)
    }
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
        configUI()
        
        //특정 문자만 색상 변경, 퍼센트 부분 색상 변경
        let fullText = text2.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "40%")
        attribtuedString.addAttribute(.foregroundColor, value: UIColor.primary, range: range)
        text2.attributedText = attribtuedString
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - UI Layout
    func configUI() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.leading.equalToSuperview().offset(21)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55)
            make.centerX.equalToSuperview()
        }
        
        selfieImage.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.right.equalTo(titleLabel.snp.right)
            make.width.equalTo(219)
            make.height.equalTo(314)
            
        }
        
        profileImage1.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.left.equalTo(selfieImage.snp.right).offset(10)
            make.width.equalTo(124)
            make.height.equalTo(152)
            
        }
        profileImage2.snp.makeConstraints{ make in
            make.top.equalTo(profileImage1.snp.bottom).offset(10)
            make.left.equalTo(selfieImage.snp.right).offset(10)
            make.width.equalTo(124)
            make.height.equalTo(152)
            
        }
        text1.snp.makeConstraints{ make in
            make.top.equalTo(selfieImage.snp.bottom).offset(69)
            make.centerX.equalToSuperview()
        }
        text2.snp.makeConstraints{ make in
            make.top.equalTo(text1.snp.bottom).offset(5.75)
            make.centerX.equalToSuperview()
            
        }
        explainText.snp.makeConstraints{ make in
            make.top.equalTo(text2.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            
        }
        selfieBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-55)
            make.right.equalTo(view.snp.centerX).offset(-2.5)
            make.width.equalTo(174)
            make.height.equalTo(56)
        }
        aiBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-55)
            make.left.equalTo(view.snp.centerX).offset(2.5)
            make.width.equalTo(174)
            make.height.equalTo(56)
        }
        //유사도 높으면 바로 시작
        /*startBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-55)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(56)
        }*/

        
    }
    
    func addSubViews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(selfieImage)
        view.addSubview(profileImage1)
        view.addSubview(profileImage2)
        view.addSubview(text1)
        view.addSubview(text2)
        view.addSubview(explainText)
        view.addSubview(selfieBtn)
        view.addSubview(aiBtn)
        //유사도 높으면 시작 버튼
        //view.addSubview(startBtn)
    }
}
