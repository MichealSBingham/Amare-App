//
//  tokens.swift
//  Amare
//
//  Created by Micheal Bingham on 7/27/22.
//

import Foundation

let API_BASE_URL = "https://us-central1-findamare.cloudfunctions.net"

let token_endpoint = "/messaging_token"

class MessagingAPI {
	
	public static func getToken(userId: String?, completion: @escaping (_ error: Error?, _ token: String? ) -> ())  {
		
		guard let userId = userId else {
			completion(MessagingAPIError.noUserID, nil )
			return
		}
		
		let json: [String: String] = ["userId": userId]

		let jsonData = try? JSONSerialization.data(withJSONObject: json)
		
		print("The json data is .. \(json)")
		
		let url = URL(string: API_BASE_URL+token_endpoint)!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		//request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
		request.httpBody = jsonData
		
		

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			
			
			print("\n\n\n\n\n\n\n\n\n\nThe request: .. \(request) , the body: \(request.httpBody) and data \(data) and response \(response) and error \(error) ")
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "No data")
				completion(error!, nil)
				return
			}
			let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
			if let responseJSON = responseJSON as? [String: Any] {
				print(responseJSON)
				
				if let dataDict = responseJSON["data"] as? [String: Any] {
						// access nested dictionary values by key
					
					guard let token = dataDict["token"] as? String else {
						
						
						completion(MessagingAPIError.unknown, nil)
						
						return
					}
					
					DispatchQueue.main.async {
						completion(nil, token )
					}
					
					
					return
					}
				
				else{
					completion(MessagingAPIError.unknown, nil)
					return
				}
				
			
			} else {
			
				completion(MessagingAPIError.unknown, nil )
				return
			}
		}

		task.resume()
		
		return
	}

}

enum MessagingAPIError: Error{
	case noUserID
	case unknown
}
