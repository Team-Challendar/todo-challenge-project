//
//  ChallengeCollectionViewCell.swift
//  Challendar
//
//  Created by 서혜림 on 6/3/24.
//

import UIKit
import SnapKit

class ChallengeListViewController: BaseViewController {
    
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    private var completedTodos: [Todo] = []         // 완료 투두
    private var incompleteTodos: [Todo] = []        // 미완료 투두
    private var upcomingTodos: [Todo] = []          // 예정 투두
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTodos()
        sortByRecentStartDate()
        setupCollectionView()
        setupLayout()
        configureFloatingButton()
    }
    
    override func configureNotificationCenter() {
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dismissedFromSuccess(_:)),
            name: NSNotification.Name("DismissSuccessView"),
            object: nil
        )
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ChallengeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createTodoSection()
        }
    }
    
    private func createTodoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(75))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(75))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(19))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    @objc func dismissedFromSuccess(_ notification: Notification) {
        filterTodos()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // 오늘 기준으로 투두를 필터링
    private func filterTodos() {
        let today = Date()
        let filteredItems = CoreDataManager.shared.fetchTodos().filter { $0.isChallenge == true }
        completedTodos = filteredItems.filter { $0.todayCompleted(date: today) }
        incompleteTodos = filteredItems.filter { !$0.todayCompleted(date: today) && $0.startDate ?? today <= today }
        upcomingTodos = filteredItems.filter { $0.startDate ?? today > today }
    }
    
    // 최신순으로 정렬
    private func sortByRecentStartDate() {
        completedTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        incompleteTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
        upcomingTodos.sort { ($0.startDate ?? Date.distantPast) > ($1.startDate ?? Date.distantPast) }
    }
}

extension ChallengeListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSections = 0
        if !completedTodos.isEmpty {
            numberOfSections += 1
        }
        if !incompleteTodos.isEmpty {
            numberOfSections += 1
        }
        if !upcomingTodos.isEmpty {
            numberOfSections += 1
        }
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !completedTodos.isEmpty && !incompleteTodos.isEmpty && !upcomingTodos.isEmpty {
            if section == 0 {
                return completedTodos.count
            } else if section == 1 {
                return incompleteTodos.count
            } else {
                return upcomingTodos.count
            }
        } else if !completedTodos.isEmpty && !incompleteTodos.isEmpty {
            return section == 0 ? completedTodos.count : incompleteTodos.count
        } else if !completedTodos.isEmpty && !upcomingTodos.isEmpty {
            return section == 0 ? completedTodos.count : upcomingTodos.count
        } else if !incompleteTodos.isEmpty && !upcomingTodos.isEmpty {
            return section == 0 ? incompleteTodos.count : upcomingTodos.count
        } else if !completedTodos.isEmpty {
            return completedTodos.count
        } else if !incompleteTodos.isEmpty {
            return incompleteTodos.count
        } else {
            return upcomingTodos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChallengeCollectionViewCell
        let todo: Todo
        if !completedTodos.isEmpty && !incompleteTodos.isEmpty && !upcomingTodos.isEmpty {
            if indexPath.section == 0 {
                todo = completedTodos[indexPath.item]
            } else if indexPath.section == 1 {
                todo = incompleteTodos[indexPath.item]
            } else {
                todo = upcomingTodos[indexPath.item]
            }
        } else if !completedTodos.isEmpty && !incompleteTodos.isEmpty {
            todo = indexPath.section == 0 ? completedTodos[indexPath.item] : incompleteTodos[indexPath.item]
        } else if !completedTodos.isEmpty && !upcomingTodos.isEmpty {
            todo = indexPath.section == 0 ? completedTodos[indexPath.item] : upcomingTodos[indexPath.item]
        } else if !incompleteTodos.isEmpty && !upcomingTodos.isEmpty {
            todo = indexPath.section == 0 ? incompleteTodos[indexPath.item] : upcomingTodos[indexPath.item]
        } else if !completedTodos.isEmpty {
            todo = completedTodos[indexPath.item]
        } else if !incompleteTodos.isEmpty {
            todo = incompleteTodos[indexPath.item]
        } else {
            todo = upcomingTodos[indexPath.item]
        }
        cell.configure(with: todo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ChallengeSectionHeader
        
        if !completedTodos.isEmpty && !incompleteTodos.isEmpty && !upcomingTodos.isEmpty {
            if indexPath.section == 0 {
                header.sectionLabel.text = "오늘 완료된 목록"
            } else if indexPath.section == 1 {
                header.sectionLabel.text = "지금 도전 중!"
            } else {
                header.sectionLabel.text = "예정된 목록"
            }
        } else if !completedTodos.isEmpty && !incompleteTodos.isEmpty {
            header.sectionLabel.text = indexPath.section == 0 ? "오늘 완료된 목록" : "지금 도전 중!"
        } else if !completedTodos.isEmpty && !upcomingTodos.isEmpty {
            header.sectionLabel.text = indexPath.section == 0 ? "오늘 완료된 목록" : "예정된 목록"
        } else if !incompleteTodos.isEmpty && !upcomingTodos.isEmpty {
            header.sectionLabel.text = indexPath.section == 0 ? "지금 도전 중!" : "예정된 목록"
        } else if !completedTodos.isEmpty {
            header.sectionLabel.text = "오늘 완료된 목록"
        } else if !incompleteTodos.isEmpty {
            header.sectionLabel.text = "지금 도전 중!"
        } else {
            header.sectionLabel.text = "예정된 목록"
        }
        return header
    }
}

class ChallengeSectionHeader: UICollectionReusableView {
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardMedium(size: 16)
        label.textColor = .challendarBlack60
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLabel)
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            sectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
