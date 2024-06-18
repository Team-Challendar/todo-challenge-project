import UIKit
// 설정 페이지 데이터 모델 용
struct SettingModel : Hashable {
    var menuTitle: String
    var toggle: Bool?
    var text: String?
    var nextVC: BaseViewController?
}

extension SettingModel {
    static var privacy =
    [
        SettingModel(menuTitle: "알림 설정", toggle: nil, text: nil, nextVC: EmptyViewController()),
        SettingModel(menuTitle: "비밀번호 잠금", toggle: nil, text: nil, nextVC: EmptyViewController())
    ]
    
    static var darkMode =
    [
        SettingModel(menuTitle: "다크 모드", toggle: true, text: nil, nextVC: EmptyViewController()),
    ]
    
    static var information =
    [
        SettingModel(menuTitle: "공지사항", toggle: nil, text: nil, nextVC: NoticeViewController()),
        SettingModel(menuTitle: "앱 버전", toggle: nil, text: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String),
        SettingModel(menuTitle: "오픈소스 라이선스", toggle: nil, text: nil, nextVC: EmptyViewController())
    ]
    
    static var share =
    [
        SettingModel(menuTitle: "친구에게 공유하기", toggle: nil, text: nil, nextVC: EmptyViewController()),
        SettingModel(menuTitle: "문의하기", toggle: nil, text: nil, nextVC: EmptyViewController())
    ]
}
