//
//  NoticeViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 6/14/24.
//

import UIKit
import SnapKit
import WebKit

class NoticeViewController: BaseViewController {
    var noticesList : [NoticeModel] = []
    var isExpaned : [Bool] = []
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, SectionItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDateFromCloudKit()
        configureBackAndTitleNavigationBar(title: "공지사항", checkSetting: false)
    }
    
    func fetchDateFromCloudKit(){
        CloudKitManager.shared.fetchData(completion: { notices in
            DispatchQueue.main.async {
                self.noticesList = notices
                self.isExpaned = Array(repeating: false, count: notices.count)
                self.configureTableView()
            }
        })
    }
    
    func configureTableView(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.bottom.trailing.leading.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(18)
        }
    }

}

extension NoticeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if noticesList[indexPath.row].isopen {
            return 375
        }else{
            return 75
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as? NoticeTableViewCell else { return UITableViewCell()}
        cell.configure(notice: noticesList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noticesList[indexPath.row].isopen.toggle()
        tableView.reloadData()
    }

}


extension NoticeViewController {
    enum Section {
        case notice
    }
    
    enum SectionItem : Hashable{
        case noticeItem(NoticeModel)
    }
}
