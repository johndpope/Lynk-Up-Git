
import Foundation
import SwiftUI


private var eventUrl = "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/feed"

private var createdEventsUrl = "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/created_events"

private var profileUrl = "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/profile"

private var atendeeUrl = "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/my_atendees"

private var ImAttendingUrl = "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/users_events"

private var removeFromEventUrl = "http://ec2-3-128-24-132.us-east-2.compute.amazonaws.com/api/remove_self"

class DataFetcher: ObservableObject{
    @Published var dataHasLoaded: Bool = false
    @Published var attendeesLoaded: Bool = false
    @Published var useresUventsLoaded: Bool = false
    @Published var profilesLoaded: Bool = false
    @Published var eventsUpdated: Bool = false
    @Published var events: [eventdata] = []
    @Published var createdEvents: [eventdata] = []
    @Published var profile: profiledata?
    @Published var atendees: [atendeedata] = []
    @Published var IAmAtending: [atendeedata] = []
    @Published var eventNames: [eventdata] = []
    @Published var profileList: [profiledata] = []
    @Published var token: String = UserDefaults.standard.string(forKey: "Token") ?? ""
    private var id: Int = 0
    
    func fetchEvents(){
    //self.dataHasLoaded = false
    let url = URL(string: eventUrl)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
        print("My token is: \(self.token)")
        print("My url is: \(eventUrl)")
        request.addValue("Token \(self.token)", forHTTPHeaderField: "Authorization")
                let task = URLSession.shared.dataTask(with: request, completionHandler: parseJasonObject)
            task.resume()
        }
        
        func parseJasonObject(data: Data?, urlResponse: URLResponse?, error: Error?){
            guard error == nil else {
                print("\(error!)")
                return
            }
            
            guard let content = data else{
                print("No data")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([eventdata]?.self, from: content) {
                   // we have good data – go back to the main thread
                DispatchQueue.main.async {
                    self.events = decodedResponse
                    print(self.events.last?.poi)
                    self.dataHasLoaded = true
                    self.eventsUpdated = true
                }
            }
            
        }
   
    func fetchProfile(id: Int){
        
       // events.removeAll()
        profileUrl.append("/\(id)")
        self.id = id
        let url = URL(string: profileUrl)!
        var request = URLRequest(url: url)
        
        if let range = profileUrl.range(of: "/\(id)") {
           profileUrl.removeSubrange(range)
        }
        
        request.httpMethod = "GET"
        print(self.token)
        request.addValue("Token \(self.token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: parseFetchProfileObject)
                task.resume()
            }
            
            
            func parseFetchProfileObject(data: Data?, urlResponse: URLResponse?, error: Error?){
                guard error == nil else {
                    print("\(error!)")
                    return
                }
                
                guard let content = data else{
                    print("No data")
                    return
                }
                
                if let decodedResponse = try? JSONDecoder().decode(profiledata?.self, from: content) {
                    DispatchQueue.main.async {
                        self.profile = decodedResponse
                        self.profileList.append(self.profile!)
                }
            }
            
        }
    
    
    
    func fetchAtendees(id: Int){
        
       // events.removeAll()
        atendeeUrl.append("/\(id)")
        print(atendeeUrl)
       
        let url = URL(string: atendeeUrl)!
        var request = URLRequest(url: url)
       
        if let range = atendeeUrl.range(of:"/\(id)") {
           atendeeUrl.removeSubrange(range)
        }
        
         request.httpMethod = "GET"
        print(self.token)
        request.addValue("Token \(self.token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: parseFetchAttendeesObject)
                task.resume()
            }
            
            
    func parseFetchAttendeesObject(data: Data?, urlResponse: URLResponse?, error: Error?){
                guard error == nil else {
                    print("\(error!)")
                    return
                }
                
                guard let content = data else{
                    print("No data")
                    return
                }
                
                if let decodedResponse = try? JSONDecoder().decode([atendeedata]?.self, from: content) {
                    DispatchQueue.main.async {
                        self.atendees = []
                        self.atendees = decodedResponse
                        print(self.atendees.last?.event_id)
                        
                       if self.atendees.last != nil{
                           for profile in self.atendees{
                               self.fetchProfile(id: profile.user_profile)
                          }
                       }
                       
                    self.profilesLoaded = true
                }
            }
            
        }
    
    
    
    
    
    func userCreatedEvents(){
        
        // events.removeAll()
        //createdEventsUrl.append(String(id))
        
        
        let url = URL(string: createdEventsUrl)!
        //atendeeUrl.removeLast()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print(self.token)
        request.addValue("Token \(self.token)", forHTTPHeaderField: "Authorization")
        
      let task = URLSession.shared.dataTask(with: request, completionHandler: parseUserCreatedEventsObject)
            task.resume()
        }
        
        
        func parseUserCreatedEventsObject(data: Data?, urlResponse: URLResponse?, error: Error?){
            guard error == nil else {
                print("\(error!)")
                return
            }
            
            guard let content = data else{
                print("No data")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([eventdata]?.self, from: content) {
                DispatchQueue.main.async {
                    self.createdEvents = []
                    self.createdEvents = decodedResponse
                    print(self.createdEvents.last?.poi)
                    self.useresUventsLoaded = true
                    
                }
            }
        }
    
    func userAttendingEvents(){
        
        let url = URL(string: ImAttendingUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print(self.token)
        request.addValue("Token \(self.token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: parseEventsAttendingObject)
        task.resume()
    }
    
    
    func parseEventsAttendingObject(data: Data?, urlResponse: URLResponse?, error: Error?){
        guard error == nil else {
            print("\(error!)")
            return
        }
        
        guard let content = data else{
            print("No data")
            return
        }
        
        if let decodedResponse = try? JSONDecoder().decode([atendeedata]?.self, from: content) {
            DispatchQueue.main.async {
                self.IAmAtending = []
                self.eventNames = []
                self.IAmAtending = decodedResponse
                print(self.IAmAtending.last?.event_id)
                for events in self.events{
                    for event in self.IAmAtending{
                        if events.id == event.event_id{
                            self.eventNames.append(events)
                        }
                    }
                }
                self.attendeesLoaded = true
            }
        }
    }
  
    
    func deleteEvent(id: Int) {
        let baseUrl = URL(string: eventUrl)
        let deletionUrl = baseUrl!.appendingPathComponent("\(id)")
        print("Deletion URL with appended id: \(deletionUrl.absoluteString)")

        var request = URLRequest(url: deletionUrl)
        request.httpMethod = "DELETE"
        print(token) // ensure this is correct
        request.allHTTPHeaderFields = ["Authorization": "Token \(token)"]
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Encountered network error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                // this is basically also debugging code
                print("Endpoint responded with status: \(httpResponse.statusCode)")
                print("                   with headers:\n\(httpResponse.allHeaderFields)")
            }
            // Debug output of the data:
            if let data = data {
                let payloadAsSimpleString = String(data: data, encoding: .utf8) ?? "(can't parse payload)"
                print("Response contains payload\n\(payloadAsSimpleString)")
            }
        }
        task.resume()
    }
    
    func removeFromEvent(id: Int) {
        let baseUrl = URL(string: removeFromEventUrl)
        let deletionUrl = baseUrl!.appendingPathComponent("\(id)")
        print("Deletion URL with appended id: \(deletionUrl.absoluteString)")

        var request = URLRequest(url: deletionUrl)
        request.httpMethod = "DELETE"
        print(token) // ensure this is correct
        request.allHTTPHeaderFields = ["Authorization": "Token \(token)"]
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Encountered network error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                // this is basically also debugging code
                print("Endpoint responded with status: \(httpResponse.statusCode)")
                print("                   with headers:\n\(httpResponse.allHeaderFields)")
            }
            // Debug output of the data:
            if let data = data {
                let payloadAsSimpleString = String(data: data, encoding: .utf8) ?? "(can't parse payload)"
                print("Response contains payload\n\(payloadAsSimpleString)")
            }
        }
        task.resume()
    }
    
}



