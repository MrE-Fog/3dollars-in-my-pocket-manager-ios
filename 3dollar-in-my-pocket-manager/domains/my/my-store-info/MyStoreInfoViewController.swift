import UIKit

final class MyStoreInfoViewController: BaseViewController {
    private let myStoreInfoView = MyStoreInfoView()
    
    static func instance() -> MyStoreInfoViewController {
        return MyStoreInfoViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.myStoreInfoView
    }
    
    override func viewDidLoad() {
        self.myStoreInfoView.collectionView.dataSource = self
        self.myStoreInfoView.collectionView.delegate = self
    }
}

extension MyStoreInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyStoreInfoOverviewCell.registerId,
                for: indexPath
            ) as? MyStoreInfoOverviewCell else { return BaseCollectionViewCell() }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyStoreInfoIntroductionCell.registerId,
                for: indexPath
            ) as? MyStoreInfoIntroductionCell else { return BaseCollectionViewCell() }
            
            return cell
        }
    }
}

extension MyStoreInfoViewController: UICollectionViewDelegate {
    
}
