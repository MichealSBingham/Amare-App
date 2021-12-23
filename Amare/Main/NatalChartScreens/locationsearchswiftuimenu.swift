//
//  locationsearchswiftuimenu.swift
//  Amare
//
//  Created by Micheal Bingham on 12/22/21.
//

import SwiftUI


struct locationsearchswiftuimenu: View {
    @ObservedObject var locationService: LocationService

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Location Search")) {
                    ZStack(alignment: .trailing) {
                        TextField("Search", text: $locationService.queryFragment)
                        // This is optional and simply displays an icon during an active search
                        if locationService.status == .isSearching {
                            Image(systemName: "clock")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                Section(header: Text("Results")) {
                    List {
                        // With Xcode 12, this will not be necessary as it supports switch statements.
                        Group { () -> AnyView in
                            switch locationService.status {
                            case .noResults: return AnyView(Text("No Results"))
                            case .error(let description): return AnyView(Text("Error: \(description)"))
                            default: return AnyView(EmptyView())
                            }
                        }.foregroundColor(Color.gray)

                        ForEach(locationService.searchResults, id: \.self) { completionResult in
                            // This simply lists the results, use a button in case you'd like to perform an action
                            // or use a NavigationLink to move to the next view upon selection.
                            Text(completionResult.title)
                        }
                    }
                }
            }
        }
    }
}
struct locationsearchswiftuimenu_Previews: PreviewProvider {
    static var previews: some View {
        locationsearchswiftuimenu(locationService: LocationService())
    }
}



import Foundation
import Combine
import MapKit

class LocationService: NSObject, ObservableObject {

    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }

    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []

    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self

        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            // we're debouncing the search, because the search completer is rate limited.
            // feel free to play with the proper value here
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.status = .idle
                    self.searchResults = []
                }
        })
    }
}

extension LocationService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Depending on what you're searching, you might need to filter differently or
        // remove the filter altogether. Filtering for an empty Subtitle seems to filter
        // out a lot of places and only shows cities and countries.
        self.searchResults = completer.results.filter({ $0.subtitle == "" })
        self.status = completer.results.isEmpty ? .noResults : .result
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}
