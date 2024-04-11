//
//  PhotoPlaceHolderView.swift
//  YeonBa
//
//  Created by 김민솔 on 4/10/24.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class PhotoPlaceholderView: DottedBorderView {
    
    // MARK: - Properties
    
    private let hintLabel = UILabel().then {
        $0.textColor = .customgray3
        $0.textAlignment = .center
        $0.font = .pretendardSemiBold(size: 20)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        layer.borderColor = UIColor(hex: "616161").cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor(hex: "EFEFEF")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(hintLabel)
        setupConstraints()
        layer.addDottedBorder()
    }
    
    private func setupConstraints() {
        hintLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    func setHintText(_ text: String) {
        hintLabel.text = text
    }
    
    // MARK: - Actions
    
    @objc private func didTapView() {
        // Check if photo library is available
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Photo library is not available.")
            return
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
}
// MARK: - UIImagePickerControllerDelegate
extension PhotoPlaceholderView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Handle the selected image
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}


