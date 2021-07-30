//
//  ViewController.swift
//  photo-list-tableview
//
//  Created by Mark bergeson on 7/9/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var photoDatasource = [PhotoList]()
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = UIColor.black
        control.addTarget(self, action: #selector(loadPhotoDataSource), for: .valueChanged)
        control.attributedTitle = NSAttributedString(string: "Loading Posts...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return control
    }()
    
    private let viewModel = PhotoDatasource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadDatasource()
        // Do any additional setup after loading the view.
    }

}

private extension ViewController {
    
    func setupView() {
        viewModel.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 112.0
        tableView.register(UINib(nibName: "PhotoListCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoListCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.refreshControl = refreshControl
        
    }
    
    @objc
    func loadPhotoDataSource() {
        viewModel.refreshPhotos()
    }
    
    func loadDatasource() {
        viewModel.fetchPhotos()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoListCell", for: indexPath)
        
        if let cell = cell as? PhotoListCellTableViewCell {
            if isLoadingCell(for: indexPath) {
                cell.configure(photoList: nil)
            } else {
                cell.configure(photoList: self.viewModel.photo(at: indexPath.row))
            }
        }
        return cell
    }
    
    
    
}

extension ViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    if indexPaths.contains(where: isLoadingCell) {
      viewModel.fetchPhotos()
    }
  }
}

extension ViewController: PhotoDatasourceDelegate {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
    // 1
    guard let newIndexPathsToReload = newIndexPathsToReload else {
      tableView.isHidden = false
      tableView.reloadData()
        refreshControl.endRefreshing()
      return
    }
    // 2
    let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
    tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    refreshControl.endRefreshing()
  }
  
  func onFetchFailed(with reason: String) {
    
  }
}

private extension ViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
