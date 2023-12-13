//
//  APIService.swift
//  Amare
//
//  Created by Micheal Bingham on 9/17/23.
//

import Foundation
import Firebase

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
    var type: String
    var house: String?
    var user_id: String?
}


struct AspectReadData: Codable {
    var gender: String
    var planet1: String
    var planet2: String
    var name: String
    var orb: Double
    var type: String
    var user_id: String
    var requesting_user_id: String
}

struct TellMeAboutReadData: Codable {
    var requestingUserID: String
    var targetUserID: String
}


enum APIEndpoint: String {
    case predictTraits = "/predict_traits"
    case placementRead = "/placement_read"
    case predictStatements = "/predict_statements"
    case messageDasha = "/message_dasha"
    case aspect_read = "/aspect_read"
    case tell_me_about = "/tell_me_about"
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
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 300.0)
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
    
    func predictStatements(from data: UserTraitsData, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = constructURL(for: .predictStatements) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 300.0)
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
                
                if let statements = jsonResponse?["statements"] as? [String] {
                    completion(.success(statements))
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
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 300.0)
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
    
    
    func getAspectRead(data: AspectReadData, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = constructURL(for: .aspect_read) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 300.0)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        
        do {
            let jsonData = try encoder.encode(data)
            print("\n\n\n*****THE Aspect READ DATA SENT TO THE API IS \(jsonData)")
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
                print("Did get a response .. \(jsonResponse)")
             
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
    
    func messageDasha( message: String, completion: @escaping (Result<Any, Error>) -> Void = { _ in }) {
            guard let url = constructURL(for: .messageDasha) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
        
        guard !message.isEmpty else {
            completion(.failure(NSError(domain: "No Message Sent", code: 0, userInfo: nil)))
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Not Signed In", code: 0, userInfo: nil)))
            return
        }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let parameters: [String: Any] = ["userID": userID, "message": message]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("DASHA API: \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        
                        print("DASHA API: \(json)")
                        completion(.success(json))
                    } catch {
                        print("DASHA API: \(error)")
                        completion(.failure(error))
                        
                    }
                }
            }
            
            task.resume()
        }
    
    
    func tellMeAbout( data: TellMeAboutReadData, completion: @escaping (Result<Any, Error>) -> Void = { _ in }) {
            guard let url = constructURL(for: .tell_me_about) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
        
       
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Not Signed In", code: 0, userInfo: nil)))
            return
        }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        let parameters: [String: Any] = ["requestingUserID": data.requestingUserID, "targetUserID": data.targetUserID]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(.failure(error))
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("DASHA API: \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("DASHA API: \(json)")
                        completion(.success(json))
                    } catch {
                        print("DASHA API: \(error)")
                        completion(.failure(error))
                        
                    }
                }
            }
            
            task.resume()
        }
    
    
    
    
    

}
