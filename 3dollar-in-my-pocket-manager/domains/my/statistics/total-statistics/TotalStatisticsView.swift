import UIKit

final class TotalStatisticsView: BaseView {
    let tableView = UITableView().then {
        $0.tableFooterView = UIView()
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 24
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
        $0.layer.shadowColor = UIColor(r: 0, g: 198, b: 103).cgColor
        $0.layer.shadowOpacity = 0.04
        $0.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        $0.register(
            TotalStatisticsTableViewCell.self,
            forCellReuseIdentifier: TotalStatisticsTableViewCell.registerId
        )
        $0.rowHeight = TotalStatisticsTableViewCell.height
        $0.isScrollEnabled = false
    }
    
    override func setup() {
        self.addSubViews([
            self.tableView
        ])
    }
    
    override func bindConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    func calculatorTableViewHeight(itemCount: Int) -> CGFloat {
        let height = TotalStatisticsTableViewCell.height * CGFloat(itemCount) + 16
        
        self.tableView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        return height
    }
}
