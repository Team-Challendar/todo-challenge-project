import UIKit
import SnapKit
import MessageUI
import LinkPresentation
import AcknowList

// 설정페이지 ViewController
class SettingViewController: BaseViewController {
    
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, SectionItem>!
    
    // 뷰가 로드될 때 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackAndTitleNavigationBar(title: "설정", checkSetting: true) // 네비게이션 바 설정
        configureTableView() // 테이블 뷰 구성
        configureDataSource() // 데이터 소스 구성
        applySnapShot() // 스냅샷 적용
    }
    
    // UI 구성
    override func configureUI() {
        super.configureUI()
        // 추가 UI 설정이 필요하다면 여기에 작성합니다.
    }
    
    // 제약 조건 구성
    override func configureConstraint() {
        super.configureConstraint()
        // 추가 제약 조건 설정이 필요하다면 여기에 작성합니다.
    }
    
    // 유틸리티 구성
    override func configureUtil() {
        super.configureUtil()
        // 추가 유틸 설정이 필요하다면 여기에 작성합니다.
    }
    
    // 테이블 뷰 구성
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
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
    
    // 데이터 소스 구성
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, SectionItem>(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            switch item {
            case .privacyItem(let model):
                cell.configure(setting: model) // 개인정보 설정 구성
            case .darkModeItem(let model):
                cell.configure(setting: model) // 다크 모드 설정 구성
            case .informationItem(let model):
                cell.configure(setting: model) // 정보 설정 구성
            case .shareItem(let model):
                cell.configure(setting: model) // 공유 설정 구성
            }
            return cell
        }
    }
    
    // 스냅샷 적용
    func applySnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        // 스냅샷에 섹션과 항목 추가
        snapshot.appendSections([.information, .share])
        snapshot.appendItems(SettingModel.information.map { .informationItem($0) }, toSection: .information)
        snapshot.appendItems(SettingModel.share.map { .shareItem($0) }, toSection: .share)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // 이메일 보내기 기능
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            let bodyString = """
            이곳에 내용을 작성해 주세요.
            
            
            ================================
            UUID: \(UIDevice.current.identifierForVendor!.uuidString)
            Device Model : \(UIDevice.current.modelName)
            Device OS : \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)
            App Version : \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
            ================================
            """
            
            // 받는 사람 이메일, 제목, 본문 설정
            composeVC.setToRecipients(["sam98528@gmail.com"])
            composeVC.setSubject("문의 사항")
            composeVC.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeVC, animated: true)
        } else {
            // 이메일 기능 비활성화 시 사용자에게 알림
            let alertController = UIAlertController(title: "메일 계정 활성화 필요",
                                                    message: "Mail 앱에서 사용자의 Email을 계정을 설정해 주세요.",
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
                guard let mailSettingsURL = URL(string: UIApplication.openSettingsURLString + "&&path=MAIL") else { return }
                
                if UIApplication.shared.canOpenURL(mailSettingsURL) {
                    UIApplication.shared.open(mailSettingsURL, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true)
        }
    }
    func openSetting(){
        //        if let url = URL(string: UIApplication.openSettingsURLString) {
        //            UIApplication.shared.open(url)
        //        }
        
        //        let viewController = AcknowListViewController()
        //        navigationController?.pushViewController(viewController, animated: true)
        
        
        let acknows: [Acknow] = AcknowParser.defaultAcknowList()?.acknowledgements ?? []
        
        let viewController = AcknowListViewController(acknowledgements: acknows, style: .insetGrouped)
        viewController.configureBackground()
        viewController.configureBackAndTitleNavigationBar(title: "오픈소스 라이선스", checkSetting: false)
        viewController.title = ""
        navigationController?.pushViewController(viewController, animated: true)
        
    }

    // 설정 열기 기능
//    func openSetting() {
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(url)
//        }
//    }
    
    // 친구에게 공유하기 기능
    func shareToFriend() {
        let url = URL(string: "https://apps.apple.com/us/app/%EC%B1%8C%EB%A6%B0%EB%8D%94-challendar/id6504077858")!
        
        // 공유할 이미지, 제목, 부제목 설정
        let title = "챌린더 - Challendar"
        let subtitle = "The best app to manage your challenges"
        let image = UIImage(named: "AppIcon") // 공유할 이미지 이름
        
        let metadata = LPLinkMetadata()
        metadata.originalURL = url
        metadata.title = title
        
        // 이미지 설정
        if let image = image {
            metadata.imageProvider = NSItemProvider(object: image)
            metadata.iconProvider = NSItemProvider(object: image)
        }
        
        let itemSource = LinkItemSource(metadata: metadata)
        let activityVC = UIActivityViewController(activityItems: [itemSource], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
}

// UITableViewDelegate 구현
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // 푸터의 배경을 투명하게 설정
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            switch item {
            case .privacyItem(let model):
                print("Privacy item selected: \(model)")
            case .darkModeItem(let model):
                print("Dark mode item selected: \(model)")
            case .informationItem(let model):
                if model.menuTitle == "오픈소스 라이선스" {
                    openSetting()
                } else if model.menuTitle == "공지사항" {
                    if let nextVC = model.nextVC {
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }else{
//                    show(EmptyViewController(), sender: self)
                }
            case .shareItem(let model):
                if model.menuTitle == "문의하기" {
                    sendEmail()
                } else if model.menuTitle == "친구에게 공유하기" {
                    shareToFriend()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 셀의 레이아웃 마진을 조정하여 양옆 인셋을 변경
    }
}

// 섹션 정의
extension SettingViewController {
    enum Section {
        case privacy
        case darkMode
        case information
        case share
    }
    
    enum SectionItem: Hashable {
        case privacyItem(SettingModel)
        case darkModeItem(SettingModel)
        case informationItem(SettingModel)
        case shareItem(SettingModel)
    }
}

// MFMailComposeViewControllerDelegate 구현
extension SettingViewController: MFMailComposeViewControllerDelegate {
    // 메일 작성이 끝났을 때 호출되는 메서드
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("메일 보내기 성공")
        case .cancelled:
            print("메일 보내기 취소")
        case .saved:
            print("메일 임시 저장")
        case .failed:
            print("메일 발송 실패")
        @unknown default: break
        }
        self.dismiss(animated: true)
    }
}
// 링크 아이템 소스 정의
class LinkItemSource: NSObject, UIActivityItemSource {
    let metadata: LPLinkMetadata
    init(metadata: LPLinkMetadata) {
        self.metadata = metadata
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return metadata.originalURL!
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return metadata.originalURL!
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return metadata
    }
}
