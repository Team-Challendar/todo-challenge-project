import UIKit



class DateBottomSheet: UIView {
    var delegate : DateRangeProtocol?
    var listCollectionView : UICollectionView!
    var emptyView = UIView()
    var laterButton = CustomButton()
    var applybutton = CustomButton()
    var newTodo : Todo?
    var dateRange : DateRange? {
        didSet{
            applybutton.applyState()
        }
    }
    var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        configureCollectionView()
        configureConstraint()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        configureCollectionView()
        configureConstraint()
    }
    
    func configureUI(){
        self.backgroundColor = .challendarBlack80
        applybutton.nonApplyState()
        laterButton.laterState()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
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
    }
    
    func configureConstraint(){
        [listCollectionView, emptyView,stackView ].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [laterButton,applybutton].forEach{
            stackView.addArrangedSubview($0)
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
            $0.bottom.equalTo(stackView.snp.top).offset(-16)
        }
        stackView.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-6)
            $0.height.equalTo(buttonHeight)
        }
        laterButton.snp.makeConstraints{
            $0.height.equalTo(buttonHeight)
        }
        
        applybutton.snp.makeConstraints{
            $0.height.equalTo(buttonHeight)
        }
        
    }
}

extension DateBottomSheet: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DateRange.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = listCollectionView.dequeueReusableCell(withReuseIdentifier: DateBottomSheetCollectionViewCell.identifier, for: indexPath) as? DateBottomSheetCollectionViewCell else{
            return UICollectionViewCell()
        }
        let startDateCase = DateRange.allCases[indexPath.item]

        if startDateCase == self.dateRange {
            cell.configureUI(text: startDateCase.rawValue, checked: true)
        }else{
            cell.configureUI(text: startDateCase.rawValue, checked: false)
        }
        if startDateCase == .manual{
            cell.changeImageforCustom()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dateRange = DateRange.allCases[indexPath.item]
        NotificationCenter.default.post(name: NSNotification.Name("dateRange"), object: dateRange, userInfo: nil)
        self.delegate?.dateRangeChanged(dateRange: self.dateRange)
        self.listCollectionView.reloadData()
    }
    
}
