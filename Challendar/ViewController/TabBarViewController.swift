//
//  TabBarViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/30/24.
//

import UIKit
import RAMAnimatedTabBarController

class TabBarViewController: RAMAnimatedTabBarController {
    var tabsItem = [RAMAnimatedTabBarItem(),RAMAnimatedTabBarItem(),RAMAnimatedTabBarItem(),RAMAnimatedTabBarItem()]
    var navs : [UINavigationController] = []
    var tabs : [TabModel] = [
        TabModel(title: "챌린지", image: UIImage(systemName: "flag")!,selectedImage:UIImage(systemName: "flag.fill")!, vc: ChallengeListViewController()),
        TabModel(title: "투두", image: UIImage(systemName: "flag")!,selectedImage:UIImage(systemName: "flag.fill")!, vc: TodoViewController()),
        TabModel(title: "투두캘린더", image: UIImage(systemName: "flag")!,selectedImage:UIImage(systemName: "flag.fill")!, vc: TodoCalandarViewController()),
        TabModel(title: "검색", image: UIImage(systemName: "flag")!,selectedImage:UIImage(systemName: "flag.fill")!, vc: SearchViewController()),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
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
            tabsItem[index].textFontSize = 5
            nav.tabBarItem = tabsItem[index]
            nav.tabBarItem.title = nil
            navs.append(nav)
        }
        return navs
    }
}
