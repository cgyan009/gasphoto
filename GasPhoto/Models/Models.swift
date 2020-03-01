//
//  Models.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-29.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//

import Foundation

struct PhotoModel: Decodable {
    let totalHits: Int
    let total: Int
    let hits: [Photo]
}

struct Photo: Decodable {
    let id: Int
    let largeImageURL: String
    let previewURL: String
    let tags: String
    let comments: Int
    let user: String
    let likes: Int
    let downloads: Int
    let favorites: Int
}
