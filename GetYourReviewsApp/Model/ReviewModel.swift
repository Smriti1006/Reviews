//
//  ReviewModel.swift
//  GetYourReviewsApp
//
//  Created by Smriti on 01.12.20.
//

import Foundation

struct ReviewInfo : Decodable {
    var reviews: [Review]?
    var totalCount: Int
    var pagination: Pagination
}
struct Pagination: Decodable {
    var limit: Int
    var offset: Int
}
struct Review: Decodable {
    var id: Int
    var author: Author?
    var title: String?
    var message: String?
    var rating: Int?
    var created: String?
    var language: String?
}

struct Author: Decodable {
    var fullName: String?
    var country: String?
}

struct ReviewServiceError: Decodable {
    var title: String?
    var type: String?
    var status: Int?
    var detail: String?
    
}
