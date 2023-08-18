//
//  ViewController.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addProductBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var workItem: DispatchWorkItem?
    var refreshControl = UIRefreshControl()
    var productViewModal = ProductViewModal()

    override func viewDidLoad() {
        super.viewDidLoad()
        regsiterCell()
        setUpSearchBar()
        tableViewRefresh()
        setRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductList()
    }
    
    func regsiterCell(){
        self.tableView.register(UINib(nibName: "ProductListViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProductListViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addProductBtn.layer.cornerRadius = 10.0
    }
    
    func setRefreshControl(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func tableViewRefresh(){
        productViewModal.refreshTableData = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }

    func setUpSearchBar(){
        searchBar.delegate = self
        searchBar.placeholder = "Search by product name"
    }
    
    func getProductList(){
        self.productViewModal.getProductList {
        }
    }
    
    func getListData(searchText: String){
        ///Mark :- I have added this Dispatch work Item concept to cancel all the previous search key and get at last complete string. So that our api call will be optimized.
        workItem?.cancel()
        let newWorkItem = DispatchWorkItem{
            print(searchText)
            self.productViewModal.getSearchProduct(searchText: searchText)
        }
        workItem = newWorkItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(400), execute: newWorkItem)
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController{
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getProductList()
    }

}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productViewModal.filteredProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListViewCell", for: indexPath) as? ProductListViewCell else{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if self.productViewModal.filteredProduct.count > indexPath.row{
            cell.setData(data: self.productViewModal.filteredProduct[indexPath.row])
        }
       
        return cell
    }
}

extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let textToSearch = searchBar.text else {
            return
        }
    
        getListData(searchText: textToSearch)
    }
    
}
