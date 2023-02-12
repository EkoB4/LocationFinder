//
//  SearchView.swift
//  LocationApp
//
//  Created by Ekin Bacik on 12.02.2023.
//

import SwiftUI
import MapKit
struct SearchView: View {
    @StateObject var locationManager : LocationManager = .init()
    @State var navigationTag : String?
    var body: some View {
        VStack{
            HStack(spacing:15){
                Button {
                    //
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                Text("Search")
                    .font(.title)
            }.frame(maxWidth: .infinity,alignment: .leading)
            HStack(spacing:10){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                
                TextField("Find locations",text: $locationManager.searhText)
            }.padding(.vertical,12)
                .background {
                    RoundedRectangle(cornerRadius: 10,style: .continuous)
                        .strokeBorder(.gray)
                }
            if let places = locationManager.fetchedPlaces,!places.isEmpty{
                List{
                    ForEach(places,id: \.self){places in
                        HStack(spacing:15){
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            VStack(alignment: .leading,spacing: 6) {
                                Text(places.name ?? "")
                                    .font(.title3.bold())
                                
                                Text(places.locality ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }
                    
                }.listStyle(.plain)
            } else{
                Button {
                    if let coordinate = locationManager.userLocation?.coordinate{
                        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        locationManager.addDraggablePin(coordinate: coordinate)
                    }
                    navigationTag = "MAPVIEW"
                } label: {
                    Text("SAass")
                }
            }
            
        }
        .padding()
        .frame(maxHeight: .infinity,alignment: .top)
        .background {
            NavigationStack{
                NavigationLink(tag: "MAPVIEW", selection: $navigationTag) {
                    MapViewSelection().environmentObject(locationManager)
                } label: {
                    
                }.labelsHidden()

            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct MapViewSelection : View{
    @EnvironmentObject var locationManager : LocationManager
    var body: some View{
        ZStack{
            MapViewHelper().environmentObject(locationManager)
        }
    }
}

struct MapViewHelper : UIViewRepresentable{
    @EnvironmentObject var locationManager : LocationManager
    func makeUIView(context: Context) -> some MKMapView {
        return locationManager.mapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
