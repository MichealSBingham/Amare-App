//
//  NearbyUserRowView.swift
//  Amare
//
//  Created by Micheal Bingham on 11/30/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class NearbyUserRowViewModel: ObservableObject{
    
    var compatibility_listener: ListenerRegistration?
    
    @Published var compatibility_score: Double?
    
    init(){
        
        self.readScore()
    }
    
    func readScore()  {
       
        
        AmareApp().delay(2){
            DispatchQueue.main.async{
                withAnimation{
                    self.compatibility_score = Double.random(in: 0...1)
                    
                   
                }
               
            }
        }
            
          
        
    }
    
    deinit{
      //  compatibility_listener?.remove litstner
    }
    
    
}


struct NearbyUserRowView: View {
    let profileImageUrl: String?
    let name: String?
    let distance: String?
    let username: String? = nil
    @StateObject var  model: NearbyUserRowViewModel = NearbyUserRowViewModel()

    var body: some View {
        ZStack{
            HStack {
                
                CircularProfileImageView(profileImageUrl: profileImageUrl ?? "", isNotable: false, showShadow: false)
                    .frame(width: 60)
                    .padding(.trailing)
                

                VStack(alignment: .leading) {
                    Text(name ?? "")
                        .font(.title3.bold())

                    Text(distance ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

               
                Spacer()
                
                 
            
            }
            HStack{
                Spacer()
                RadialChartAdjustableSize(progress: model.compatibility_score, size: 60)
            }
        }
     
        
    }
}


#Preview {
    ListOfNearbyUserRowViewPreview()
}

struct ListOfNearbyUserRowViewPreview: View{
    
    var body: some View{
        
        NavigationView{
            
            List(AppUser.generateMockData(of: 10)){ user in
                NearbyUserRowView(profileImageUrl: user.profileImageUrl, name: user.name, distance: " 3 km away")

                
            }
        }
    }
}
