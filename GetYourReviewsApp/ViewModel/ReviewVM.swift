//
//  ReviewVM.swift
//  GetYourReviewsApp
//
//  Created by Smriti on 01.12.20.
//

import Foundation

struct ReviewViewModel {
    
    var id: Int
    var author: Author?
    var title: String?
    var message: String?
    var rating: Int?
    var created: String?
    var language: String?

    //    Dependency Injection
    init(review: Review) {
        self.id = review.id
        self.author = review.author
        self.title = review.title
        self.message = review.message
        self.rating = review.rating
        self.created = review.created
        self.language = review.language
    }
    
}

