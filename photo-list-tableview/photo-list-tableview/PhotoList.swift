//
//  PhotoList.swift
//  photo-list-tableview
//
//  Created by Mark bergeson on 7/11/21.
//

import Foundation

struct PhotoList: Codable {
    let created_at: String
    let id: String
    let alt_description: String?
    let urls: photoListUrl
}

struct photoListUrl: Codable {
    let regular: String
    let small: String
}
