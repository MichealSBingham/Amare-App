//
//  ChartView.swift
//  Amare
//
//  Created by Micheal Bingham on 8/12/21.
//

import SwiftUI
import Combine

var testImages = ["https://lh3.google.com/u/0/ogw/ADea4I57grRsMmsG3Wxmx_ayco7IOgQV40Pc8hc78ylE=s64-c-mo", "https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png"]

struct ChartView: View {
    @EnvironmentObject private var account: Account
    
    @State private var deg: Double = 0
    @State private var space: Double = 150
    @State private var radius: CGFloat = .infinity
    
    @State private var chart: NatalChart?
    
    @State var aspectToGet: AspectType = .all
    
    @State var showBottomPopup: Bool = false
    
    @State var infoToShow: String?
    
    @State var didChangeCharts: Bool = false
    
    @State var person1: String = "Your Natal Chart"
    @State  var person2: String = ""

    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    //@State private var viewState = CGSize.zero
    
    @State private var showImagePicker: Bool = false
    @State var image: UIImage?
    
   
    
    var defaultImage: String = testImages[0]
    
    
    @State private var location: CGPoint = CGPoint(x: UIScreen.main.bounds.midX - 15 , y: UIScreen.main.bounds.midY - 50)
    var simpleDrag: some Gesture {
            DragGesture()
                .onChanged { value in
                    print("changed to .. \(value)")
                    self.location = value.location
                }
        }
    
    var body: some View {
        
        
        
        ZStack{
            
            Background()
            

            
            VStack{
                
                Text("Amor Vincit Omnia")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .bold()
                    .padding()
                
                    
               // Spacer()
                
                HStack{
                    // Profile Image
                    profileUIImage()
                      // .padding()
                
                    //Spacer()
                    
                    VStack{
                        
                        // Name and user name
                        Text(account.data?.name ?? "You have no name")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .bold()
                            .padding([.trailing, .leading, .top])
                            .padding(.bottom, 3)
                       
                        Text("\(account.data?.id ?? "@saymyname") ")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                           //.padding()
                            //.bold()
                            //.offset(x: 12)
                        
                    }.padding()
                    
                    Spacer()
                   // Spacer()
                }.padding()
                
                Spacer()

            }
            
            
            
            
            
        
        
        //
        
            usersNatalChart()
                .offset(x: 0, y: 50)
                
                
                
                
            
            
        
            
            
        }
        .popup(isPresented: $showBottomPopup, type: .toast, position: .bottom) {
            // your content
            Text("\(infoToShow ?? "")")
                            .frame(width: 200, height: 200)
                            .background(Color(red: 0.85, green: 0.8, blue: 0.95))
                            .cornerRadius(30.0)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.image = image
            }
        
    }
    
}
    
   
    func usersNatalChart() -> some View {
        
        return NatalChartView()
        
            .make(with: chart/*, shownAspect: aspectToGet*/)
            .animation(.easeIn(duration: 3))
            .onReceive(Just(account), perform: { _ in
        
               // guard !didChangeCharts else { return }
                
               // AmareApp().delay(1) {
                    
                    //person1 = account.data?.name ?? ""
                    chart = account.data?.natal_chart
                    print("The chart after delay ... \(chart)")
                 
               // }
                
            })
      
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.wantsMoreInfoFromNatalChart)) { obj in
               
                showBottomPopup = true
                
                if let sign = obj.object as? ZodiacSign{
                    
                    infoToShow = sign.rawValue
                }
                
                if let planet = obj.object as? Planet{
                    
                    infoToShow = planet.name.rawValue
                }
                
                if let house = obj.object as? House{
                    
                    infoToShow = String(house.ordinality)
                }
                
                if let angle = obj.object as? Angle{
                    
                    infoToShow = angle.name.rawValue
                }
             //   infoToShow = (obj.object as? ZodiacSign)?.rawValue }
            
            }
            .make(with: chart)
            .position(location)
            //.gesture(
                   //         simpleDrag
             //           )
            .scaleEffect(scale)
            .gesture(MagnificationGesture()
                        .onChanged { val in
                            let delta = val / self.lastScale
                            self.lastScale = val
                          //  if delta > 0.94 { // if statement to minimize jitter
                                let newScale = self.scale * delta
                                self.scale = newScale
                           // }
                        }
                        .onEnded { _ in
                            self.lastScale = 1.0
                        }
                    )
            .onAppear(perform: {
                
                
                AmareApp().delay(1) {
                    
                    //person1 = account.data?.name ?? ""
                    withAnimation(.easeIn(duration: 3)) {
                        chart = account.data?.natal_chart
                        print("The chart after delay ... \(chart)")
                    }
                    
                 
                }
            })
            .padding()
    }
    
   
    func profileUIImage() -> some View {
        
        return Button {
            
            showImagePicker = true
            
        } label: {
            
            ZStack{
                
                Group{
                    
                    ImageFromUrl(account.data?.profile_image_url ?? defaultImage)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .aspectRatio(contentMode: .fit)
                        
                    
                    /*
                    
                    Image("ImageUploadView/emptyprofilepic")
                        .resizable()
                        .frame(width: 120, height: 120)
           
                    Image(systemName: "person")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 60)
                     */
                     
                    
                }
                //.opacity(self.image == nil ? 1: 0)
               
                //TODO:  Allow changing profile image here
              //  selectedUIImage()
                    

            }
            //TODO: We disable this button for now
        }.disabled(true)
            
            
            

         
        
    }
        
       
    
}


    

extension BinaryFloatingPoint {
    /// Converts decimal degrees to degrees, minutes, seconds
    var dms: String {
        var seconds = Int(self * 3600)
        let degrees = seconds / 3600
        seconds = abs(seconds % 3600)
        
        let minutes = seconds / 60
        let Seconds = seconds % 60
        
        
        return "\(degrees)°\(minutes)'\(Seconds)\""
        
    }
    
    
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        
       // ForEach([ "iPhone 8", "iPhone 12 Pro Max"], id: \.self) { //deviceName in
                       ChartView()
                           // .previewDevice(PreviewDevice(rawValue: deviceName))
                          //  .previewDisplayName(deviceName)
                            .environmentObject(Account())
                        .preferredColorScheme(.dark)
                  //}
        
      
        
    }
}


