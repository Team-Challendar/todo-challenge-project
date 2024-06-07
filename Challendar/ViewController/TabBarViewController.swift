//
//  TabBarViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import RAMAnimatedTabBarController

class TabBarViewController: RAMAnimatedTabBarController {
    var tabsItem = [RAMAnimatedTabBarItem(),RAMAnimatedTabBarItem(),RAMAnimatedTabBarItem(),RAMAnimatedTabBarItem(),RAMAnimatedTabBarItem()]
    var navs : [UINavigationController] = []
    var tabs : [TabModel] = [
        TabModel(title: "도전", image: .challenge0,selectedImage: . challenge1, vc: ChallengeListViewController()),
        TabModel(title: "할 일", image: .task0,selectedImage: .task1, vc: TodoViewController()),
        TabModel(title: "계획", image: .plan0,selectedImage: .plan1, vc: TodoCalendarViewController()),
        TabModel(title: "검색", image: .search0,selectedImage: .search1, vc: SearchViewController()),
        TabModel(title: "세부", image: .close0,selectedImage: .close1, vc: ChallengeListDetailViewController()),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure(){
        configureBackground()
        self.navs = createNav(with: tabs)
        self.setViewControllers(self.navs, animated: true)
        guard let items = tabBar.items as? [RAMAnimatedTabBarItem] else { return }
        items.forEach{
            let oldCenter = $0.iconView!.icon.frame.origin.x
            $0.iconView!.icon.frame = CGRect(x: $0.iconView!.icon.frame.origin.x, y: $0.iconView!.icon.frame.origin.y + 2, width: 24, height: 24)
            $0.iconView!.icon.frame.origin.x = oldCenter
        }
        let standard = UITabBarAppearance()
        standard.backgroundColor = .challendarBlack90
        self.tabBar.standardAppearance = standard
        self.tabBar.scrollEdgeAppearance = standard
        self.tabBar.layer.addBorder([.top], color: .challendarTabBorder, width: 0.5)
        
    }
    
    private func createNav(with tabs: [TabModel]) -> [UINavigationController] {
        var navs : [UINavigationController] = []
        for (index, tab) in tabs.enumerated(){
            let nav = UINavigationController(rootViewController: tab.vc)
            tabsItem[index] = RAMAnimatedTabBarItem(title: "", image: tab.image, selectedImage: tab.selectedImage)
            tabsItem[index].animation = CustomBounceAnimation(selectedImage: tab.selectedImage, deSelectedImage: tab.image)
            tabsItem[index].iconColor = .challendarBlack60
            tabsItem[index].textFontSize = 12
            nav.tabBarItem = tabsItem[index]
            nav.tabBarItem.title = tab.title
            navs.append(nav)
        }
        return navs
    }
}
