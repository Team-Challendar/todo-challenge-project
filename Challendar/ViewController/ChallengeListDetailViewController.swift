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
import FSCalendar

class ChallengeListDetailViewController: BaseViewController {
    
    // DayModel 데이터 연결부
    var changedMonth : Date?
    var currentDate : Date = Date()
    private var collectionView: UICollectionView!
//    var newTodo: Todo? = challenge
    var newTodo: Todo? = CoreDataManager.shared.fetchTodos().last
    
    
    
    override func viewDidLoad() {
        configureCollectionView()
        super.viewDidLoad()
        configureFloatingButton()
        configureCollectionView()
        configureBackAndTitleNavigationBar(title: newTodo!.title, checkSetting: false)
        
    }
    
//    추후 추가될 todoitems section
    private func filterTodoitems(date: Date = Date()){
        
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
    
    func createDate(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components)
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
            if let newTodo = newTodo {
                cell.configureDetail(with: newTodo)
            }
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCalendarCell.identifier, for: indexPath) as? DetailCalendarCell else { return UICollectionViewCell() }
            if let newTodo = newTodo {
                cell.configureCalenderView(todo: newTodo)
            }
            
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

// 더미 데이터



//    func createDate() -> Date.locale {
//        // Calendar와 DateComponents를 이용해 startDate와 endDate를 생성
//        let calendar = Calendar.current
//
//        // 6월 1일의 날짜를 만듭니다.
//        var startDateComponents = DateComponents()
//        startDateComponents.year = 2024
//        startDateComponents.month = 6
//        startDateComponents.day = 1
//        let startDate = calendar.date(from: startDateComponents)!
//
//        // 6월 30일의 날짜를 만듭니다.
//        var endDateComponents = DateComponents()
//        endDateComponents.year = 2024
//        endDateComponents.month = 6
//        endDateComponents.day = 30
//        let endDate = calendar.date(from: endDateComponents)!
//    }
    
//let challenge: Todo =
//Todo(title: "6/1~6/30", memo: "메모", startDate: createDate(year: 2024, month: 6, day: 1), endDate: createDate(year: 2024, month: 6, day: 30), completed: [true, true, true, true, true, true, true, true, false, true, false, true, true, true, true, true, true, false, true, false, true, true, true, true, true, true, false, true, false, true], isChallenge: true, percentage: 20)
//        Todo(title: <#T##String#>, memo: <#T##String?#>, startDate: <#T##Date?#>, endDate: <#T##Date?#>, completed: <#T##[Bool]#>, isChallenge: <#T##Bool#>, percentage: <#T##Double#>, images: <#T##[UIImage]?#>)
        
        
//    let challengeDay: Day = Day(date: <#T##Date#>, listCount: <#T##Int#>, completedListCount: <#T##Int#>, percentage: <#T##Double#>, todo: )

