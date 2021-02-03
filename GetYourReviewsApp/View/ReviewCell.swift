//
//  ReviewCell.swift
//  GetYourReviewsApp
//
//  Created by Smriti on 01.12.20.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var reviewDate: UILabel!
    
    @IBOutlet weak var reviewMessage: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    var reviewViewModel: ReviewViewModel! {
        didSet {
            if let name = reviewViewModel.author?.fullName , let country = reviewViewModel.author?.country {
                author.text = name + ", " + country
            }
            if let date = reviewViewModel.created?.dateFromStr {
                reviewDate.text = date
            }
            reviewMessage.text = reviewViewModel.message!
            rating.text = String(reviewViewModel.rating!).getRatingStars()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension String {
    var dateFromStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let createdDate = dateFormatter.date(from: self) else {
            return ""
        }
        let components = Calendar.current.dateComponents([.day,.month,.year], from: createdDate)
        return "\(String(describing: components.day!))-\(String(describing: components.month!))-\(String(describing: components.year!))"
    }
    
    func getRatingStars() -> String{
        var rating = ""
        if let num = Int(self){
            for _ in 1...num {
                rating = rating + "* "
            }
        }
        return rating
    }
}
