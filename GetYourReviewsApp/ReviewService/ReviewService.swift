//
//  ReviewService.swift
//  GetYourReviewsApp
//
//  Created by Smriti on 01.12.20.
//

import Foundation

enum ReviewReqError: Error {
    case cannotProcessResponse
    case noDataAvailable
    case someThingWentWrong(errorDescription: String?)
}
struct ReviewServiceCustomError: Error {
    let errorDescription: String?
}

class ReviewService {
    
    var isPaginating = false
    
    func fetchReviewsFor(pagination: Bool = false,sortOption:String,limit: Int,offset: Int, completion: @escaping (Result<ReviewInfo,Error>) -> Void){
        if pagination {
            isPaginating = true
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: { [self] in

            guard let sourceUrl = URL(string: "\(Constants.baseURL)?sort=\(sortOption):DESC&limit=\(limit)&offset=\(offset)") else {
            return
        }
        let datatask = URLSession.shared.dataTask(with: sourceUrl, completionHandler: { data,response,error in
            
            if pagination { //Check if pagination is happening
                self.isPaginating = false //set false to prevent another request while one is already requested
            }
            guard let jsonData = data else {
                completion(.failure(ReviewReqError.noDataAvailable))
                return
            }
            
            if let serverResponse = response as? HTTPURLResponse{
             if serverResponse.statusCode == 200 {//status code is OK,proceed with decoding
                do {
                let responseData = try JSONDecoder().decode(ReviewInfo.self, from: jsonData)
                    if responseData.reviews?.count == 0 { //Empty reviews returned
                        completion(.failure(ReviewServiceCustomError(errorDescription: "No reviews Found")))
                    }else{
                        completion(.success(responseData))
                    }
                    } catch(let error) {
                        completion(.failure(error))
                    }
                
            } else { //Status code for other cases,sending error with Result enum
                do {
                    
                let responseData = try JSONDecoder().decode(ReviewServiceError.self, from: jsonData)
                    completion(.failure(ReviewServiceCustomError(errorDescription: responseData.title)))
                    } catch(let error) {
                        completion(.failure(error))
                    }
                    }
            }
        })
        datatask.resume()
        })
    }
}
