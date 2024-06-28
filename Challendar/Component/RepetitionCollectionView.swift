//
//  RepetitionCollectionView.swift
//  Challendar
//
//  Created by 서혜림 on 6/21/24.
//

import UIKit
import SnapKit

protocol RepetitionCollectionViewDelegate: AnyObject {
    func repetitionCollectionView(_ collectionView: RepetitionCollectionView, didSelectItemAt index: Int)
    func selectedDates(dates: [Int])
}

class RepetitionCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var items: [String] = []
    var selectedDates: [Int] = [0]
    weak var delegate: RepetitionCollectionViewDelegate?
    private let collectionView: UICollectionView
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        configureCollectionView()
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(RepetitionCollectionViewCell.self, forCellWithReuseIdentifier: RepetitionCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupUI() {
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepetitionCollectionViewCell.identifier, for: indexPath) as? RepetitionCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.row])
        if indexPath.row == 0 {
            collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = items[indexPath.row]
        let width = (text as NSString).size(withAttributes: [.font: UIFont.pretendardRegular(size: 12)]).width + 24
        return CGSize(width: width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectedDates.forEach{
                collectionView.deselectItem(at: IndexPath.init(row: $0, section: 0), animated: true)
            }
            selectedDates = [0]
        }
//        if selectedDates.contains(indexPath.row) {
//            selectedDates.removeAll { $0 == indexPath.row }
//        } 
        else {
            if selectedDates.contains(0){
                collectionView.deselectItem(at: IndexPath.init(row: 0, section: 0), animated: true)
            }
            selectedDates.removeAll {
                $0 == 0
            }
            selectedDates.append(indexPath.row)
        }
        selectedDates.sort()
        delegate?.selectedDates(dates: selectedDates)
        delegate?.repetitionCollectionView(self, didSelectItemAt: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if selectedDates.contains(indexPath.row) {
//            selectedDates.removeAll { $0 == indexPath.row }
//        } else {
//            selectedDates.append(indexPath.row)
//        }
        selectedDates.removeAll { $0 == indexPath.row }
        
        if selectedDates.isEmpty {
            selectedDates.append(0)
            collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
        }
        selectedDates.sort()
        delegate?.selectedDates(dates: selectedDates)
        delegate?.repetitionCollectionView(self, didSelectItemAt: indexPath.row)
    }
}
