//
//  AssetsEditVC.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class AssetsListVC: UIViewController {
    //MARK: - Properties
    private let assetsListView: AssetsListView = AssetsListView()
    private let assetsCoreDataManager: AssetsCoreDataManager = AssetsCoreDataManager()
    private var assetsList: [AssetsList] = []
    
    // MARK: - ViewController Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = assetsListView
        self.navigationItem.title = "나의 자산 목록"
        setAddButton()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        setAssetsData()
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    private func setupTableView() {
        assetsListView.tableView.delegate = self
        assetsListView.tableView.dataSource = self
        assetsListView.tableView.register(AssetsListHeaderView.self, forHeaderFooterViewReuseIdentifier: "AssetsListHeaderView")
        assetsListView.tableView.register(AssetsListCell.self, forCellReuseIdentifier: "AssetsListCell")
    }
    
    private func setAddButton() {
        assetsListView.addButton.target = self
        assetsListView.addButton.action = #selector(addButtonTapped)
        navigationItem.rightBarButtonItem = assetsListView.addButton
    }
    
    private func setAssetsData() {
        let assetsItems: [AssetsItem] = assetsCoreDataManager.selectAllAssets().map {
            AssetsItem(uuid: $0.key, category: $0.category, title: $0.title, amount: $0.amount, note: $0.note)
        }
        
        let items = Dictionary(grouping: assetsItems, by: { $0.category })

        // 각 category에 대한 AssetsList 생성
        var assetsList: [AssetsList] = []

        for (category, items) in items {
            let list = AssetsList(title: category ?? "Error", items: items)
            assetsList.append(list)
        }
        
        self.assetsList = assetsList
        assetsListView.tableView.reloadData()
    }
    
    private func setSectionAmount(forSection section: Int) -> String {
        let total = assetsList[section].items.reduce(0) { sum, item in
            return sum + Int64(item.amount)
        }
        return "\(KoreanCurrencyFormatter.shared.string(from: total)) 원"
    }
    
    private func deleteAssets() {
//        if let uuid = uuid {
//            assetsCoreDataManager.deleteAssets(uuid: uuid)
//        } else {
//            print("유효한 자산이 아닙니다.")
//        }
    }
    
    // 뒤로가기전에 차트를 다시 그려주는 메서드
    private func popupViewController() {
//        if let mainPageVC = navigationController?.viewControllers.last(where: { $0 is MainPageVC }) as? MainPageVC {
//            
//            mainPageVC.setChartData()
//            
//            navigationController?.popViewController(animated: true)
//        } else {
//            // MainPageVC가 네비게이션 스택에 없는 경우 처리
//            print("MainPageVC를 찾을 수 없습니다.")
//        }
    }

    
    // MARK: - Objc
    @objc func addButtonTapped() {
//        saveAssets()
//        popupViewController()
        self.navigationController?.pushViewController(AssetsEditVC(), animated: true)
    }
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AssetsListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return assetsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetsList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = assetsList[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetsListCell", for: indexPath) as! AssetsListCell
  
        cell.assets = list.items[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assetsEditVC = AssetsEditVC()
        assetsEditVC.uuid = assetsList[indexPath.section].items[indexPath.row].uuid
        self.navigationController?.pushViewController(assetsEditVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension AssetsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AssetsListHeaderView") as? AssetsListHeaderView else {
            return UITableViewHeaderFooterView()
        }
        
        headerView.titleLabel.text = assetsList[section].title
        headerView.amountLabel.text = setSectionAmount(forSection: section)
        
        switch section {
        case 0:
            headerView.backgroundView?.backgroundColor = UIColor(hex: "#3FB6DC")
        case 1:
            headerView.backgroundView?.backgroundColor = UIColor(hex: "#2DC76D")
        case 2:
            headerView.backgroundView?.backgroundColor = UIColor(hex: "#FF7052")
        default:
            headerView.backgroundView?.backgroundColor = .lightGray
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
