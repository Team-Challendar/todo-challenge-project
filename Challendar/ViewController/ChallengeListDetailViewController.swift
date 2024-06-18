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

// 챌린지 상세페이지
class ChallengeListDetailViewController: BaseViewController {
    
    // DayModel 데이터 연결부
    var changedMonth : Date?
    var currentDate : Date = Date()
    private var collectionView: UICollectionView!
    var newTodo: Todo? = CoreDataManager.shared.fetchTodos().last
    var dateLabel = UILabel()
    
    
    override func viewDidLoad() {
        configureCollectionView()
        super.viewDidLoad()
        configureFloatingButton()
        configureBackAndTitleNavigationBar(title: newTodo!.title, checkSetting: false)
        self.configureSettingButtonNavigationBar()
        
    }
    
//  추후 추가될 todoitems section
    private func filterTodoitems(date: Date = Date()){
        
    }
    
    // 날짜 변화 obsever가 등록된 NotificationCenter
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
    
    // Base
    override func configureUI() {
        super.configureUI()
        dateLabel.text = DateFormatter.dateFormatterALL.string(from: Date())
        dateLabel.textColor = .secondary200
        dateLabel.font = .pretendardSemiBold(size: 16)
        let dateString = DateFormatter.dateFormatterALL.string(from: Date())
        let attributedString = NSMutableAttributedString(string: dateString)
        
        let lastFourRange = NSRange(location: dateString.count - 4, length: 4)
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondary800, range: lastFourRange)
        
        dateLabel.attributedText = attributedString
        
        self.view.addSubview(dateLabel)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        dateLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12.5)
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    // CollectionView Compositional Layout
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompostionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .secondary900
        collectionView.register(HalfCircleChartViewCell.self, forCellWithReuseIdentifier: HalfCircleChartViewCell.identifier)
        // Calendar cell
        collectionView.register(DetailCalendarCell.self, forCellWithReuseIdentifier: DetailCalendarCell.identifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
    }
    
    // CompostionalLayout Section
    private func createCompostionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createSpecialSection(itemHeight: .estimated(206))
            case 1:
                return self.createSpecialSection(itemHeight: .estimated(440))
            default:
                return nil
            }
        }
    }
    
    // 캘린더 날짜 생성
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
    // 현재 Section 2개 -> 추후 늘어날 수 있음
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
        // 각 섹션에 표현해야할 cell
        switch indexPath.section {
        case 0:     // 반원 차트(SwiftUI)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HalfCircleChartViewCell.identifier, for: indexPath) as? HalfCircleChartViewCell else { return UICollectionViewCell() }
            if let newTodo = newTodo {
                cell.configureDetail(with: newTodo)
            }
            
            return cell
        case 1:     // 챌린지 세부페이지에서 쓰이는 캘린더
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCalendarCell.identifier, for: indexPath) as? DetailCalendarCell else { return UICollectionViewCell() }
            if let newTodo = newTodo {
                cell.configureCalenderView(todo: newTodo)
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // 도전 장려 문구
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            let percentage = (self.newTodo?.getPercentageToToday() ?? 0) * 100
            switch percentage {
            case 0:
                // 퍼센티지 구간별 나눌 문구 필요
                header.sectionLabel.text = "도전을 끝까지 완수해보아요!"
            case 1..<20:
                header.sectionLabel.text = "시작이 반!"
            case 21..<40:
                header.sectionLabel.text = "힘을 내요 슈퍼파워!"
            case 41..<60:
                header.sectionLabel.text = "벌써 절반 가까이 했어요!"
            case 61..<80:
                header.sectionLabel.text = "정말 잘하고 있어요!"
            case 81..<100:
                header.sectionLabel.text = "거의 다 왔어요!"
            case 100:
                header.sectionLabel.text = "도전을 모두 완수했어요!"
            default:
                header.sectionLabel.text = "챌린지 진행률"
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    
}
