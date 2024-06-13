//
//  SettingViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 6/4/24.
//

import UIKit
import SnapKit
import MessageUI

class SettingViewController: BaseViewController {
    
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, SectionItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackAndTitleNavigationBar(title: "설정", checkSetting: true)
        configureTableView()
        configureDataSource()
        applySnapShot()
    }
    
    override func configureUI() {
        super.configureUI()
        // 추가 UI 설정이 필요하다면 여기에 작성합니다.
    }
    
    override func configureConstraint() {
        super.configureConstraint()
        // 추가 제약 조건 설정이 필요하다면 여기에 작성합니다.
    }
    
    override func configureUtil() {
        super.configureUtil()
        // 추가 유틸 설정이 필요하다면 여기에 작성합니다.
    }
    
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
        
        tableView.snp.makeConstraints{
            $0.bottom.trailing.leading.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(18)
        }
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, SectionItem>(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            switch item {
            case .privacyItem(let model):
                cell.configure(setting: model)
            case .darkModeItem(let model):
                cell.configure(setting: model)
            case .informationItem(let model):
                cell.configure(setting: model)
            case .shareItem(let model):
                cell.configure(setting: model)
            }
            return cell
        }
        
    }
    
    func applySnapShot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.privacy, .darkMode, .information, .share])
        snapshot.appendItems(SettingModel.privacy.map{ .privacyItem($0)}, toSection: .privacy)
        snapshot.appendItems(SettingModel.darkMode.map{ .darkModeItem($0)}, toSection: .darkMode)
        snapshot.appendItems(SettingModel.information.map{ .informationItem($0)}, toSection: .information)
        snapshot.appendItems(SettingModel.share.map{ .shareItem($0)}, toSection: .share)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func sendEmail(){
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
            
            // 받는 사람 이메일, 제목, 본문
            composeVC.setToRecipients(["sam98528@gmail.com"])
            composeVC.setSubject("문의 사항")
            composeVC.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeVC, animated: true)
        } else {
            // 만약, 디바이스에 email 기능이 비활성화 일 때, 사용자에게 알림
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
}




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
                print("Information item selected: \(model)")
            case .shareItem(let model):
                if model.menuTitle == "문의하기"{
                    sendEmail()
                }
                print("Share item selected: \(model)")
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 셀의 레이아웃 마진을 조정하여 양옆 인셋을 변경
        
    }
    
    
}


extension SettingViewController {
    enum Section {
        case privacy
        case darkMode
        case information
        case share
    }
    
    enum SectionItem : Hashable{
        case privacyItem(SettingModel)
        case darkModeItem(SettingModel)
        case informationItem(SettingModel)
        case shareItem(SettingModel)
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    // 메일 작성이 끝났을 때, 호출되는 메서드
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
        
        // 자동으로 dismiss가 되지 않으므로, 작업 완료 시 dismiss를 해줘야 함
        self.dismiss(animated: true)
    }
}
