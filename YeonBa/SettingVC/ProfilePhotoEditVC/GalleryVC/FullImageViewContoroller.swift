//
//  FullImageViewContoroller.swift
//  YeonBa
//
//  Created by jin on 5/29/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class FullImageViewContoroller: UIViewController {
    var image: UIImage
    weak var delegate: PhotoEditSelectionDelegate?
    
    private var imageView: UIImageView!
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupImageView()
        setupNavigationBar()
    }
    
    private func setupImageView() {
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(dismissViewController))
    }
    
    @objc func dismissViewController() {
        delegate?.didSelectPhoto(image)
        if let navController = navigationController {
            for controller in navController.viewControllers {
                if let photoSelectionVC = controller as? ProfilePhotoEditViewController {
                    navController.popToViewController(photoSelectionVC, animated: false)
                    return
                }
            }
        }
    }
}



