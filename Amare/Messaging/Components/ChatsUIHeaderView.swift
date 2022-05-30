//
//  ChatsUIHeaderView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/30/22.
//

import SwiftUI




//import SwiftUI

struct  ChatsUIHeaderView: View {

	let accentPrimary = Color( #colorLiteral(red: 0.03921568627, green:
						0.5176470588, blue: 1, alpha: 1))
	@State private var searchText = ""

	var body: some View {
		NavigationView{
			Text("Searching for \(searchText)?")
				.searchable(text: $searchText)
				.navigationTitle("Messages")
				.navigationBarTitleDisplayMode(.inline)
				.navigationBarItems(
					leading: Button {
						print("Pressed edit button")
					} label: {
						Text("Edit")
					},

					trailing: Button {
							print("Pressed compose button")
						} label: {
							Image(systemName: "square.and.pencil")
						}
				)
		}
		.frame(height: 80)
	}
}


struct ChatsUIHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		ChatsUIHeaderView()
			.preferredColorScheme(.dark)
	}
}
