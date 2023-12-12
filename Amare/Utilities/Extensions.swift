//
//  Extensions.swift
//  Love
//
//  Created by Micheal Bingham on 6/17/21.
//

import Foundation
import SwiftUI
import Firebase
import StreamChat
import StreamChatSwiftUI

var peopleImages: [String] = ["https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cG9ydHJhaXR8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1504257432389-52343af06ae3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjZ8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzd8fHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60"]

///  We extend this so that we can use it outside of didFinishLaunching
extension ChatClient {
	static var shared: ChatClient!
}

extension Image {
	func customizable() -> some View {
		renderingMode(.template)
			.resizable()
			.scaledToFit()
	}
}


extension Color {
 
	func uiColor() -> UIColor {

		if #available(iOS 14.0, *) {
			return UIColor(self)
		}

		let components = self.components()
		return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
	}

	private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

		let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
		var hexNumber: UInt64 = 0
		var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

		let result = scanner.scanHexInt64(&hexNumber)
		if result {
			r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
			g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
			b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
			a = CGFloat(hexNumber & 0x000000ff) / 255
		}
		return (r, g, b, a)
	}
	
	static func random() -> Color {
        
        
		return Color(UIColor.random)
	}
    
    static var amare: Color{
        return Color(UIColor.amare)
    }
    
    static var ourGray: Color{
        return Color(UIColor.ourGray)
    }
    
   
    
   
}

extension UIColor {
	static var random: UIColor {
		return UIColor(
			red: .random(in: 0...1),
			green: .random(in: 0...1),
			blue: .random(in: 0...1),
			alpha: 1.0
		)
	}
    
    static var amare: UIColor{
        return UIColor(red: 0.99, green: 0.20, blue: 0.74, alpha: 1.00)
        
    }
    
    static var ourGray: UIColor{
        return UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1.00)
    }

    
}



/// Gets the Verification ID from signing in the phone number
/// - Returns: The verification id string from UserDefaults 
func getVerificationID() -> String? {
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    return verificationID
}

extension String{
    
    /// Saves the verification ID string in UserDefaults
    /// - Returns: Void.
    func save()  {
        
        UserDefaults.standard.set(self, forKey: "authVerificationID")
    }
}


extension NSNotification {
    static let logout = NSNotification.Name.init("logout")
    /// Due to an error or some other type of reason, we need to the view to 'go back' one view (or pop back) so we use this notification to tell us when to do that. Post this notification whenever the view needs to go backwards and some reason you can't access the exact view the user is on at the moment. 
    static let goBack = NSNotification.Name.init("goBack")
    /// Dismiss the tab views for showing the user's placements 
    static let exitPlacements = NSNotification.Name.init("exitPlacements")
    static let verificationCodeSent = NSNotification.Name.init(rawValue: "verificationCodeSent")
    
    /// User likely tapped on a sign/angle/planet/house and wants more information on it. Typically we will show the bottom popup view when we receive this
    static let wantsMoreInfoFromNatalChart = NSNotification.Name.init(rawValue: "wantsMoreInfoFromNatalChart")
    
    /// Tells the view to load another user's profile information
    static let loadUserProfile = NSNotification.Name.init(rawValue: "loadUserProfile")
    
    /// Used when user enters information to compute another natal chart and the information is loading
    static let loadingAnotherNatalChart = NSNotification.Name.init(rawValue: "loadingAnotherNatalChart")
    
    /// Used when user enters information to compute another natal chart and the information has completed
    static let completedLoadingAnotherNatalChart = NSNotification.Name.init(rawValue: "completedLoadingAnotherNatalChart")
    
    /// When the user deleted a custom natal chart they made
    static let deletedCustomUserNatalChart = NSNotification.Name.init(rawValue: "deletedCustomUserNatalChart")
    
    static let gotWinkedAt = NSNotification.Name.init(rawValue: "gotWinkedAt")

    /*
    /// User likely tapped on a house and wants more information on it. Typically we will show the bottom popup view when we receive this
    static let wantsHouseInfo = NSNotification.Name.init(rawValue: "wantsHouseInfo")
    
    /// User likely tapped on a Zodiac Sign  and wants more information on it. Typically we will show the bottom popup view when we receive this
    static let wantsZodiacSignInfo = NSNotification.Name.init(rawValue: "wantsZodiacSignInfo")
    
    static let wantsPlanetInfo = NSNotification.Name.init(rawValue: "wantsPlanetInfo")
    
    static let wantsAngleInfo = NSNotification.Name.init(rawValue: "wantsAngleInfo")
    */
    
}





extension Timestamp{
    
    var month: String{
        return Date(timeIntervalSince1970: Double(self.seconds)).month()
    }
    
    var year: Int{
        return Date(timeIntervalSince1970: Double(self.seconds)).year()
    }
    
    var day: Int{
        return Date(timeIntervalSince1970: Double(self.seconds)).day()
    }
}


extension Date {
    func getDateFor(days:Int) -> Date? {
         return Calendar.current.date(byAdding: .day, value: days, to: Date())
    }

    /// Extension for returning the `Date` +- years from the current date
    func dateFor(years: Int) -> Date {
        
        return Calendar.current.date(byAdding: .year, value: years, to: Date()) ?? Date()
    }
}



public extension DispatchQueue {
    private static var _onceTracker = [String]()

    public class func once(file: String = #file,
                           function: String = #function,
                           line: Int = #line,
                           block: () -> Void) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String,
                           block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }

        guard !_onceTracker.contains(token) else { return }

        _onceTracker.append(token)
        block()
    }
}

extension UserDefaults {

    enum Keys: String, CaseIterable {

        case unitsNotation
        case temperatureNotation
        case allowDownloadsOverCellular

    }

    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }

}

/// Loads an image from a url
struct ImageFromUrl: View {
    
    @ObservedObject var imageLoader: ImageLoaderAndCache

    init(_ url: String) {
        imageLoader = ImageLoaderAndCache(imageURL: url)
    }

    var body: some View {
          Image(uiImage: UIImage(data: self.imageLoader.imageData) ?? UIImage())
              .resizable()
              .clipped()
    }
    
    func image() -> UIImage {
        
        return UIImage(data: self.imageLoader.imageData) ?? UIImage() 
        /*
        Image(uiImage: UIImage(data: self.imageLoader.imageData) ?? UIImage())
            .resizable()
            .clipped()
         */
        
    }
	
	
}

class ImageLoaderAndCache: ObservableObject {
    
    @Published var imageData = Data()
    
    init(imageURL: String) {
        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: imageURL) ?? URL(string: peopleImages.randomElement()!)! , cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = cache.cachedResponse(for: request)?.data {
            print("got image from cache")
            self.imageData = data
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response {
                let cachedData = CachedURLResponse(response: response, data: data)
                                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        print("downloaded from internet")
                        self.imageData = data
                    }
                }
            }).resume()
        }
    }
}


import Combine
import SwiftUI
struct ImageViewController: View {
    @ObservedObject var url: LoadUrlImage

    init(imageUrl: String) {
        url = LoadUrlImage(imageURL: imageUrl)
    }

    var body: some View {
          Image(uiImage: UIImage(data: self.url.data) ?? UIImage())
              .resizable()
              .clipped()
    }
}

class LoadUrlImage: ObservableObject {
    @Published var data = Data()
    init(imageURL: String) {
        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: imageURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = cache.cachedResponse(for: request)?.data {
            self.data = data
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response {
                let cachedData = CachedURLResponse(response: response, data: data)
                                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self.data = data
                    }
                }
            }).resume()
        }
    }
}


public struct ForEachWithIndex<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    public var data: Data
    public var content: (_ index: Data.Index, _ element: Data.Element) -> Content
    var id: KeyPath<Data.Element, ID>

    public init(_ data: Data, id: KeyPath<Data.Element, ID>, content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }

    public var body: some View {
        ForEach(
            zip(self.data.indices, self.data).map { index, element in
                IndexInfo(
                    index: index,
                    id: self.id,
                    element: element
                )
            },
            id: \.elementID
        ) { indexInfo in
            self.content(indexInfo.index, indexInfo.element)
        }
    }
}

extension ForEachWithIndex where ID == Data.Element.ID, Content: View, Data.Element: Identifiable {
    public init(_ data: Data, @ViewBuilder content: @escaping (_ index: Data.Index, _ element: Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

extension ForEachWithIndex: DynamicViewContent where Content: View {
}

private struct IndexInfo<Index, Element, ID: Hashable>: Hashable {
    let index: Index
    let id: KeyPath<Element, ID>
    let element: Element

    var elementID: ID {
        self.element[keyPath: self.id]
    }

    static func == (_ lhs: IndexInfo, _ rhs: IndexInfo) -> Bool {
        lhs.elementID == rhs.elementID
    }

    func hash(into hasher: inout Hasher) {
        self.elementID.hash(into: &hasher)
    }
}


struct EnumeratedForEach<ItemType, ContentView: View>: View {
    let data: [ItemType]
    let content: (Int, ItemType) -> ContentView
    
    init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
        self.data = data
        self.content = content
    }
    
    var body: some View {
        ForEach(Array(self.data.enumerated()), id: \.offset) { idx, item in
            self.content(idx, item)
        }
    }
}


extension UserDefaults {
    static func blockUser(userID: String) {
        var blockedUsers = UserDefaults.standard.array(forKey: "BlockedUsers") as? [String] ?? []
        blockedUsers.append(userID)
        UserDefaults.standard.set(blockedUsers, forKey: "BlockedUsers")
    }
}



extension UserDefaults {
    private static let fireworksShownKey = "FireworksShownForUser"

    static func hasShownFireworks(forUserId userId: String) -> Bool {
        let key = "\(fireworksShownKey)_\(userId)"
        return UserDefaults.standard.bool(forKey: key)
    }

    static func setFireworksShown(forUserId userId: String) {
        let key = "\(fireworksShownKey)_\(userId)"
        UserDefaults.standard.set(true, forKey: key)
    }
}



extension UserDefaults {
    private static let firstAppLaunchKey = "FirstAppLaunchKey"

    static func isFirstAppLaunch() -> Bool {
        return UserDefaults.standard.object(forKey: firstAppLaunchKey) == nil
    }

    static func setNotFirstAppLaunch() {
        UserDefaults.standard.set(false, forKey: firstAppLaunchKey)
    }
}
