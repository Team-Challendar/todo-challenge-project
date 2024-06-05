//
//  ViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import SnapKit

class TodoCalendarViewController: BaseViewController, PeriodPickerButtonViewDelegate  {
    
   
    private let periodBtnView = PeriodPickerButtonView() // 기간피커
    
    private var todoItems: [Todo] = CoreDataManager.shared.fetchTodos()
    private var completedTodo : [Todo] = []
    private var inCompletedTodo: [Todo] = []
    var days : [Day] = []
    var changedMonth : Date?
    var currentDate : Date = Date()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        filterTodoitems()
        configureCollectionView()
        super.viewDidLoad()
        configureFloatingButton()
        configureTitleNavigationBar(title: "월간")
        configureNoticationCenter()
        
        periodBtnView.delegate = self
        
        view.addSubview(periodBtnView) // 기간피커
        
        periodBtnView.snp.makeConstraints { make in
            make.width.equalTo(131)
            make.height.equalTo(133)
            make.left.equalToSuperview().offset(16) // x 좌표 설정
            make.top.equalToSuperview().offset(104) // y 좌표 설정
        }
    }

    func didTapdailyButton() {
          let weeklyVC = DailyViewController() // 주간 뷰컨트롤러 인스턴스 생성
          self.navigationController?.pushViewController(weeklyVC, animated: true)
      }
    
    
    func configureNoticationCenter(){
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.dismissedFromSuccess(_:)),
                  name: NSNotification.Name("DismissSuccessView"),
                  object: nil
              )
        NotificationCenter.default.addObserver(self, selector: #selector(monthChanged), name: NSNotification.Name("month"), object: changedMonth)
        NotificationCenter.default.addObserver(self, selector: #selector(monthChanged), name: NSNotification.Name("date"), object: changedMonth)
    }
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
    }
    
    override func configureUI() {
        super.configureUI()
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .red
        collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(TodoCalendarCell.self, forCellWithReuseIdentifier: TodoCalendarCell.identifier)
        collectionView.register(ChallengeSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.createSpecialSection()
            case 1, 2:
                return self.createTodoSection()
            default:
                return nil
            }
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
    
    private func createSpecialSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(404))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(404))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        section.interGroupSpacing = 8

        return section
    }
    @objc func dismissedFromSuccess(_ notification: Notification) {
        todoItems = CoreDataManager.shared.fetchTodos()
        filterTodoitems(date: currentDate)
        collectionView.reloadData()
    }
    @objc func monthChanged(notification : Notification){
        guard let month = notification.object as? Date else {return}
        self.currentDate = month.addingDays(1)!
        self.filterTodoitems(date: month.addingDays(1)!)
        collectionView.reloadData()
    }
    @objc func dateChanged(notification : Notification){
        guard let date = notification.object as? Date else {return}
        self.currentDate = date
        self.filterTodoitems(date: date)
        collectionView.reloadData()
    }
}
extension TodoCalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return inCompletedTodo.count
        case 2:
            return completedTodo.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCalendarCell.identifier, for: indexPath) as? TodoCalendarCell else {return UICollectionViewCell()}
            cell.configureCalenderView(days: self.days)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChallengeCollectionViewCell
            cell.configure(with: inCompletedTodo[indexPath.item])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChallengeCollectionViewCell
            cell.configure(with: completedTodo[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionView.elementKindSectionHeader {
               let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ChallengeSectionHeader
               switch indexPath.section {
               case 1:
                   header.sectionLabel.text = "할일"
               case 2:
                   header.sectionLabel.text = "완료된 투두"
               default:
                   header.sectionLabel.text = "챌린지 투두"
               }
               return header
           }
           return UICollectionReusableView()
       }
}


