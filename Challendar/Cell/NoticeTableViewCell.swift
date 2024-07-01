//
//  NoticeTableViewCell.swift
//  Challendar
//
//  Created by Sam.Lee on 6/14/24.
//

import UIKit
import SnapKit
import MarkdownView

class NoticeTableViewCell: UITableViewCell {
    var topContainer = UIView()
    var dateLabel = UILabel()
    var titleLabel = UILabel()
    var bottomContainer = MarkdownView()
    
    static var identifier = "NoticeTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(notice: NoticeModel){
        topContainer.backgroundColor = .secondary850
        
        titleLabel.text = notice.title
        titleLabel.font = .pretendardMedium(size: 18)
        titleLabel.textColor = .challendarWhite
        
        dateLabel.text = formatDate(notice.timeStamp)
        dateLabel.font = .pretendardMedium(size: 12)
        dateLabel.textColor = .secondary500
        
        
        bottomContainer.backgroundColor = .secondary850
        
        [topContainer, bottomContainer].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [titleLabel,dateLabel].forEach{
            topContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        topContainer.snp.makeConstraints{
            $0.height.equalTo(75)
            $0.trailing.leading.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        dateLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        bottomContainer.snp.makeConstraints{
            $0.top.equalTo(topContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
      
        if notice.isopen {
            bottomContainer.isHidden = false
        }else{
            bottomContainer.isHidden = true
        }
        bottomContainer.load(markdown: notice.content)
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "날짜 없음" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        return dateFormatter.string(from: date)
    }
}
