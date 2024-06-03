import UIKit

struct TodoModel2 {
    var name: String                    // 
    var description: String?
    var startDate: Date?
    var endDate: Date?
    var totalDays: Int?
    var dailyCompletionStatus: [Bool?]?
    var isChallenge: Bool?
    var progress: Double?
    var image: UIImage?
}

// 날짜를 생성하는 함수
func createDate(year: Int, month: Int, day: Int) -> Date? {
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return calendar.date(from: components)
}

// 더미 데이터 생성
let todo1 = TodoModel2(
    name: "스위프트 배우기",
    description: "Udemy에서 스위프트 프로그래밍 과정 완료하기",
    startDate: createDate(year: 2024, month: 6, day: 2),
    endDate: createDate(year: 2024, month: 6, day: 22),
    totalDays: 30,
    dailyCompletionStatus: [true, false, true, true, true, nil, false],
    isChallenge: true,
    progress: 1.0,
    image: UIImage(named: "swift")
)

let todo2 = TodoModel2(
    name: "책 읽기",
    description: "'아주 작은 습관의 힘' 읽기",
    startDate: createDate(year: 2024, month: 4, day: 10),
    endDate: createDate(year: 2024, month: 4, day: 24),
    totalDays: 14,
    dailyCompletionStatus: Array(repeating: nil, count: 14),
    isChallenge: false,
    progress: 1.0,
    image: UIImage(named: "book")
)

let todo3 = TodoModel2(
    name: "운동 - 유산소",
    description: "아침에 20분 동안 달리기",
    startDate: createDate(year: 2024, month: 5, day: 1),
    endDate: createDate(year: 2024, month: 5, day: 7),
    totalDays: 7,
    dailyCompletionStatus: [true, true, true, true, true, nil, false],
    isChallenge: true,
    progress: 1.0,
    image: UIImage(named: "exercise")
)

let todo4 = TodoModel2(
    name: "명상",
    description: "매일 10분 명상하기",
    startDate: createDate(year: 2024, month: 4, day: 10),
    endDate: createDate(year: 2024, month: 5, day: 10),
    totalDays: 30,
    dailyCompletionStatus: [true, false, true, true, true, nil, false],
    isChallenge: true,
    progress: 0.4,
    image: UIImage(named: "meditation")
)

let todo5 = TodoModel2(
    name: "프로젝트 작업",
    description: "클라이언트 프로젝트 완료하기",
    startDate: createDate(year: 2024, month: 6, day: 1),
    endDate: createDate(year: 2024, month: 6, day: 14),
    totalDays: 20,
    dailyCompletionStatus: Array(repeating: nil, count: 20),
    isChallenge: false,
    progress: 0.0,
    image: UIImage(named: "project")
)

let todo6 = TodoModel2(
    name: "운동 - 하체",
    description: "어덕션 3set, 스탠딩 어브덕션 3set, 하이바 스쿼트 4set, 글루트 3set, 레그컬 3set, 덤벨스티프 3set",
    startDate: createDate(year: 2024, month: 5, day: 1),
    endDate: createDate(year: 2024, month: 5, day: 7),
    totalDays: 7,
    dailyCompletionStatus: [true, true, nil, false, true, nil, false],
    isChallenge: true,
    progress: 1.0,
    image: UIImage(named: "exercise")
)

// 더미 데이터 배열
let todos = [todo1, todo2, todo3, todo4, todo5, todo6]
