 
import Foundation
import Mapbox
import SwiftUI
 
class CustomCalloutView: UIView, MGLCalloutView {
 
    let dismissesAutomatically: Bool = false
    let isAnchoredToAnnotation: Bool = true
    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0
    @Binding var annotationSelected: Bool
    var representedObject: MGLAnnotation
    var data: DataFetcher
    @State var userName: String?
    lazy var leftAccessoryView = UIView()
    lazy var rightAccessoryView = UIView()
 
    
    
    weak var delegate: MGLCalloutViewDelegate?
 
    //MARK: Subviews -
    let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        return label
    }()
 
    let timeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0/255, green: 49/255, blue: 102/255, alpha: 1)
        return label
    }()
    
    let userLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0/255, green: 49/255, blue: 102/255, alpha: 1)
        return label
    }()
    
    let peopleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0/255, green: 49/255, blue: 102/255, alpha: 1)
        return label
    }()
    
    let box:UIView = {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width * 0.75, height: 140))
        var rectView = UIView(frame: rect)
        rectView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        rectView.layer.cornerRadius = 8.0
        return rectView
    }()
    
    let separatorLine:UIView = {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width * 0.75, height: 10))
        var rectView = UIView(frame: rect)
        rectView.backgroundColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
        rectView.translatesAutoresizingMaskIntoConstraints = false
        return rectView
    }()
    
    let personImg: UIImageView = {
        let img = UIImage(systemName: "person.fill")
        var imgView = UIImageView(image: img)
        //imgView.tintColor = UIColor(ciColor: .black)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let clockImg: UIImageView = {
        let img = UIImage(systemName: "clock")
        var imgView = UIImageView(image: img)
        //imgView.tintColor = UIColor(ciColor: .black)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    
 
    required init(annotation: MGLAnnotation, annotationSelected: Binding<Bool>, data: DataFetcher) {
        self.representedObject = annotation
        self.data = data
        _annotationSelected = annotationSelected
        
        // init with 75% of width and 120px tall
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.width * 0.75, height: 150)))
        
        self.data.profileList = []
        for event in self.data.events{
            if annotation.title == event.address{
                self.titleLabel.text = event.address ?? ""
                self.timeLabel.text = "\(event.start_time) - \(event.end_time) " ?? ""
               
                
                
                
                    
                    
                        
                }
            /*
                DispatchQueue.main.async{
                    self.data.fetchAtendees(id: event.id)
                    self.peopleLabel.text = "\(self.data.atendees.count) people attending" ?? ""
                    for profile in self.data.atendees{
                    self.data.fetchProfile(id: profile.user_profile)
                        }

                    self.data.fetchProfile(id: event.user_profile)
                    self.userLabel.text = "Profile ID: \(self.data.profile!.name)" ?? ""
                }
  */
  }
        
       
        
        self.titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.titleLabel.numberOfLines = 2
        setup()
    }
 
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var center: CGPoint {
            set {
                var newCenter = newValue
                newCenter.y -= bounds.midY
                super.center = newCenter
            }
            get {
                return super.center
            }
        }
 
    func setup() {
        // setup this view's properties
        self.backgroundColor = UIColor.clear
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CustomCalloutView.calloutTapped)))
        
        // And the subviews
        self.addSubview(box)
        self.addSubview(titleLabel)
        self.addSubview(timeLabel)
        self.addSubview(peopleLabel)
        self.addSubview(userLabel)
        self.addSubview(personImg)
        self.addSubview(clockImg)
        self.addSubview(separatorLine)
 
        // Add Constraints to subviews
        let spacing:CGFloat = 8.0
 
        //Positioning the text of the location name
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing / 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        //Positioning the separating line between the event name and information
        separatorLine.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: spacing / 3).isActive = true
        separatorLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing).isActive = true
        separatorLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        //Positioning the text that is currently "Searched location" that will represent event time
        timeLabel.topAnchor.constraint(equalTo: self.separatorLine.bottomAnchor, constant: spacing).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing * 4).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        //Positioning the clock image right next to timeLabel
        clockImg.topAnchor.constraint(equalTo: self.separatorLine.bottomAnchor, constant: spacing).isActive = true
        clockImg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing).isActive = true
        clockImg.rightAnchor.constraint(equalTo: self.timeLabel.leftAnchor, constant: -spacing / 2).isActive = true
        clockImg.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        //Positioning the text that shows how many people are at the event
        peopleLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: spacing / 2).isActive = true
        peopleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing * 4).isActive = true
        peopleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing).isActive = true
        peopleLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        //Positioning the person image right next to peopleLabel
        personImg.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: spacing / 2).isActive = true
        personImg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing).isActive = true
        personImg.rightAnchor.constraint(equalTo: self.peopleLabel.leftAnchor, constant: -spacing / 2).isActive = true
        personImg.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        userLabel.topAnchor.constraint(equalTo: self.peopleLabel.bottomAnchor, constant: spacing / 2).isActive = true
        userLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing * 4).isActive = true
        userLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        personImg.topAnchor.constraint(equalTo: self.peopleLabel.bottomAnchor, constant: spacing / 2).isActive = true
        personImg.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing).isActive = true
        personImg.rightAnchor.constraint(equalTo: self.userLabel.leftAnchor, constant: -spacing / 2).isActive = true
        personImg.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        //Creating and positioning the white box of the callout
        box.topAnchor.constraint(equalTo: self.topAnchor, constant: 0 ).isActive = true
        box.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        box.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        box.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        //Setting the callout shadow
        box.layer.shadowColor = UIColor.systemBlue.cgColor
        box.layer.shadowOpacity = 0.5
        box.layer.shadowOffset = .zero
        box.layer.shadowRadius = 7//20
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: (UIScreen.main.bounds.width * 0.375) - (tipWidth / 1.4) - box.layer.shadowRadius, y: 140))
        shadowPath.addLine(to: CGPoint(x: 0, y: 140))
        shadowPath.addLine(to: CGPoint(x: 0, y: 0))
        shadowPath.addLine(to: CGPoint(x: UIScreen.main.bounds.width * 0.75, y: 0))
        shadowPath.addLine(to: CGPoint(x: UIScreen.main.bounds.width * 0.75, y: 140))
        shadowPath.addLine(to: CGPoint(x: (UIScreen.main.bounds.width * 0.375) + (tipWidth / 1.4) + box.layer.shadowRadius, y: 140))
        shadowPath.addLine(to: CGPoint(x: UIScreen.main.bounds.width * 0.375, y: 30))
        box.layer.shadowPath = shadowPath.cgPath
        box.layer.shouldRasterize = true
        box.layer.rasterizationScale = UIScreen.main.scale
    }
    
 
 
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        //Always, Slightly above center
        self.center = view.center.applying(CGAffineTransform(translationX: 0, y: -self.frame.height))
        view.addSubview(self)
 
    }
 
    func dismissCallout(animated: Bool) {
        if (animated){
            //do something cool
            removeFromSuperview()
            self.annotationSelected = false
        } else {
            removeFromSuperview()
            self.annotationSelected = false
        }
 
    }
    
    @objc func calloutTapped() {
        if delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        // Draw the pointed tip at the bottom.
        let fillColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
 
        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
        let heightWithoutTip = rect.size.height - tipHeight - 1
 
        let currentContext = UIGraphicsGetCurrentContext()!
 
        let tipPath = CGMutablePath()
        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
        tipPath.closeSubpath()
 
        fillColor.setFill()
        currentContext.addPath(tipPath)
        currentContext.fillPath()
    }
}
