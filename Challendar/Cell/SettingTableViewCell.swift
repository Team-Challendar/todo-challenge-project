//
//  SettingTableViewCell.swift
//  Challendar
//
//  Created by Sam.Lee on 6/13/24.
//

import UIKit
import SnapKit

// 설정화면 Cell
class SettingTableViewCell: UITableViewCell {
    var titleLabel : UILabel!
    var image : UIImageView!
    var toggle : UISwitch!
    var subText: UILabel!
    
    static var identifier = "SettingTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel = nil
        image = nil
        toggle = nil
        subText = nil
    }
    
    func configure(setting: SettingModel){
        self.backgroundColor = .secondary850
        configureTitleLabel(title: setting.menuTitle)
        configureToggle()
        configureSubText(text: setting.text ?? "")
        configureImage()
        configureConstraints(setting: setting)
    }
    
    
    func configureConstraints(setting: SettingModel){
        [titleLabel,image,toggle,subText].forEach{
            self.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        image.snp.makeConstraints{
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints{
            $0.width.equalTo(51)
            $0.height.equalTo(31)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        subText.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
        }
        if let _ = setting.toggle {
            self.toggle.isHidden = false
            self.toggle.isEnabled = true
        }else if let _ = setting.text {
            self.subText.isHidden = false
            self.subText.isUserInteractionEnabled = true
        }else{
            self.image.isHidden = false
            self.image.isUserInteractionEnabled = true
        }
    }
    func configureTitleLabel(title : String){
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .pretendardMedium(size: 17)
        titleLabel.textColor = .challendarWhite
    }
    
    func configureImage(){
        image = UIImageView()
        image.image = .arrowRight
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.isHidden = true
        image.isUserInteractionEnabled = false
    }
    
    func configureToggle(){
        toggle = UISwitch()
        toggle.onTintColor = .alertEmerald
        toggle.isHidden = true
        toggle.isEnabled = false
    }
    
    func configureSubText(text : String){
        subText = UILabel()
        subText.text = text
        subText.font = .pretendardMedium(size: 16)
        subText.textColor = .secondary500
        subText.isHidden = true
        subText.isUserInteractionEnabled = false
    }
}
