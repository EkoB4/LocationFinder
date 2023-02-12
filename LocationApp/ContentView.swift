//
//  ContentView.swift
//  LocationApp
//
//  Created by Ekin Bacik on 12.02.2023.
//

import SwiftUI
import MapKit
struct ContentView: View {
    @State var title = ""
    @State var subtile = ""
    var body: some View {
        ZStack(alignment: .bottom){
            MapView(title: self.$title, subtitle: self.$subtile)
                .ignoresSafeArea()
            HStack{
                Text("Your location is ;")
                VStack{
                    Text(self.title).font(.body)
                    Text(self.subtile).font(.caption)
                }
            }.background {
                Color.red
                    .cornerRadius(8)
            }
           
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView : UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent1: self)
    }
    @Binding var title : String
    @Binding var subtitle :String
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        let coordinate = CLLocationCoordinate2D(latitude: 41.015137, longitude: 28.979530)
        map.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        map.delegate = context.coordinator
        
        map.addAnnotation(annotation)
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //
    }
    
    typealias UIViewType = MKMapView
    
    class Coordinator : NSObject, MKMapViewDelegate{
        var parent : MapView
        init(parent1 : MapView){
            parent = parent1
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = .gray
            pin.animatesDrop = true
            
            return pin
        }
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)) { (places,error) in
                if error != nil{
                    print((error?.localizedDescription)!)
                    return
                }
                self.parent.title = (places?.first?.name ?? places?.first?.postalCode)!
                self.parent.subtitle = (places?.first?.locality ?? places?.first?.country ?? "Turkey")
            }
         }
        
    }
    
}
