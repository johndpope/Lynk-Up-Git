
import SwiftUI
import Mapbox

struct MapView: UIViewRepresentable {
    var configure: (MGLMapView) -> ()
    @Binding var annos: [MGLPointAnnotation]
    @Binding var annotationSelected: Bool
    @Binding var renderingMap: Bool
    @Binding var visited: Bool
    @Binding var showMoreDetails: Bool
    @Binding var selectedAnnotation: MGLAnnotation?
    @Binding var showDateSelector: Bool
    var VModel: ViewModel
    var locationManager: LocationManager
    var aVM: AnnotationsVM
    var data: DataFetcher
    var mapStyle: URL
    var token: String?
    
    init(annotationSelected: Binding<Bool>, renderingMap: Binding<Bool>, visited: Binding<Bool>, showMoreDetails: Binding<Bool>, selectedAnnotation: Binding<MGLAnnotation?>, showDateSelector: Binding<Bool>, VModel: ViewModel, locationManager: LocationManager, aVM: AnnotationsVM, annos: Binding<[MGLPointAnnotation]>, mapStyle: URL, data: DataFetcher, token: String, configure: @escaping (MGLMapView) -> () = { _ in }) {
        self.VModel = VModel
        self.locationManager = locationManager
        self.aVM = aVM
        self.mapStyle = mapStyle
        self.data = data
        self.token = token
        self.configure = configure
        _annos = annos
        _annotationSelected = annotationSelected
        _renderingMap = renderingMap
        _visited = visited
        _showMoreDetails = showMoreDetails
        _selectedAnnotation = selectedAnnotation
        _showDateSelector = showDateSelector

    }
    
    
    
    
    
    //This function creates the actual view of the map
    func makeUIView(context: Context) -> MGLMapView {
        let map = MGLMapView()
        DispatchQueue.main.async {
            map.styleURL = self.mapStyle
            map.delegate = context.coordinator
            map.showsUserLocation = true
            map.attributionButtonPosition = .topLeft
            map.logoViewPosition = .topLeft
            map.logoViewMargins.y = 15
            map.logoViewMargins.x = 95
            map.logoViewMargins.x = 12
            map.attributionButtonMargins.x = 100
            map.attributionButtonMargins.y = 15
        
            self.configure(map)
        }
        return map
    }
    
    
    
    
    //This function is called whenever there is a change in the map's state
    //Go over the functionality of this with TJ.
    func updateUIView(_ uiView: MGLMapView, context: Context) {
        if annotationSelected == false {
            for annotation in uiView.selectedAnnotations {
                uiView.deselectAnnotation(annotation, animated: false)
            }
        }
        uiView.addAnnotations(annos)
    
        if self.data.eventsUpdated{
            for event in self.data.events{
                if self.aVM.annos.last?.title != self.data.events.last?.address{
                    self.aVM.addNextAnnotation(address: event.address)
                    print("Profile id = \(event.user_profile)")
                }
            }
            self.data.eventsUpdated = false
        }
        
//        if self.data.events != nil{
//            for event in self.data.events{
//                           if self.aVM.annos.last?.title != self.data.events.last?.address{
//                               self.aVM.addNextAnnotation(address: event.address)
//                               print("Profile id = \(event.user_profile)")
//                     }
//              }
//        }
        if annos.last != nil {
            
            if visited == false {
                uiView.setCenter(annos.last!.coordinate, zoomLevel: 13, animated: true)
                visited = true
            }
        }
        
    }
    
    
    
    
    //Creates a Coordinator so you can access all of the delegate functions when this map has a state change
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(annotationSelected: self.$annotationSelected, renderingMap: self.$renderingMap, showMoreDetails: self.$showMoreDetails, selectedAnnotation: self.$selectedAnnotation, showDateSelector: self.$showDateSelector, mapStyle: self.mapStyle, aVM: self.aVM, data: self.data, token: self.token!)
    }
    
}

//This class contains functions that are important for annotation selection/deselection
class MapViewCoordinator: NSObject, MGLMapViewDelegate {
    
    @Binding var annotationSelected: Bool
    @Binding var renderingMap: Bool
    @Binding var showMoreDetails: Bool
    @Binding var selectedAnnotation: MGLAnnotation?
    @Binding var showDateSelector: Bool
    var firstTimeLoading: Bool = true
    var firstTimeLoadingMap: Bool = true
    var mapStyle: URL
    var aVM: AnnotationsVM
    var data: DataFetcher
    var token: String
    
    //Sets the value of annotationSelected equal to whatever it is upon initialization...I think it should always be false?
    init(annotationSelected: Binding<Bool>, renderingMap: Binding<Bool>, showMoreDetails: Binding<Bool>, selectedAnnotation: Binding<MGLAnnotation?>, showDateSelector: Binding<Bool>, mapStyle: URL, aVM: AnnotationsVM, data: DataFetcher, token: String) {
        _annotationSelected = annotationSelected
        _renderingMap = renderingMap
        _showMoreDetails = showMoreDetails
        _selectedAnnotation = selectedAnnotation
        _showDateSelector = showDateSelector
        self.mapStyle = mapStyle
        self.aVM = aVM
        self.data = data
        self.token = token
        
    }
    
    
    
    
    //Allows the annotation to display pertinent information (Title, subtitle, etc.)
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    
    
    //Sets the map's view to the user's location when the application loads up. Make sure it doesn't set the user location whenever the user moves on the map.
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        if firstTimeLoading {
            mapView.setCenter(mapView.userLocation!.coordinate, zoomLevel: 13, animated: true)
            firstTimeLoading = false
        }
    }
    
    
    
    
    
    
    
    
    
    
    //Changes the annotationSelected @Binding<Bool> value to true and sets the center of the map to the annotation that was selected
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        print("An annotation was selected")
        mapView.setCenter(annotation.coordinate, zoomLevel: 17,  animated: true)
        for annotation in mapView.selectedAnnotations
        {
            if annotation !== mapView.selectedAnnotations.last {
                mapView.deselectAnnotation(annotation, animated: false)
            }
        }
        annotationSelected = true
        selectedAnnotation = annotation
        showDateSelector = false
        print("The annotation at this point is \(annotationSelected)")
        //Need to add something so when you select it, it also shows the title, subtitle, etc.
    }
    
    
    
    
    
    
    
    
    //Changes the annotationSelected @Binding<Bool> value to false when an annotaion is unselected
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        print("An annotation was unselected")
        showMoreDetails = false
        annotationSelected = false
        selectedAnnotation = nil
        showDateSelector = false
        self.data.token = self.token
        print("My token is: \(self.data.token)")
//        self.data.fetchEvents() { array in
//            print("yo yo \(array.last?.poi)")
//            DispatchQueue.main.async {
//                self.data.events = array
//            }
//            
//            self.data.userCreatedEvents(){array in
//                DispatchQueue.main.async {
//                    self.data.createdEvents = array
//                }
//            }
//            
//            self.data.userAttendingEvents(){ array in
//                DispatchQueue.main.async {
//                    self.data.IAmAtending = array
//                }
//            }
//            
//            for event in self.data.events{
//                if self.aVM.annos.last?.title != self.data.events.last?.address{
//                    self.aVM.addNextAnnotation(address: event.address)
//                    print("Profile id = \(event.user_profile)")
//                }
//            }
//        }
        
    }
    
    
    
    
    
    
    
    
    
    func mapViewWillStartRenderingMap(_ mapView: MGLMapView) {
        renderingMap = true
        if mapView.selectedAnnotations.count > 0 {
            annotationSelected = true
            showDateSelector = false
        }
        else {
            annotationSelected = false
            showDateSelector = false
        }
        for annotation in mapView.selectedAnnotations {
            let point = mapView.convert(annotation.coordinate, toPointTo: mapView)
            if mapView.bounds.contains(point) == false {
                mapView.deselectAnnotation(annotation, animated: false)
                annotationSelected = false
            }
        }
    }
    
    
    
    
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView) {
        renderingMap = false
        if mapView.selectedAnnotations.count > 0 {
            annotationSelected = true
            showDateSelector = false
        }
        else {
            annotationSelected = false
            showDateSelector = false
        }
        for annotation in mapView.selectedAnnotations {
            let point = mapView.convert(annotation.coordinate, toPointTo: mapView)
            if mapView.bounds.contains(point) == false {
                mapView.deselectAnnotation(annotation, animated: false)
                annotationSelected = false
            }
        }
    }

    
    
    
    
    func mapViewDidBecomeIdle(_ mapView: MGLMapView) {
        renderingMap = false
        if mapView.selectedAnnotations.count > 0 {
            annotationSelected = true
            showDateSelector = false
        }
        else {
            annotationSelected = false
            showDateSelector = false
        }
        for annotation in mapView.selectedAnnotations {
            let point = mapView.convert(annotation.coordinate, toPointTo: mapView)
            if mapView.bounds.contains(point) == false {
                mapView.deselectAnnotation(annotation, animated: false)
                annotationSelected = false
            }
        }
    }
    
    
    
    
    
    
    
    func mapViewWillStartRenderingFrame(_ mapView: MGLMapView) {
        renderingMap = true
        if mapView.selectedAnnotations.count > 0 {
            annotationSelected = true
            showDateSelector = false
        }
        else {
            annotationSelected = false
            showDateSelector = false
        }
        for annotation in mapView.selectedAnnotations {
            let point = mapView.convert(annotation.coordinate, toPointTo: mapView)
            if mapView.bounds.contains(point) == false {
                mapView.deselectAnnotation(annotation, animated: false)
                annotationSelected = false
            }
        }
    }
    
    
    
    
    
    
    
    
    func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView) {
        renderingMap = false
        if mapView.selectedAnnotations.count > 0 {
            annotationSelected = true
            showDateSelector = false
        }
        else {
            annotationSelected = false
            showDateSelector = false
        }
        for annotation in mapView.selectedAnnotations {
            let point = mapView.convert(annotation.coordinate, toPointTo: mapView)
            if mapView.bounds.contains(point) == false {
                mapView.deselectAnnotation(annotation, animated: false)
                annotationSelected = false
            }
        }
    }
    
    
    
    
    
    
    
    
    func mapViewWillStartLoadingMap(_ mapView: MGLMapView) {
        renderingMap = true
        if mapView.selectedAnnotations.count > 0 {
            annotationSelected = true
            showDateSelector = false
        }
        else {
            annotationSelected = false
            showDateSelector = false
        }
        for annotation in mapView.selectedAnnotations {
            let point = mapView.convert(annotation.coordinate, toPointTo: mapView)
            if mapView.bounds.contains(point) == false {
                mapView.deselectAnnotation(annotation, animated: false)
                annotationSelected = false
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        renderingMap = false
        if mapView.selectedAnnotations.count > 0 {
            annotationSelected = true
            showDateSelector = false
        }
        else {
            annotationSelected = false
            showDateSelector = false
        }
        for annotation in mapView.selectedAnnotations {
            let point = mapView.convert(annotation.coordinate, toPointTo: mapView)
            if mapView.bounds.contains(point) == false {
                mapView.deselectAnnotation(annotation, animated: false)
                annotationSelected = false
            }
        }
    }
    
    
    
    
    
    
    
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        return CustomCalloutView(annotation: annotation, annotationSelected: $annotationSelected, data: self.data)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        //Set boolean to show callout more info
        self.showMoreDetails = true
        selectedAnnotation = annotation
        showDateSelector = false
    }
    
}














class AnnotationsVM: ObservableObject {
    @Published var annos = [MGLPointAnnotation]()
    @ObservedObject var VModel: ViewModel //= ViewModel()
    @Published var visited: Bool
    @Published var annotationPlacementFailed: Bool
    
    init(VModel: ViewModel) {
        self.VModel = VModel
        let annotation = MGLPointAnnotation()
        annotation.title = "Shoe Store"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.78, longitude: -73.98)
        annotation.subtitle = "10:00AM - 11:30AM"
        visited = true
        annotationPlacementFailed = false
        annos.append(annotation)
    }
    
    
    
    
    
    
    
    
    func addNextAnnotation(address: String) {
        let newAnnotation = MGLPointAnnotation()
        var annotationInArray: Bool = false
        self.VModel.fetchCoords(address: address) { lat, lon in
            if (lat != 0.0 && lon != 0.0) {
                newAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            }
            for annotation in self.annos {
                if (newAnnotation.coordinate.latitude == annotation.coordinate.latitude) && (newAnnotation.coordinate.longitude == annotation.coordinate.longitude) {
                    annotationInArray = true
                }
            }
            newAnnotation.title = address
            newAnnotation.subtitle = "9:00PM - 1:00AM"
            
            if annotationInArray == false {
                if (lat != 0 && lon != 0) {
                    self.annos.append(newAnnotation)
                    self.visited = false
                } else {
                    self.annotationPlacementFailed = true
                }
            }
        }
    }
}
