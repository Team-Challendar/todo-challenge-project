import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI

class AddTodoTitleViewController: BaseViewController {
    
    let titleLabel = EditTitleLabel(text: "어떤 계획이 생겼나요?")
    let titleView = EmptyView()
    
    let todoTextField = TodoTitleTextField(placeholder: "물 1.5L 마시기")
    let photoButton = AddPhotoButton()
    let confirmButton = CustomButton()
    var dispose = DisposeBag()
    
    var images : [UIImage] = []
    var imageContainer : UICollectionView!
    var selectedImage = -1
    var newTodo : Todo?
    
    override func viewDidLoad() {
//        configureCollectionView()
        configureNavigationBar(checkFirst: true)
        super.viewDidLoad()
    }

//    private func configureCollectionView(){
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: photoSize + 4, height: photoSize + 4)
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 4
//        imageContainer = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        imageContainer.delegate = self
//        imageContainer.dataSource = self
//        imageContainer.translatesAutoresizingMaskIntoConstraints = false
//        imageContainer.backgroundColor = .challendarBlack90
//        imageContainer.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
//        imageContainer.showsVerticalScrollIndicator = false
//        imageContainer.showsHorizontalScrollIndicator = false
//        self.view.addSubview(imageContainer)
//    }
    
    override func configureConstraint(){
        
//       추후 추가 예정 imageContainer, photoButton
        [titleLabel, titleView,confirmButton].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleView.addSubview(todoTextField)
        todoTextField.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(titleToNav)
            $0.bottom.equalTo(titleView.snp.top).inset(-titleToCell)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        titleView.snp.makeConstraints{
            $0.height.equalTo(cellHeight)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
        }
        todoTextField.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(textFieldVerticalPadding)
            $0.leading.trailing.equalToSuperview().inset(textFieldHorizontalPadding)
        }
        
//        photoButton.snp.makeConstraints{
//            $0.height.width.equalTo(photoSize)
//            $0.top.equalTo(titleView.snp.bottom).offset(photoToCell)
//            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(horizontalPadding)
//        }
//        imageContainer.snp.makeConstraints{
//            $0.height.equalTo(68)
//            $0.top.equalTo(titleView.snp.bottom).offset(photoToCell-4)
//            $0.leading.equalTo(photoButton.snp.trailing).offset(photoCellPadding)
//            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(horizontalPadding)
//        }
        confirmButton.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top).offset(-12)
            $0.height.equalTo(buttonHeight)
        }
    }
    
    override func configureUtil(){
        todoTextField.becomeFirstResponder()
        todoTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] changedText in
                if changedText == ""{
                    self?.confirmButton.normalState()
                }else{
                    self?.confirmButton.highLightState()
                }
            })
            .disposed(by: self.dispose)

//        photoButton.rx.tap
//            .subscribe(onNext: { [weak self] _ in
//                self?.photoButtonTapped()
//            })
//            .disposed(by: self.dispose)
        
        confirmButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let text = self?.todoTextField.text else {return}
                self?.newTodo = Todo(title: text, completed: [], images: self?.images)
                let nextVC = AddTodoDateViewController()
                nextVC.newTodo = self?.newTodo
                
                self?.navigationController?.pushViewController(nextVC, animated: false)
            })
            .disposed(by: self.dispose)
        
    }
    
//    private func photoButtonTapped(){
//        if images.count == 5 {
//            let alert = UIAlertController(title: "알림", message: "이미지는 최대 5장까지 첨부할 수 있어요.", preferredStyle: UIAlertController.Style.alert)
//            let defaultAction = UIAlertAction(title: "확인", style: .default,handler: nil)
//            defaultAction.setValue(UIColor.challendarBlue100, forKey: "titleTextColor")
//            alert.addAction(defaultAction)
//            present(alert, animated: true, completion: nil)
//        }else{
//            var configuration = PHPickerConfiguration()
//            configuration.selectionLimit = 5
//            configuration.filter = .any(of: [.images])
//            let picker = PHPickerViewController(configuration: configuration)
//            picker.delegate = self
//            self.selectedImage = -1
//            self.present(picker, animated: true, completion: nil)
//        }
//    }
//    
//    private func photoButtonTappedForEditing(at indexPath: IndexPath) {
//        var configuration = PHPickerConfiguration()
//        configuration.selectionLimit = 1
//        configuration.filter = .any(of: [.images])
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = self
//        self.selectedImage = indexPath.row
//        self.present(picker, animated: true, completion: nil)
//    }
}


//extension AddTodoTitleViewController : PHPickerViewControllerDelegate{
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        let dispatchGroup = DispatchGroup()
//        
//        for result in results {
//            let itemProvider = result.itemProvider
//            
//            if itemProvider.canLoadObject(ofClass: UIImage.self) {
//                dispatchGroup.enter()
//                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
//                    if let error = error {
//                        print("Error loading image: \(error.localizedDescription)")
//                    }
//                    
//                    if let image = image as? UIImage {
//                        if self?.selectedImage == -1 {
//                            self?.images.append(image)
//                        }else{
//                            self?.images[self?.selectedImage ?? 0] = image
//                        }
//                       
//                    }
//                    
//                    dispatchGroup.leave()
//                }
//            }
//        }
//        dispatchGroup.notify(queue: .main) {
//            self.imageContainer.reloadData()
//            self.photoButton.setup(count: self.images.count)
//        }
//    }
//    
//
//}
//
//extension AddTodoTitleViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.images.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = imageContainer.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else{
//            return UICollectionViewCell()
//        }
//        cell.configure(image: images[indexPath.row])
//        cell.deleteButton.rx.tap
//            .subscribe(onNext: { [weak self] _ in
//                self?.images.remove(at: indexPath.row)
//                self?.imageContainer.reloadData()
//
//            })
//            .disposed(by: cell.dispose)
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        photoButtonTappedForEditing(at: indexPath)
//    }
//    
//}
