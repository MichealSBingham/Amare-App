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
    @Binding var tabSelection: Int
    
    @State private var deg: Double = 0
    @State private var space: Double = 150
    @State private var radius: CGFloat = .infinity
    
    @State private var chart: NatalChart?
    @State private var selectedPlanet: Planet?
    
    @State var aspectToGet: AspectType = .all
    @State var aspectSelected: Aspect?
    
    @State var showMoreInfoPopup: Bool = false
    
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
    
    ///  We use the bondaries to detect when we touch in or outside a view
    @State var placementInfoFrameBoundaries: FrameBoundaries?
    @State var aspectInfoFrameBoundaries: FrameBoundaries?
    @State var newChartMenuFrameBoundaries: FrameBoundaries?
    
    
    
    @State private var location: CGPoint = CGPoint(x: UIScreen.main.bounds.midX - 15 , y: UIScreen.main.bounds.midY - 50)
    var simpleDrag: some Gesture {
            DragGesture()
                .onChanged { value in
                    print("changed to .. \(value)")
                    self.location = value.location
                }
        }
    
    @State var showNewChartMenu = false
    
    var body: some View {
        
        
        
        ZStack{
            
            Background()
                .onTapGesture {
                    withAnimation {
                        dismissAllViews()
                        
                    }
                }
            

            
            VStack{
                
                /*
                Text("Natal Chart")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .bold()
                    .padding()
                */
                
                    
               // Spacer()
                
                HStack{
                    // Profile Image
                    profileUIImage()
                      // .padding()
                
                    
                    VStack{
                        
                        // Name and user name
                        Text(account.data?.name ?? "Mikhael Leason")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .bold()
                            .padding([.trailing, .leading, .top])
                            .padding(.bottom, 3)
                       
                        Text("\(account.data?.username ?? "@mikhael") ")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                           //.padding()
                            //.bold()
                            //.offset(x: 12)
                        
                    }.padding()
                    
                    Spacer()

                }.padding()
                
                
                
                
                HStack{
                    
                    newChartButton()
                    
                    
                    
                }
                
                Spacer()
                
                

            }
            
            
            
            
      
        
        //
            
            usersNatalChart()
                .offset(x: 0, y: 110)
                .zIndex(0)
                .onTapGesture {
                    dismissAllViews()
                }
            
            /*
            TabView{
                
                usersNatalChart()
                    .offset(x: 0, y: 50)
                    .zIndex(0)
                
                Text("Run Compatibility with Someone Else")
                
            }
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
           // .frame(width: .infinity, height: 150)
            .tabViewStyle(.page)
            */
           
            
            
            GeometryReader{ geo in
                
                
                VStack{
                    
                    Spacer()
                    MoreInfoOnPlanet(planet: selectedPlanet, chart: chart)
                    //  .rotationEffect(.degrees(-1*alpha))
                        .opacity(  selectedPlanet != nil ? 1  : 0 )
                        .padding()
                        .onAppear {
                            
                            // Set boundaries of this view
                            placementInfoFrameBoundaries = FrameBoundaries(minX: geo.frame(in: .global).minX, minY: geo.frame(in: .global).minY, maxX: geo.frame(in: .global).maxX, maxY: geo.frame(in: .global).maxY)
                        }
                    Spacer()
                    

                }
               
                
                
                
            }
            
            GeometryReader { geo in
                
                VStack{
                    Spacer()
                    
                    MoreInfoOnAspectView(chart: chart, aspect: aspectSelected)
                        .opacity(aspectSelected != nil ? 1: 0 )
                        .onAppear {
                            
                            // Set boundaries of this view
                            aspectInfoFrameBoundaries = FrameBoundaries(minX: geo.frame(in: .global).minX, minY: geo.frame(in: .global).minY, maxX: geo.frame(in: .global).maxX, maxY: geo.frame(in: .global).maxY)
                        }
                    
                    Spacer()
                    
                }
                
                    
            }
            
            
            GeometryReader { geo in
                
                VStack{
                    
                    Spacer()
                    
                    NewChartMenuUIView()
                        .onAppear {
                            
                            // Set boundaries of this view
                            newChartMenuFrameBoundaries = FrameBoundaries(minX: geo.frame(in: .global).minX, minY: geo.frame(in: .global).minY, maxX: geo.frame(in: .global).maxX, maxY: geo.frame(in: .global).maxY)
                        }
                    .opacity(showNewChartMenu ? 1: 0 )
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.completedLoadingAnotherNatalChart)) { output in
                        
                        if let uid = output.object as? String {
                            
                            // loaded the user 'uid'
                            showNewChartMenu = false
                            // show profile popup view
                            
                           
                         
                                tabSelection = 1
                            
                     
                            NotificationCenter.default.post(name: NSNotification.loadUserProfile, object: uid)
                            
                            
                        }
                        
                    }
                    
                    Spacer()
                }
            }
            
              
              
        
            
            
        }
        /* .popup(isPresented: $showBottomPopup, type: .toast, position: .bottom) {
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
        */
        
        
        .onTapGesture {
            /*
            withAnimation {
                selectedPlanet = nil
                aspectSelected = nil
                showNewChartMenu = false
                
            }
             */
           
        }
    
}
    
    func newChartButton() -> some View {
        
        
        
        return Button {
            
            withAnimation {
                showNewChartMenu = true
            }
            
        } label: {
            
            Image(systemName: "person.fill.badge.plus")
            Text("New Chart Analysis")
                
            
        }
        .buttonStyle(.plain)
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
      
            
           // .make(with: chart)
            .position(location)
            //.gesture(
                   //         simpleDrag
             //           )
       /*     .scaleEffect(scale)
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
                    ) */
            .onAppear(perform: {
                
                
               /* AmareApp().delay(1) {
                    
                    //person1 = account.data?.name ?? ""
                    withAnimation(.easeIn(duration: 3)) {
                        chart = account.data?.natal_chart
                        print("The chart after delay ... \(chart)")
                    }
                    
                 
                }
                */
            })
            .padding()
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.wantsMoreInfoFromNatalChart)) { obj in
               
                
                if let sign = obj.object as? ZodiacSign{
                    
                    infoToShow = sign.rawValue
                }
                
                if let planet = obj.object as? Planet{
                    
                    withAnimation{
                        selectedPlanet = planet
                    }
               
                }
                
                if let aspect = obj.object as? Aspect{
                    
                    withAnimation{
                        aspectSelected = aspect
                    }
               
                }
                
                if let house = obj.object as? House{
                    
                    infoToShow = String(house.ordinality)
                }
                
                if let angle = obj.object as? Angle{
                    
                    infoToShow = angle.name.rawValue
                }
             //   infoToShow = (obj.object as? ZodiacSign)?.rawValue }
            
            }
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
        
    
    /// DIsmisses the aspect views, planet placement views, and menu views that may be on the screen
    func dismissAllViews()  {
        selectedPlanet = nil
        aspectSelected = nil
        showNewChartMenu = false
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

struct FrameBoundaries {
    
    var minX: CGFloat
    var minY: CGFloat
    var maxX: CGFloat
    var maxY: CGFloat
}

struct ChartView_Previews: PreviewProvider {
    @Binding var tabSelection: Int

    static var previews: some View {
        
        
        // ForEach([ "iPhone 8", _"iPhone 12 Pro Max"], id: \.self) { //deviceName in
        ChartView(tabSelection: .constant(1))
                           // .previewDevice(PreviewDevice(rawValue: deviceName))
                          //  .previewDisplayName(deviceName)
                            .environmentObject(Account())
                        .preferredColorScheme(.dark)
                  //}
        
      
        
    }
}


