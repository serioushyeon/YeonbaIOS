import UIKit
import SnapKit
import Then

class AnalysisSyncViewController: UIViewController {
    
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
    
    let uploadText = UILabel().then{
        $0.text = "업로드 사진"
        $0.font = UIFont.pretendardSemiBold(size: 16)
        $0.textColor = UIColor.customgray4
    }
    let progressIcon = UIImageView().then{
        $0.image = UIImage(named: "ProgressIcon")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    let selfieImage = UIImageView().then{
        $0.image = UIImage(named: "GuideGoodImage1")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let selfieText = UILabel().then{
        $0.text = "셀카"
        $0.font = UIFont.pretendardSemiBold(size: 16)
        $0.textColor = UIColor.customgray4
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
        $0.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
    }
    
    let startBtn = ActualGradientButton().then {
        $0.setTitle("유사도 분석하러 가기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendardSemiBold(size: 16)
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(resultBtnTapped), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc func resultBtnTapped() {
        let AnaysisSyncResultVC = AnalysisSyncResultViewController()
        navigationController?.pushViewController(AnaysisSyncResultVC, animated: true)
    }
    @objc func cameraBtnTapped() {
        let guideVC = GuideViewController()
        navigationController?.pushViewController(guideVC, animated: true)
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
        
        profileImage1.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(55)
            make.right.equalTo(view.snp.centerX).offset(-4)
            make.width.equalTo(124)
            make.height.equalTo(152)
            
        }
        profileImage2.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(55)
            make.left.equalTo(view.snp.centerX).offset(4)
            make.width.equalTo(124)
            make.height.equalTo(152)
            
        }
        uploadText.snp.makeConstraints{ make in
            make.top.equalTo(profileImage1.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        progressIcon.snp.makeConstraints{make in
            make.top.equalTo(uploadText.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.width.equalTo(12)
            make.height.equalTo(42)
        }
        selfieImage.snp.makeConstraints{ make in
            make.top.equalTo(progressIcon.snp.bottom).offset(21)
            make.centerX.equalToSuperview()
            make.width.equalTo(188)
            make.height.equalTo(230)
            
        }
        selfieText.snp.makeConstraints{ make in
            make.top.equalTo(selfieImage.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            
        }
        selfieBtn.snp.makeConstraints{make in
            make.bottom.equalTo(startBtn.snp.top).offset(-8)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(56)
        }
        startBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-55)
            make.centerX.equalToSuperview()
            make.width.equalTo(353)
            make.height.equalTo(56)
        }

        
    }
    
    func addSubViews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(profileImage1)
        view.addSubview(profileImage2)
        view.addSubview(uploadText)
        view.addSubview(progressIcon)
        view.addSubview(selfieImage)
        view.addSubview(selfieText)
        view.addSubview(selfieBtn)
        view.addSubview(startBtn)
    }
}
