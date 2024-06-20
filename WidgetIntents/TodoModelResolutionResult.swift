//
//  TodoModelResolutionResult.swift
//  Challendar
//
//  Created by 채나연 on 6/20/24.
//

import Intents

@available(iOS 13.0, *)
class TodoModelResolutionResult: INIntentResolutionResult {
    // 성공적인 해결 결과를 반환하는 함수
    override class func success(with resolvedTodo: Todo) -> Self {
        return super.success(with: resolvedTodo) as! Self
    }

    // 해결 값이 필요함을 나타내는 결과를 반환하는 함수
    override class func needsValue() -> Self {
        return super.needsValue() as! Self
    }

    // 해결 값이 필요하지 않음을 나타내는 결과를 반환하는 함수
    override class func notRequired() -> Self {
        return super.notRequired() as! Self
    }

    // 지원되지 않음을 나타내는 결과를 반환하는 함수
    override class func unsupported(forReason reason: Int) -> Self {
        return super.unsupported(forReason: reason) as! Self
    }
}





