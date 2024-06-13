//
//  BottomSheetViewController.swift
//  Challendar
//
//  Created by Sam.Lee on 5/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BottomSheetViewController: UIViewController {
    var rootViewVC: AddTodoDateViewController?
    var rootViewVC2: EditTodoTitleViewController?
    var dismissCompletion: (() -> Void)?
    var dimmedView = UIView()
    var dateBottomSheet = DateBottomSheet()
    var dispose = DisposeBag()
    var calenderView = DateCalendarView()
    var dateRange : DateRange?
    var newTodo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraint()
        configureUtil()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            dismissCompletion?()
        }
    
    func configureUtil(){
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        dateBottomSheet.delegate = self
        dateBottomSheet.applybutton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.hideLayoutShowChallenge()
            }).disposed(by: self.dispose)
        
        dateBottomSheet.laterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                CoreDataManager.shared.createTodo(newTodo: (self?.newTodo)!)
                let rootView = self?.presentingViewController
                let root = rootView?.presentingViewController
                let successViewController = SuccessViewController()
                successViewController.isChallenge = false
                let navigationController = UINavigationController(rootViewController: successViewController)
                navigationController.modalTransitionStyle = .coverVertical
                navigationController.modalPresentationStyle = .overFullScreen
                self?.dismiss(animated: false, completion: {
                    rootView?.dismiss(animated: false, completion: {
                        root?.present(navigationController, animated: true)
                    })
                })
            })
            .disposed(by: self.dispose)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dateBottomSheet.addGestureRecognizer(panGesture)
        
        calenderView.prevButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.hideCalShowBottom()
            })
            .disposed(by: self.dispose)
        dateBottomSheet.newTodo = self.newTodo
        calenderView.newTodo = self.newTodo
        calenderView.delegate = self
        
    }
    func configureUI(){
        dimmedView.backgroundColor = UIColor.black
        dimmedView.alpha = 0
        
        dateBottomSheet.layer.cornerRadius = 10
        dateBottomSheet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dateBottomSheet.clipsToBounds = true
        dateBottomSheet.dateRange = self.dateRange
        calenderView.layer.cornerRadius = 20
        calenderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dateBottomSheet.applybutton.nonApplyState()
        calenderView.clipsToBounds = true
        
    }
    
    func configureConstraint(){
        [dimmedView, dateBottomSheet,calenderView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        dimmedView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        dateBottomSheet.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(bottomSheetHeight)
            $0.height.equalTo(bottomSheetHeight)
        }
        calenderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset( calendarViewHeight)
            $0.height.equalTo(calendarViewHeight)
        }
        
    }
    private func showLayout(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear,  animations: {
            self.dimmedView.alpha = dimmedViewAlpha
            self.dateBottomSheet.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(0)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideLayout(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState,  animations: {
            self.dimmedView.alpha = 0
            self.dateBottomSheet.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(bottomSheetHeight)
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    private func hideLayoutShowChallenge(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState,  animations: {
            self.dimmedView.alpha = 0
            self.dateBottomSheet.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(bottomSheetHeight)
            }
            self.view.layoutIfNeeded()
            self.dismiss(animated: false)
        }, completion: { _ in
            let challengeCheckViewController = ChallengeCheckViewController()
            challengeCheckViewController.newTodo = self.newTodo
            self.rootViewVC?.present(challengeCheckViewController, animated: true)
        })
    }
    private func hideBottomShowCal(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState,  animations: {
            self.dateBottomSheet.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(bottomSheetHeight)
            }
            self.calenderView.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(0)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    private func hideCalShowBottom(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState,  animations: {
            self.dateBottomSheet.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(0)
            }
            self.calenderView.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(calendarViewHeight)
            }
            self.view.layoutIfNeeded()
        })
    }
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideLayout()
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        switch recognizer.state {
        case .changed:
            let newOffset = min(max(translation.y, 0), CGFloat(bottomSheetHeight))
            dateBottomSheet.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(newOffset)
            }
            self.dimmedView.alpha = (CGFloat(bottomSheetHeight) - newOffset) / CGFloat(bottomSheetHeight) * dimmedViewAlpha
            view.layoutIfNeeded()
            
        case .ended:
            if velocity.y > 1500 || translation.y > CGFloat(bottomSheetHeight) / 2 {
                hideLayout()
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self.dateBottomSheet.snp.updateConstraints {
                        $0.bottom.equalToSuperview().offset(0)
                    }
                    self.dimmedView.alpha = dimmedViewAlpha
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            
        default:
            break
        }
    }
    
    func startDateChanged(data: DateRange) {
        if data == .manual{
            hideBottomShowCal()
        }else{
            self.dateRange = data
            self.newTodo?.startDate = Date().startOfDay()
            self.newTodo?.endDate = data.date
        }
    }
}

extension BottomSheetViewController : DateRangeProtocol {
    func dateSetFromCal(startDate: Date?, endDate: Date?) {
        if let startDate = startDate, let endDate = endDate{
            self.newTodo?.startDate = startDate
            self.newTodo?.endDate = endDate
            NotificationCenter.default.post(name: NSNotification.Name("todo"), object: self.newTodo, userInfo: nil)
            hideLayoutShowChallenge()
        }
    }
    
    func dateRangeChanged(dateRange: DateRange?) {
        if let dateRange = dateRange {
            self.startDateChanged(data : dateRange)
        }
    }
}
