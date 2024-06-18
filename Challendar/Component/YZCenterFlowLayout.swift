//
//  YZCenterFlowLayout.swift
//  Challendar
//
//  Created by 채나연 on 6/4/24.
//

import UIKit

// 아이템 간의 간격을 설정하는 열거형
enum YZCenterFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat) // 고정 간격
    case overlap(visibleOffset: CGFloat) // 겹치는 간격
}

// 애니메이션 모드를 설정하는 열거형
enum YZCenterFlowLayoutAnimation {
    case rotation(sideItemAngle: CGFloat, sideItemAlpha: CGFloat, sideItemShift: CGFloat) // 회전 애니메이션
    case scale(sideItemScale: CGFloat, sideItemAlpha: CGFloat, sideItemShift: CGFloat) // 크기 조정 애니메이션
}

class YZCenterFlowLayout: UICollectionViewFlowLayout {
    
    // 레이아웃 상태 구조체
    fileprivate struct LayoutState {
        var size: CGSize // 컬렉션 뷰 크기
        var direction: UICollectionView.ScrollDirection // 스크롤 방향
        
        // 현재 상태와 다른 상태를 비교하는 함수
        func isEqual(_ otherState: LayoutState) -> Bool {
            return self.size.equalTo(otherState.size) && self.direction == otherState.direction
        }
    }
    
    // 현재 레이아웃 상태를 저장하는 변수
    fileprivate var state = LayoutState(size: CGSize.zero, direction: .horizontal)
    var spacingMode = YZCenterFlowLayoutSpacingMode.fixed(spacing: 10) // 셀 사이 간격 설정
    var animationMode = YZCenterFlowLayoutAnimation.scale(sideItemScale: 0.8, sideItemAlpha: 0.8, sideItemShift: 0.0) // 양옆 셀 크기 설정
    
    // 페이지 너비 계산
    fileprivate var pageWidth: CGFloat {
        switch self.scrollDirection {
        case .horizontal:
            return self.itemSize.width + self.minimumLineSpacing
        case .vertical:
            return self.itemSize.height + self.minimumLineSpacing
        default:
            return 0.0
        }
    }
    
    /// 현재 중심에 위치한 페이지를 계산하는 변수
    var currentCenteredIndexPath: IndexPath? {
        guard let collectionView = self.collectionView else { return nil }
        let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width / 2,
                                           y: collectionView.contentOffset.y + collectionView.bounds.height / 2)
        return collectionView.indexPathForItem(at: currentCenteredPoint)
    }
    
    // 현재 중심에 위치한 페이지 인덱스를 반환
    var currentCenteredPage: Int? {
        return currentCenteredIndexPath?.row
    }
    
    // 레이아웃을 준비하는 함수
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        let currentState = LayoutState(size: collectionView.bounds.size, direction: self.scrollDirection)
        
        if !self.state.isEqual(currentState) {
            self.setupCollectionView()
            self.updateLayout()
            self.state = currentState
        }
    }
    
    // 레이아웃 경계가 변경될 때 레이아웃을 무효화할지 결정하는 함수
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // 주어진 사각형 내의 모든 레이아웃 속성을 반환하는 함수
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    // 스크롤이 끝난 후의 목표 콘텐츠 오프셋을 결정하는 함수
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView, !collectionView.isPagingEnabled,
              let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
        else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let isHorizontal = (self.scrollDirection == .horizontal)
        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedCenterOffset = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted {
                abs($0.center.x - proposedCenterOffset) < abs($1.center.x - proposedCenterOffset)
            }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        } else {
            let closest = layoutAttributes.sorted {
                abs($0.center.y - proposedCenterOffset) < abs($1.center.y - proposedCenterOffset)
            }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }
        
        return targetContentOffset
    }
    
    // 특정 인덱스 페이지로 스크롤하는 함수
    func scrollToPage(atIndex index: Int, animated: Bool = true) {
        guard let collectionView = self.collectionView else { return }

        let proposedContentOffset: CGPoint
        let shouldAnimate: Bool

        switch scrollDirection {
        case .horizontal:
            // 섹션 인셋을 고려하여 아이템을 중심에 두는 올바른 오프셋 계산
            let collectionViewCenter = (collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right) / 2
            let itemCenter = CGFloat(index) * self.pageWidth + self.itemSize.width / 2 + self.sectionInset.left
            let offset = itemCenter - collectionViewCenter
            proposedContentOffset = CGPoint(x: offset - collectionView.contentInset.left, y: collectionView.contentOffset.y)
            shouldAnimate = abs(collectionView.contentOffset.x - offset) > 1 ? animated : false
        case .vertical:
            // 섹션 인셋을 고려하여 아이템을 중심에 두는 올바른 오프셋 계산
            let collectionViewCenter = (collectionView.bounds.size.height - collectionView.contentInset.top - collectionView.contentInset.bottom) / 2
            let itemCenter = CGFloat(index) * self.pageWidth + self.itemSize.height / 2 + self.sectionInset.top
            let offset = itemCenter - collectionViewCenter
            proposedContentOffset = CGPoint(x: collectionView.contentOffset.x, y: offset - collectionView.contentInset.top)
            shouldAnimate = abs(collectionView.contentOffset.y - offset) > 1 ? animated : false
        default:
            print("Default Case...")
            return
        }

        collectionView.setContentOffset(proposedContentOffset, animated: shouldAnimate)
    }
}

// MARK: - Private Methods
private extension YZCenterFlowLayout {
    
    // 컬렉션 뷰 설정 함수
    func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }
    
    // 레이아웃 업데이트 함수
    func updateLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let collectionSize = collectionView.bounds.size
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 3 // 2/3 정도 보이도록 설정
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let side = isHorizontal ? self.itemSize.width : self.itemSize.height
        var scale: CGFloat = 1.0
        switch animationMode {
        case .scale(let sideItemScale, _, _):
            scale = sideItemScale
        default:
            break
        }
        let scaledItemOffset = (side - side * scale) / 2
        
        // 여기를 수정하여 간격을 조정
        let _: CGFloat = 10 // 원하는 간격 값으로 설정
        
        switch self.spacingMode {
        case .fixed(let spacing):
            self.minimumLineSpacing = spacing - scaledItemOffset
        case .overlap(let visibleOffset):
            self.minimumLineSpacing = visibleOffset - scaledItemOffset
        }
    }
    
    // 레이아웃 속성 변환 함수
    func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
        let isHorizontal = (self.scrollDirection == .horizontal)
        let collectionCenter: CGFloat = isHorizontal ? collectionView.frame.size.width / 2 : collectionView.frame.size.height / 2
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance) / maxDistance
        var sideItemShift: CGFloat = 0.0
        
        switch animationMode {
        case .rotation(let sideItemAngle, let sideItemAlpha, let shift):
            sideItemShift = shift
            let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
            attributes.alpha = alpha
            let offsetPercentage = (collectionCenter - normalizedCenter) / collectionCenter
            let rotation = (1 - offsetPercentage) * sideItemAngle
            attributes.transform = CGAffineTransform(rotationAngle: rotation)
        case .scale(let sideItemScale, let sideItemAlpha, let shift):
            sideItemShift = shift
            let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
            let scale = ratio * (1 - sideItemScale) + sideItemScale
            attributes.alpha = alpha
            attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            
            // sideItemAlpha가 1인 경우 scale 기반으로 zIndex 관리
            if sideItemAlpha == 1 {
                attributes.zIndex = Int(scale * 10)
            } else {
                attributes.zIndex = Int(alpha * 10)
            }
        }
        
        let shift = (1 - ratio) * sideItemShift
        
        if isHorizontal {
            attributes.center.y += shift
        } else {
            attributes.center.x += shift
        }
        
        return attributes
    }
}
