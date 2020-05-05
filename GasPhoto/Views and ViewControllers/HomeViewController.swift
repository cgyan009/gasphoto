//
//  HomeViewController.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-26.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    private enum Constants {
        static let cellId = "photoCell"
        static let cellHeight: CGFloat = 56.0
        static let title = "Photos"
        static let placeholderMessage = "Search Photos"
        static let cellImageViewSize = CGSize(width: 48.0, height: 48.0)
        static let alertTitle = "oops"
        static let placeholderImage = "image_placeholder"
    }
    private lazy var viewModel = PhotoViewModel()
    private lazy var photosTable: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = Constants.placeholderMessage
        search.searchBar.delegate = self

        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(listen(notification:)),
            name: .photoNotification,
            object: nil
        )
        setupUI()
        viewModel.getPhotos()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        viewModel.emptyPhotos()
    }
    //listen to NotificationCenter
    @objc func listen(notification: Notification) {
        if let error = notification.object as? Error {
            showAlert(withTitle: Constants.alertTitle,
                      withMessage: error.localizedDescription)
            print(error.localizedDescription)
        } else {
            photosTable.reloadData()
        }
    }
    
    private func searchPhotos() {
        guard let searchString = searchController.searchBar.text else {
              return
          }
          let trimmedSearchString = searchString.trimmingCharacters(in: .whitespaces)
          if trimmedSearchString != Constants.placeholderMessage {
              viewModel.searchKeyWords = trimmedSearchString
          }
      }
}

//MARK: setup ui
extension HomeViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = Constants.title
        navigationItem.searchController = searchController
        
        photosTable.delegate = self
        photosTable.dataSource = self
        photosTable.register(PhotoCell.self, forCellReuseIdentifier: Constants.cellId)
        
        view.addSubview(photosTable)
        for v in view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photosTable.topAnchor.constraint(equalTo: view.safeTopAnchor),
            photosTable.bottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            photosTable.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            photosTable.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor)
        ])
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
        let photo = viewModel.photos[indexPath.row]
        
        if let url = URL(string: photo.previewURL) {
            cell.imageView?.kf.setImage(with: url,
                                        placeholder: UIImage(named: Constants.placeholderImage))
            cell.imageView?.sizeThatFits(Constants.cellImageViewSize)
        }
        cell.textLabel?.text = photo.tags
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    //implement fetching new records via scrollup
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        if row < 0 || section < 0 {
            return
        }
        let count = tableView.numberOfRows(inSection: section)
        if row == (count - 1) && !viewModel.isPullUp {
            viewModel.isPullUp = true
            viewModel.getPhotos()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = viewModel.photos[indexPath.row]
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if let navigationController = window?.rootViewController as? UINavigationController {
            let photoViewController = PhotoViewController()
            photoViewController.photoData = selectedPhoto
            navigationController.pushViewController(photoViewController, animated: true)
        }
    }
}

//MARK: UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchPhotos()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearch()
    }
}
