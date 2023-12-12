//
//  DetailedPlacementInfoView.swift
//  Amare
//
//  Created by Micheal Bingham on 10/29/23.
//

import SwiftUI
import LoremSwiftum
import Shimmer
import Foundation
import Combine

class DetailedPlacementInfoViewModel: ObservableObject {
    
    
    @Published var interpretation: String?
    @Published var error: Error?
    
    
    init() {
        
    }
    
     func fetchInterpretation(placementReadData: PlacementReadData) {
        APIService.shared.getPlacementRead(data: placementReadData) { [weak self] result in
            switch result {
            case .success(let fetchedInterpretation):
                DispatchQueue.main.async {
                    self?.interpretation = fetchedInterpretation
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.error = error
                }
            }
        }
    }
}



struct DetailedPlacementInfoView: View {
    @EnvironmentObject var profileDataModel: UserProfileModel
    
    @Environment(\.presentationMode) var presentationMode
    
    //@StateObject var viewModel = DetailedPlacementInfoViewModel()
    
    @Binding var isShown: Bool
    
    var planetName: PlanetName?
    var sign: ZodiacSign?
    var house: Int?
    var angle: Double?
    var shortDescription: String?
    var longDescription: String?
    var element: Element?
    var imagesOfFriendsWithSamePlacement: [String] = []
    
    fileprivate func NameDisplay() -> some View {
        return Text(planetName?.rawValue ?? PlanetName.allCases.randomElement()!.rawValue )
            .font(.largeTitle)
            .bold()
            .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
    }
    
    fileprivate func SignLabel() -> some View {
        return Text(sign?.rawValue ?? "")
            .font(.largeTitle)
            .bold()
            .frame(maxWidth : .infinity, alignment: .center)
            .foregroundColor(Color.primary.opacity(0.4))
    }
    
    
    
    fileprivate func oneLineDescriptionLabel() -> some View {
        return Text(shortDescription ?? "")
            .font(.title)
            .padding()
            .foregroundColor(Color.primary.opacity(0.4))
            .multilineTextAlignment(.center)
    }
    
    fileprivate func HouseLabel() -> HStack<TupleView<(some View, some View)>> {
        return HStack{
            
            
            
            
            
            var name_of_house = house?.toHouseNameOrd()
            Text("\(name_of_house?.rawValue ?? "") House")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.primary.opacity(0.4))
                .padding()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
            
            
            var angle = angle?.dms ?? Double.random(in: 0..<30).dms
            
            Text("\(angle)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color.primary.opacity(0.4))
                .padding()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
            
            
        }
    }
    
    fileprivate func exit() -> some View{
            VStack{
            
            HStack{
                
                Spacer()
                Button{
                    
                    withAnimation{
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                } label: {
                    
                    Image(systemName: "xmark").resizable()
                        .foregroundColor(.red.opacity(0.5))
                        .clipShape(Circle())
                        .frame(width: 25, height: 25)
                    
                }
                
            }
            
            
            Spacer()
        }
    }
    
    var body: some View {
     
            GeometryReader{ geometry in
            ScrollView{
                  ZStack{
                VStack{
                    
                    HStack{
                        
                        PlanetImageView(planetName: planetName ?? PlanetName.allCases.randomElement()!)
                            .padding()
                        VStack{
                            
                            
                            
                            NameDisplay()
                            
                            MainPlacementView(planetName: planetName, sign: sign)
                                .frame(width: 120)
                            
                            SignLabel()
                            
                            
                        }
                        
                    }
                    
                    oneLineDescriptionLabel()
                    
                    
                    ZStack{
                        
                        (element ?? Element.allCases.randomElement()!).image()
                        
                        HStack{
                            
                            ProfileImagesStack(images: imagesOfFriendsWithSamePlacement, stackLimit: 3)
                                .frame(height: 50)
                            
                            Spacer()
                            
                            ProfileImagesStack(images: imagesOfFriendsWithSamePlacement, stackLimit: 3)
                                .frame(height: 50)
                        }
                    }
                    
                    if house != nil {
                        HouseLabel()
                    }
                    
                    ZStack {
                        Text(longDescription ?? "" /*longDescription == nil ? viewModel.interpretation ?? "" : longDescription ?? ""*/)
                            .padding()
                            .foregroundColor(Color.primary.opacity(0.4))
                            .redacted(reason: longDescription == nil /*&& viewModel.interpretation == nil*/ ? .placeholder : [])
                            //.shimmering()

                        if longDescription == nil /*&& viewModel.interpretation == nil*/ {
                            ProgressView() // SwiftUI's built-in loading indicator
                                .frame(width: 20, height: 20)
                        }
                    }

                    
                    
                }
                .padding(.top, -50) //TODO: See how this padding works on all screens, it's good on my iPhone but check on other screen sizes (- Micheal)
                
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    BackButton()
                        .padding()
                    
                }
            }
                /*.onAppear(perform: {
                // If there is no interpretation in the database, we need to read it from our API
                guard longDescription == nil else { return }
                if let planet = planetName?.rawValue, let sign = sign?.rawValue, let id = profileDataModel.user?.id {
                    let placement = PlacementReadData(gender: profileDataModel.user?.sex.rawValue, planet: planet, sign: sign, house: house.number, user_id: id)
                    viewModel.fetchInterpretation(placementReadData: placement)
                }
                
                
            }) */
        }
            /* .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    BackButton()
                        .padding()
                    
                }
            }
        */
        
     
        
          
        
        
    }
}


#Preview {
    DetailedPlacementInfoView(isShown: .constant(true), planetName: .Moon, sign: .Scorpio, house: 2,  shortDescription: "Deep. Intense. Magnetic.", longDescription: Lorem.paragraphs(5), imagesOfFriendsWithSamePlacement: peopleImages)
}
