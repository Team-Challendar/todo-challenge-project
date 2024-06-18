import UIKit
import SnapKit
import WebKit

// 공지사항 페이지
class NoticeViewController: BaseViewController {
    var noticesList: [NoticeModel] = [] // 공지사항 리스트
    var isExpaned: [Bool] = [] // 확장 상태 리스트
    var tableView: UITableView! // 테이블 뷰
    var dataSource: UITableViewDiffableDataSource<Section, SectionItem>! // 데이터 소스
    
    // 뷰가 로드될 때 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDateFromCloudKit() // CloudKit에서 데이터 가져오기
        configureBackAndTitleNavigationBar(title: "공지사항", checkSetting: false) // 네비게이션 바 설정
    }
    
    // CloudKit에서 데이터 가져오기
    func fetchDateFromCloudKit() {
        CloudKitManager.shared.fetchData(completion: { notices in
            DispatchQueue.main.async {
                self.noticesList = notices
                self.isExpaned = Array(repeating: false, count: notices.count)
                self.configureTableView() // 테이블 뷰 구성
            }
        })
    }
    
    // 테이블 뷰 구성
    func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        view.addSubview(tableView)
        
        // 테이블 뷰 제약 조건 설정
        tableView.snp.makeConstraints {
            $0.bottom.trailing.leading.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(18)
        }
    }
}

// UITableViewDelegate 및 UITableViewDataSource 구현
extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 섹션의 행 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticesList.count
    }
    
    // 행 높이 반환
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if noticesList[indexPath.row].isopen {
            return 375
        } else {
            return 75
        }
    }
    
    // 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as? NoticeTableViewCell else { return UITableViewCell() }
        cell.configure(notice: noticesList[indexPath.row])
        return cell
    }
    
    // 행 선택 시 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noticesList[indexPath.row].isopen.toggle()
        tableView.reloadData()
    }
}

// 섹션 및 섹션 아이템 정의
extension NoticeViewController {
    enum Section {
        case notice
    }
    
    enum SectionItem: Hashable {
        case noticeItem(NoticeModel)
    }
}
