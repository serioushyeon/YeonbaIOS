import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"

    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "circle.fill") // Use your custom image
        imageView.tintColor = .black
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "박원빈님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let unblockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("차단 풀기", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 7
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(circleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(unblockButton)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        circleImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(circleImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }

        unblockButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

    public func configure(with title: String) {
        titleLabel.text = title
    }
}

class BlockingmanagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // For example
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: "박원빈 님")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell tap
    }
}
