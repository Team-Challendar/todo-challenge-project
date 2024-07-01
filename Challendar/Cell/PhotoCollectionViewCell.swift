//
//  PhotoCollectionViewCell.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit
import RxSwift

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "PhotoCollectionViewCell"
    let deleteButton = UIButton(type: .custom)
    var dispose = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder : NSCoder){
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dispose = DisposeBag()
    }
    func configure(image: UIImage){
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.deleteButton.setImage(UIImage.deleteCircleS, for: .normal)
        self.deleteButton.imageView?.contentMode = .scaleAspectFit
        
        self.backgroundColor = .clear
        let imageView = PhotoImageView(image: image)
        self.addSubview(imageView)
        self.addSubview(deleteButton)
        
        imageView.snp.makeConstraints{
            $0.height.width.equalTo(64)
            $0.bottom.leading.equalToSuperview()
        }
        deleteButton.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.top).offset(-4)
            $0.trailing.equalTo(imageView.snp.trailing).offset(4)
            $0.width.height.equalTo(16)
        }
    }
}
