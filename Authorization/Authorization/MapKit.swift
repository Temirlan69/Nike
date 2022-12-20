//
//  MapKit.swift
//  Authorization
//
//  Created by Tima on 20.12.2022.
//

import SwiftUI
import MapKit

struct MapKit: View {
    var body: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    }
}


struct MapView: UIViewRepresentable{
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let annotation = MKPointAnnotation()
        annotation.title = "Nike"
        annotation.subtitle = "Shop1"
        annotation.coordinate = CLLocationCoordinate2DMake(51.090873, 71.418338)
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 7000, longitudinalMeters: 7000)
        mapView.setRegion(region, animated: true)
        
        let annotation1 = MKPointAnnotation()
        annotation1.title = "Nike"
        annotation1.subtitle = "Shop2"
        annotation1.coordinate = CLLocationCoordinate2DMake(51.121972, 71.428013)
        mapView.addAnnotation(annotation1)
        let region1 = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 7000, longitudinalMeters: 7000)
        mapView.setRegion(region1, animated: true)
        
        let annotation2 = MKPointAnnotation()
        annotation2.title = "Nike"
        annotation2.subtitle = "Shop3"
        annotation2.coordinate = CLLocationCoordinate2DMake(51.109294, 71.395454)
        mapView.addAnnotation(annotation2)
        
        let region2 = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 7000, longitudinalMeters: 7000)
        mapView.setRegion(region2, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate{
        var parent: MapView
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
        
        init(_ parent: MapView){
            self.parent = parent
        }
    }
    
}

struct MapKit_Previews: PreviewProvider {
    static var previews: some View {
        MapKit()
    }
}
