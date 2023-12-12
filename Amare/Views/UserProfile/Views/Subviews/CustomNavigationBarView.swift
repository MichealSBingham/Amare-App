//
//  CustomNavigationViewBar.swift
//  Amare
//
//  Created by Micheal Bingham on 11/26/23.
//

import SwiftUI

struct CustomNavigationBarView: View {
    var name: String
    var username: String
    var action: () -> Void

    var body: some View {
        HStack {
            Text("@\(username)")  //Text(name)
                .font(.largeTitle) // Custom large title size
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.01)
                .padding()
            
            Spacer()
            Button(action: action) {
                Image(systemName: "gear")
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, -12) // Reduced vertical padding
        .padding(.horizontal)
        .background(Color(.systemBackground)) // Match your navigation bar color
      //  .border(.red)
    }
}

struct CustomNavigationBarView2: View {
    var name: String
    var username: String
    var cancelFriendRequestAction: () -> Void
    var acceptFriendAction: () -> Void
    var model: UserProfileModel 
    
    @Environment(\.presentationMode) var presentationMode


    @State var showAlert: Bool = false
    var body: some View {
        HStack {
            // Back button
            BackButton()
                .frame(width: 25)
              
         
             
                Text("@\(username)")
                    .font(.largeTitle)
                    .bold()
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .padding(.horizontal)
                    .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Block This User"),
                                        message: Text("Are you sure you want to report and block this user?"),
                                        primaryButton: .destructive(Text("Yes")) {
                                            // Run block action
                                            // self.model.block()
                                            model.block(user: model.user?.username ?? "")
                                            presentationMode.wrappedValue.dismiss()
                                            
                                            print("Blocking user...")
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
            

            Spacer()

            Menu {
                //MARK: - Button for removing friend
                if model.friendshipStatus == .friends {
                    Button(action: {
                        cancelFriendRequestAction()
                    }) {
                        HStack {
                            Text("Remove as Friend")
                            Image(systemName: "person.fill.xmark")
                        }
                    }
                    .foregroundColor(.red)
                }
                
                //MARK: - Button for cancelling SENT friend request
                if model.friendshipStatus == .requested {
                    Button(action: {
                        cancelFriendRequestAction()
                    }) {
                        HStack {
                            Text("Cancel Friend Request")
                            Image(systemName: "person.fill.xmark")
                        }
                    }
                    .foregroundColor(.red)
                }
                
                //MARK: - Button fors for accepting and rejecting friend requests
                
                if model.friendshipStatus == .awaiting{
                    Button(action: {
                        acceptFriendAction()
                    }) {
                        HStack {
                            Text("Accept Friend Request")
                            Image(systemName: "person.fill.checkmark")
                        }
                    }
                    
                    
                    Button(action: {
                        model.rejectFriendRequest()
                    }) {
                        HStack {
                            Text("Reject Friend Request")
                            Image(systemName: "person.fill.xmark")
                        }
                    }
                    .foregroundColor(.red)
                }
                
                
                
                
                //MARK: - Button for Blocking
                Button(action: {
                    // Your block action here
                    showAlert.toggle()
                }) {
                    HStack {
                        Text("Block @\(model.user?.username ?? "")")
                            .foregroundColor(.red)
                        Image(systemName: "hand.raised.fill")
                            .foregroundColor(.red)
                    }
                }
                
                //MARK: - Button for Reporting
                
                Button(action: {
                    // Your report action here
                    showAlert.toggle()
                }) {
                    HStack {
                        Text("Report @\(model.user?.username ?? "" )")
                        Image(systemName: "flag.fill")
                    }
                }
            } label: {
                MenuOptionsView()
                    .frame(width: 25)
                    .padding()
                    .buttonStyle(PlainButtonStyle())
                
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())
            .padding(10) 
        }
        .padding(.vertical, 0) // Reduced vertical padding
        .padding(.horizontal)
        .background(Color(.systemBackground)) // Match your navigation bar color
       // .border(.red)
    }
}



#Preview {
    VStack{
        CustomNavigationBarView(name: "Micheal Bingham", username: "Micheal", action: {})
        CustomNavigationBarView2(name: "Micheal Bingham", username: "Micheal", cancelFriendRequestAction: {}, acceptFriendAction: {}, model: UserProfileModel())
    }
}
