//
//  MarvelDetail.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/13.
//

import Foundation

struct MarvelDetail: Codable {
    let data: ComicsClass
}

struct ComicsClass: Codable {
    let results: [ComicsDetail]
}

struct ComicsDetail: Codable {
    let title: String
    let thumbnail: Thumbnail
}
