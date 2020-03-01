//
//  PhotoViewController.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-27.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    private enum Constants {
        static let inset: CGFloat = 8.0
        static let minZoomScale: CGFloat = 1/20
        static let maxZoomScale: CGFloat = 1.0
        static let scrollViewHeightProportion: CGFloat = 0.7
        static let minPhotoInfoUIHeight: CGFloat = 20.0
        static let photoInfoUIPortraitSpacing: CGFloat = 12.0
        static let photoInfoUILandscapeSpacing: CGFloat = 0.0
        static let alertTitle = "oops"
    }
    
    private var photoInfoStackViewSpacing: CGFloat = 0.0
    private lazy var imageView = UIImageView()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.minimumZoomScale = Constants.minZoomScale
        sv.maximumZoomScale = Constants.maxZoomScale
        sv.delegate = self
        return sv
    }()
    
    private lazy var photoInfoStackView: UIStackView = {
        let tv = UIStackView()
        tv.backgroundColor = .systemPink
        tv.axis = .vertical
        tv.distribution = .equalSpacing
        tv.spacing = photoInfoStackViewSpacing
        tv.alignment = .fill
        return tv
    }()
    
    private var photoUrl: URL? {
        return URL(string: photoData.largeImageURL)
    }
    
    var photoData: Photo! {
        didSet {
            if let url = URL(string: photoData.largeImageURL) {
                image = nil
                if view.window != nil {
                    fetchImage(url: url)
                }
            }
        }
    }
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /// use this function to adjust content spacing inside `photoInfoStackView`
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        photoInfoStackViewSpacing = size.height > size.width ?
            Constants.photoInfoUIPortraitSpacing :
            Constants.photoInfoUILandscapeSpacing
        photoInfoStackView.spacing = photoInfoStackViewSpacing
    }
    
    /// use this function to adjust content spacing inside `photoInfoStackView`
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let size = UIScreen.main.bounds.size
        photoInfoStackViewSpacing = size.height > size.width
            ? Constants.photoInfoUIPortraitSpacing
            : Constants.photoInfoUILandscapeSpacing
        photoInfoStackView.spacing = photoInfoStackViewSpacing
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let url = URL(string: photoData.largeImageURL) {
            if imageView.image == nil {
                fetchImage(url: url)
            }
        }
    }
    
    private func fetchImage(url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let contents = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    if url == self?.photoUrl {
                        self?.image = UIImage(data: contents)
                        self?.setupPhotoInfoUI()
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    let message = error.localizedDescription
                    self?.showAlert(withTitle: Constants.alertTitle, withMessage: message)
                }
            }
            
        }
    }
}

//MARK: setup ui
extension PhotoViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = photoData.tags
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.insertSubview(spinner, aboveSubview: scrollView)
        spinner.startAnimating()
        
        for v in view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            scrollView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            scrollView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                               multiplier: Constants.scrollViewHeightProportion),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    private func setupPhotoInfoUI() {
        photoInfoStackView.addArrangedSubview(buildStackView(title: "Photographer",
                                                             text: photoData.user))
        photoInfoStackView.addArrangedSubview(buildStackView(title: "Likes",
                                                             text: "\(photoData.likes)"))
        photoInfoStackView.addArrangedSubview(buildStackView(title: "Comments",
                                                             text: "\(photoData.comments)"))
        photoInfoStackView.addArrangedSubview(buildStackView(title: "Favorites",
                                                             text: "\(photoData.favorites)"))
        photoInfoStackView.addArrangedSubview(buildStackView(title: "Downloads",
                                                             text: "\(photoData.downloads)"))
        view.addSubview(photoInfoStackView)
        photoInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoInfoStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                    constant: Constants.inset),
            photoInfoStackView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor,
                                                        constant: Constants.inset),
            photoInfoStackView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor,
                                                         constant: -Constants.inset),
            photoInfoStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.minPhotoInfoUIHeight)
        ])
    }
    
    
    
    private func buildStackView(title: String, text: String) -> UIStackView {
        let sv = UIStackView(text: title, subtext: text)
        sv.distribution = .equalSpacing
        return sv
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
