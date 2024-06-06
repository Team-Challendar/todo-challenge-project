//
//  DropdownButtonView.swift
//  Challendar
//
//  Created by 채나연 on 6/6/24.
//

import UIKit

protocol DropdownButtonViewDelegate: AnyObject {
    func didSelectOption(_ option: String)
}

class DropdownButtonView: UIView {
    
    weak var delegate: DropdownButtonViewDelegate?
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendardMedium(size: 14)
        button.tintColor = .challendarBlack60
        
        // Create the chevron.down image with a smaller size
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let chevronImage = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        
        button.setImage(chevronImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private let options = ["기한임박", "등록순", "최신순"]
    private var tableView: UITableView!
    private var isOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    @objc private func toggleDropdown() {
        isOpen.toggle()
        tableView.isHidden = !isOpen
        tableView.snp.updateConstraints { make in
            make.height.equalTo(isOpen ? 132 : 0)
        }
    }
}

extension DropdownButtonView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        button.setTitle(option, for: .normal)
        isOpen = false
        tableView.isHidden = true
        tableView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        delegate?.didSelectOption(option)
    }
}

