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
        setupNotificationCenter()
    }
    
    func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(startDateChanged), name: NSNotification.Name("dateRange"), object: dateRange)
    }
    
    func configureUtil(){
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        dateBottomSheet.applybutton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.hideLayout()
            }).disposed(by: self.dispose)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dateBottomSheet.addGestureRecognizer(panGesture)
        
        calenderView.prevButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.hideCalShowBottom()
            })
            .disposed(by: self.dispose)
        
    }
    func configureUI(){
        dimmedView.backgroundColor = UIColor.challendarBlack90.withAlphaComponent(dimmedViewAlpha)
        dimmedView.alpha = 0
        [dimmedView, dateBottomSheet,calenderView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        dateBottomSheet.layer.cornerRadius = 10
        dateBottomSheet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        dateBottomSheet.clipsToBounds = true
        
        calenderView.layer.cornerRadius = 20
        calenderView.clipsToBounds = true

    }
    
    func configureConstraint(){
        dimmedView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        dateBottomSheet.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(bottomSheetHeight)
            $0.height.equalTo(bottomSheetHeight)
        }
        calenderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(14 + calendarViewHeight)
            $0.height.equalTo(calendarViewHeight)
        }
        
    }
    private func showLayout(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear,  animations: {
            self.dimmedView.alpha = 1
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
    private func hideBottomShowCal(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState,  animations: {
            self.dateBottomSheet.snp.updateConstraints{
                $0.bottom.equalToSuperview().offset(bottomSheetHeight)
            }
            self.calenderView.snp.updateConstraints{
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(14)
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
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(14 + calendarViewHeight)
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
    
    @objc func startDateChanged(notification : Notification) {
        guard let data = notification.object as? DateRange else {return}
        if data == .manual{
            hideBottomShowCal()
        }
    }
}
