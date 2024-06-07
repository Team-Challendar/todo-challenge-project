//
//  ChallengeListDetailViewController.swift
//  Challendar
//
//  Created by /Chynmn/M1 pro—̳͟͞͞♡ on 6/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ChallengeListDetailViewController: BaseViewController {
    
    // DayModel 데이터 연결부
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    private var completedTodo : [Todo] = []
    private var inCompletedTodo: [Todo] = []
    var days : [Day] = []
    var changedMonth : Date?
    var currentDate : Date = Date()
    private var collectionView: UICollectionView!
    

    override func viewDidLoad() {
//        filterTodoitems()
        configureCollectionView()
        super.viewDidLoad()
        configureFloatingButton()
        configureCollectionView()
    }
    
//    추후 추가될 todoitems section
    private func filterTodoitems(date: Date = Date()){
        self.todoItems = todoItems.filter({
            $0.startDate != nil
        })
        completedTodo = todoItems.filter({
            $0.todayCompleted(date: date) == true
        })
        inCompletedTodo = todoItems.filter({
            $0.todayCompleted(date: date) == false
        })
        days = Day.generateDaysForMonth(date: date, todos: self.todoItems)
    }
    
    override func configureNotificationCenter(){
        super.configureNotificationCenter()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.dismissedFromSuccess(_:)),
            name: NSNotification.Name("DismissSuccessView"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(monthChanged), name: NSNotification.Name("month"), object: changedMonth)
        NotificationCenter.default.addObserver(self, selector: #selector(monthChanged), name: NSNotification.Name("date"), object: changedMonth)
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(todoCompletedStateChanged(_:)),
//            name: NSNotification.Name("TodoCompletedStateChanged"),
//            object: nil
//        )
    }
    
    @objc func dismissedFromSuccess(_ notification: Notification) {
        filterTodoitems()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func monthChanged(notification : Notification){
        guard let month = notification.object as? Date else {return}
        self.currentDate = month.addingDays(1)!
        self.filterTodoitems(date: month.addingDays(1)!)
        collectionView.reloadData()
    }
    
    //    @objc func todoCompletedStateChanged(_ notification: Notification) {
    //        filterTodoitems()
    //        DispatchQueue.main.async {
    //            self.collectionView.reloadData()
    //        }
    //    }
    
    override func configureUI() {
        super.configureUI()
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: creaateCompostionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "challendarBlack80")
        collectionView.register(HalfCircleChartViewCell.self, forCellWithReuseIdentifier: HalfCircleChartViewCell.identifier)
        // Calendar cell
        collectionView.register(DetailCalendarCell.self, forCellWithReuseIdentifier: DetailCalendarCell.identifier)
        collectionView.register(ChallengeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func creaateCompostionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createChartSection()
            case 1:
                return self.createCalendarSection()
            default:
                return nil
            }
        }
    }
    
    private func createChartSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(19))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createCalendarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(404))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(404))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0)
        
        return section
    }
}

extension ChallengeListDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HalfCircleChartViewCell.identifier, for: indexPath) as? HalfCircleChartViewCell else { return UICollectionViewCell() }
            cell.configure(with: self.todoItems)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCalendarCell.identifier, for: indexPath) as? DetailCalendarCell else { return UICollectionViewCell() }
            cell.configureCalenderView(days: self.days)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ChallengeSectionHeader
            
            switch indexPath.section {
            case 0:
                // 퍼센티지 구간별 나눌 문구 필요
                header.sectionLabel.text = "잘하고 있어요!"
            default:
                header.sectionLabel.text = "챌린지 진행률"
            }
            return header
        }
        return UICollectionReusableView()
    }
}
