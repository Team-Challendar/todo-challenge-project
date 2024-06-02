import UIKit


class DateBottomSheet: UIView {
    var listCollectionView : UICollectionView!
    var emptyView = UIView()
    
    var button = ConfirmButton()
    var startDate : StartDate?
    var endDate : EndDate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureCollectionView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureCollectionView()
    }
    
    func configureUI(){
        self.backgroundColor = .challendarBlack80
        button.changeTitle(title: "적용하기")
        button.highLightState()
        emptyView.backgroundColor = .challendarEmpty
        emptyView.layer.cornerRadius = 2.5
        emptyView.clipsToBounds = true
    }
    
    func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 48)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.isScrollEnabled = false
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        listCollectionView.backgroundColor = .challendarBlack80
        listCollectionView.register(DateBottomSheetCollectionViewCell.self, forCellWithReuseIdentifier: DateBottomSheetCollectionViewCell.identifier)
        listCollectionView.showsVerticalScrollIndicator = false
        listCollectionView.showsHorizontalScrollIndicator = false
        
        configureConstraint()
    }
    
    func configureConstraint(){
        [button, listCollectionView, emptyView].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        emptyView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(6)
            $0.width.equalTo(36)
            $0.height.equalTo(5)
        }
        listCollectionView.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(horizontalPadding)
            $0.top.equalToSuperview().offset(collectionViewToVC)
            $0.bottom.equalTo(button.snp.top).offset(-16)
        }
        button.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-12)
            $0.height.equalTo(buttonHeight)
        }
    }
}

extension DateBottomSheet: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = startDate {
            return StartDate.allCases.count
        }else{
            return EndDate.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = listCollectionView.dequeueReusableCell(withReuseIdentifier: DateBottomSheetCollectionViewCell.identifier, for: indexPath) as? DateBottomSheetCollectionViewCell else{
            return UICollectionViewCell()
        }
        if let _ = startDate{
            let startDateCase = StartDate.allCases[indexPath.item]
            if startDateCase == self.startDate {
                cell.configureUI(text: startDateCase.rawValue, checked: true)
            }else{
                cell.configureUI(text: startDateCase.rawValue, checked: false)
            }
            return cell
        }else{
            let endDateCase = EndDate.allCases[indexPath.item]
            if endDateCase == self.endDate {
                cell.configureUI(text: endDateCase.rawValue, checked: true)
            }else{
                cell.configureUI(text: endDateCase.rawValue, checked: false)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = startDate{
            self.startDate = StartDate.allCases[indexPath.item]
            NotificationCenter.default.post(name: NSNotification.Name("startDate"), object: startDate, userInfo: nil)
        }else{
            self.endDate = EndDate.allCases[indexPath.item]
            NotificationCenter.default.post(name: NSNotification.Name("endDate"), object: endDate, userInfo: nil)
        }
        self.listCollectionView.reloadData()
    }

}
