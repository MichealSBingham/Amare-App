//
//  APIService.swift
//  Amare
//
//  Created by Micheal Bingham on 9/17/23.
//

import Foundation


struct UserTraitsData: Codable {
	var name: String
	var gender: String
	var latitude: Double
	var longitude: Double
	var birthdayInSecondsSince1970: Double
	var knowsBirthtime: Bool 
}

struct PlacementReadData: Codable {
    var gender: String?
    var planet: String
    var sign: String
    var house: String?
    var user_id: String?
}


enum APIEndpoint: String {
    case predictTraits = "/predict_traits"
    case placementRead = "/placement_read"
}



class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    private let baseDomain = "https://us-central1-findamare.cloudfunctions.net"
    
    private func constructURL(for endpoint: APIEndpoint) -> URL? {
        return URL(string: baseDomain + endpoint.rawValue)
    }
    
    func predictTraitsFrom(data: UserTraitsData, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = constructURL(for: .predictTraits) else { return }
        
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
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let traitsDictionary = jsonResponse?["traits"] as? [String: String] {
                    completion(.success(traitsDictionary))
                } else {
                    completion(.failure(GlobalError.unknown))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getPlacementRead(data: PlacementReadData, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = constructURL(for: .placementRead) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        
        do {
            let jsonData = try encoder.encode(data)
            print("\n\n\n*****THE PLACEMENT READ DATA SENT TO THE API IS \(jsonData)")
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            print("some error happened trying to getPlacementRead \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("some error happened trying to getPlacementRead \(error)")
                return
            }
            
            guard let data = data else { return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Did get a response ..")
                if let interpretation = jsonResponse?["interpretation"] as? String {
                    completion(.success(interpretation))
                } else if let errorMessage = jsonResponse?["error"] as? String {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } else {
                    completion(.failure(GlobalError.unknown))
                }
                
            } catch {
                completion(.failure(error))
                print("Did get an error \(error) ..")
            }
        }.resume()
    }
    
    

    
    
    
    

}
