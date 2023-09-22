//
//  APIService.swift
//  Amare
//
//  Created by Micheal Bingham on 9/17/23.
//

import Foundation

class APIService{
	
	static let shared = APIService()
	
	
	private init() {}
	
	private let baseURL = "https://us-central1-findamare.cloudfunctions.net/predict_traits"

	
	
	
	/// Uses our API that returns traits with probabilites assigned that might correspond with the user's astrological profile information and basic profile

	func predictTraitsFrom(data: UserTraitsData, completion: @escaping (Result<Any, Error>) -> Void) {
			guard let url = URL(string: baseURL) else { return }
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			
			do {
				let jsonData = try JSONEncoder().encode(data)
				request.httpBody = jsonData
			} catch {
				completion(.failure(error))
				return
			}
			
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				if let error = error {
					completion(.failure(error))
					return
				}
				
				guard let data = data else { return }
				do {
					// Decode the response if you have a proper model
					let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
					
					
					if let traitsDictionary = jsonResponse!["traits"] as? [String: String] {
						completion(.success(traitsDictionary))
					} else {
						completion(.failure(GlobalError.unknown))
					}
					
					
					
				} catch {
					completion(.failure(error))
				}
			}.resume()
		}
}


struct UserTraitsData: Codable {
	var name: String
	var gender: String
	var latitude: Double
	var longitude: Double
	var birthdayInSecondsSince1970: Double
	var knowsBirthtime: Bool 
}


