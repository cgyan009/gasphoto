//
//  PhotoViewModel.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-26.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//

import Foundation

class PhotoViewModel {
    
    private let api = API.shared
    private var nextPageNo = 1
    static private let countOfRecordsPerPage = 20
    var isPullUp = false
    
    private var photoList = [Photo]() {
        didSet {
            NotificationCenter.default.post(name: .photoNotification, object: nil)
        }
    }
    
    var searchKeyWords = "" {
        didSet {
            nextPageNo = 1
            ///once `searchKeyWords` is set
            ///it means a new search,  previous data in `photoList` should be empted
            photoList.removeAll()
            getPhotos()
        }
    }
    
    var photos: [Photo] {
        return photoList
    }
    
    func emptyPhotos() {
        photoList.removeAll()
        searchKeyWords = ""
    }
    
    func getPhotos() {
        //no nextpage
        if nextPageNo == -1 {
            return
        }
        api.fetchData(with: searchKeyWords, pageNo: nextPageNo){ [weak self] (result: Result<PhotoModel, Error>) in
            switch result {
            case .success(let model):
                if model.hits.count == 0 {
                    break
                }
                DispatchQueue.main.async { [weak self] in
                    if model.hits.count < PhotoViewModel.countOfRecordsPerPage {
                        // if total records less than 20, means only 1 page
                        self?.nextPageNo = -1
                    } else {
                        self?.nextPageNo += 1
                    }
                    self?.photoList += model.hits
                    self?.isPullUp = false
                }
            case .failure(let error):
                NotificationCenter.default.post(name: .photoNotification, object: error)
                print(error.localizedDescription)
            }
        }
    }
}
