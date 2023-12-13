//
//  SettingsView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/21/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userDataModel: UserProfileModel
   
   
    
    //@EnvironmentObject var authService: AuthService
    
    @EnvironmentObject var viewRouter: ViewRouter
  
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDeleteSheet = false
    @State private var updateAccountSheet = false
    @State private var reportAProblemSheet = false
    @State private var contactUsSheet = false

    var body: some View {
        Form {
            /*
    
             
            Section(header: Text("User Information")) {
                Text("Name: \(userDataModel.user?.name ?? "" )")
                Text("Username: \(userDataModel.user?.username ?? "" )")
                Text("Phone Number: \(userDataModel.user?.phoneNumber ?? "" )")
            }
            */
            
            Section(header: Text("Account Settings")) {
                                Button(action: {
                                    // Show sheet to confirm account deletion
                                    showDeleteSheet.toggle()
                                }) {
                                    Text("Delete Account")
                                        .foregroundColor(.red)
                                }
                
                                Button(action: {
                                // Show sheet to confirm account deletion
                                updateAccountSheet.toggle()
                                }) {
                                    Text("Update Account Information")
                        
                                }
                
                
                            }
            
            
            Section(header: Text("Contact")) {
                                Button(action: {
                                    // Show sheet to confirm account deletion
                                    reportAProblemSheet.toggle()
                                }) {
                                    Text("Report A Problem")
                                        .foregroundColor(.red)
                                }
                
                                Button(action: {
                                // Show sheet to confirm account deletion
                                contactUsSheet.toggle()
                                }) {
                                    Text("Contact Us")
                        
                                }
                
                
                            }

            .sheet(isPresented: $showDeleteSheet) {
                        MailComposeView(recipient: "love@findamare.com", subject: "Account Deletion Request")
                    }
            .sheet(isPresented: $updateAccountSheet) {
                        MailComposeView(recipient: "love@findamare.com", subject: "Update Account Information Request")
                    }
            .sheet(isPresented: $reportAProblemSheet) {
                        MailComposeView(recipient: "love@findamare.com", subject: "There's an Issue..")
                    }
            
            .sheet(isPresented: $contactUsSheet) {
                        MailComposeView(recipient: "love@findamare.com", subject: "Hi! -- Let's Talk About ...")
                    }
            
            
            
            
            
            Section {
                Button("Sign Out", action: {
                    AuthService.shared.signOut { result in
                        switch result{
                        case .success(_):
                            print("Signed out ")
                            withAnimation{
                                
                               
                                presentationMode.wrappedValue.dismiss()
                                viewRouter.screenToShow = .signInOrUp
                                viewRouter.currentPage = .map // remove this if you're having issues with relogin in after sign out
                                userDataModel.resetData()
                               
                                
                                
                                
                            }
                        case .failure(let error):
                            print("Could not sign out with error \(error)")
                        }
                    }
                })
                                .foregroundColor(.red)
                        }
        }
        .navigationTitle("Settings")
    }
    
}
import MessageUI
struct MailComposeView: UIViewControllerRepresentable {
    let recipient: String
    let subject: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeView>) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.setToRecipients([recipient])
        viewController.setSubject(subject)
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeView>) {
        // Update the view controller if needed
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserProfileModel())
}
