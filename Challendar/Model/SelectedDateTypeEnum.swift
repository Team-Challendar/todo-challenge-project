import Foundation

enum SelectedDateType {
    case singleDate    // 날짜 하나만 선택된 경우 (원 모양 배경)
    case firstDate    // 여러 날짜 선택 시 맨 처음 날짜
    case middleDate // 여러 날짜 선택 시 맨 처음, 마지막을 제외한 중간 날짜
    case lastDate   // 여러 날짜 선택시 맨 마지막 날짜
    case notSelected // 선택되지 않은 날짜
}
