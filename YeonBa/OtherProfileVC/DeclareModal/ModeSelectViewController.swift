//
//  ModeSelectViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/28/24.
//

import UIKit

protocol ModeSelectViewControllerDelegate: AnyObject {
    func didSelectedRowAt(indexPath: Int)
}

final class ModeSelectViewController: UIViewController {
    weak var delegate: ModeSelectViewControllerDelegate?
    private let customTransitioningDelegate = ModeSelectTransitioningDelegate()
    private let currentMode: DeclareMode
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.register(ModeSelectCell.self,
                           forCellReuseIdentifier: "modalCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(passMode: DeclareMode) {
        self.currentMode = passMode
        super.init(nibName: nil, bundle: nil)
        setupModalStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupModalStyle() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
        transitioningDelegate = customTransitioningDelegate
    }
    
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
    }
    

    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = view.bounds.height / 15
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}

extension ModeSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "modalCell",
                                                       for: indexPath) as? ModeSelectCell else {
            return UITableViewCell(style: .default, reuseIdentifier: .none)
        }
        let mode = DeclareMode.allCases[indexPath.row]
        cell.setup(label: mode.title, isChecked: currentMode == mode)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectedRowAt(indexPath: indexPath.row)
                
        dismissView()
    }
}

// MARK: Setup Layout
extension ModeSelectViewController {
    private func setupView() {
        setupInitialView()
        setupLayout()
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
