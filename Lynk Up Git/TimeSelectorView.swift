import SwiftUI
import Foundation
import Combine
import Mapbox



struct TimeSelectorView: View {
    
    
    @GestureState var pressingState5 = false // will be true till tap hold
    var pressingGesture5: some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
            .updating($pressingState5) { value, state, transaction in
                switch value {
                case .second(true, nil):
                    state = true
                    break
                default:
                    break
                }
        }
        .onEnded { _ in
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE MMMM d")
        //formatter.dateStyle = .full
        return formatter
    }
    var monthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d")
        //formatter.dateStyle = .full
        return formatter
    }
    @Binding var selectedDay: Date
    @Binding var showDaySelector: Bool
    @Binding var DayRangeValue: Double
    var mapStyle: URL
    var dateComponent: DateComponents {
        var component = DateComponents()
        component.day = 1
        return component
    }
    var todaysDate: Date = Date()
    var range: ClosedRange<Double> = 0...23.99
    var todaysTimeValue = (Double(Calendar.current.component(.hour, from: Date())) + (Double(Calendar.current.component(.minute, from: Date())) / 60.0))
    @State private var todaysRange: ClosedRange<Double> = (Double(Calendar.current.component(.hour, from: Date())) + (Double(Calendar.current.component(.minute, from: Date())) / 60.0))...23.99
    
    
    var body: some View {
        let dateBinding = Binding(
            get: { self.selectedDay },
            set: {
                //new value is accessed with $0
                //old value is accessed with self.selectedDay
                if self.dateFormatter.string(from: $0) == self.dateFormatter.string(from: self.todaysDate) {
                    //We chose today's date or a day before today's date
                    if self.DayRangeValue < self.todaysTimeValue {
                        self.DayRangeValue = self.todaysTimeValue
                    }
                    self.todaysRange = (Double(Calendar.current.component(.hour, from: Date())) + (Double(Calendar.current.component(.minute, from: Date())) / 60.0))...23.99
                }
                if $0 > self.selectedDay {
                    self.DayRangeValue = 0
                }
                self.selectedDay = $0
        }
        )
        return VStack(spacing: 0){
            
            
            
            if self.mapStyle == MGLStyle.darkStyleURL {
                if self.dateFormatter.string(from: self.selectedDay) != self.dateFormatter.string(from: self.todaysDate) {
                    if showDaySelector == true {
                        ZStack {
                            
                            DatePicker(selection: dateBinding, in: Date()...self.nextYear()!, displayedComponents: .date) {
                                Text("")
                            }.frame(width: 320)
                                .clipped()
                                .colorMultiply(Color.black)
                                .colorInvert()
                                .background(Color.black)
                                .cornerRadius(15)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 25, height: 25)
                                .rotationEffect(Angle(degrees: 45))
                                .padding(.top, 215)
                        }.padding(.bottom, 5)
                    }
                    
                    Button("\(dateFormatter.string(from: selectedDay))") {
                        self.showDaySelector.toggle()
                    }.padding(.bottom, 28)
                    
                    HStack {
                        Spacer()
                        
                        
                        
                        
                        Text("<")
                            .font(.system(size: 20))
                            .padding(.horizontal, 15)
                            .foregroundColor(.purple)
                            .onTapGesture {
                                if self.dateFormatter.string(from: self.previousDate()!) == self.dateFormatter.string(from: self.todaysDate) {
                                    if self.DayRangeValue < self.todaysTimeValue {
                                        self.DayRangeValue = self.todaysTimeValue
                                        self.changeByDate(-1)
                                        self.showDaySelector = false
                                    } else {
                                        self.changeByDate(-1)
                                        self.showDaySelector = false
                                    }
                                    self.todaysRange = (Double(Calendar.current.component(.hour, from: Date())) + (Double(Calendar.current.component(.minute, from: Date())) / 60.0))...23.99
                                } else {
                                    self.changeByDate(-1)
                                    self.showDaySelector = false
                                    self.todaysRange = (Double(Calendar.current.component(.hour, from: Date())) + (Double(Calendar.current.component(.minute, from: Date())) / 60.0))...23.99
                                }
                        }
                        
                        
                        
                        
                        
                        Slider(value: self.$DayRangeValue, in: self.range)
                            .padding(.vertical)
                            
                            .overlay(GeometryReader { gp in
                                ZStack {
                                    HStack(alignment: .top) {
                                        if Int(self.DayRangeValue) == 0 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("12:0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            } else { Text("12:\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            }
                                        }
                                        else if self.DayRangeValue < 12 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 { Text("\(Int(self.DayRangeValue)):0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            } else {
                                                Text("\(Int(self.DayRangeValue)):\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            }
                                        } else if Int(self.DayRangeValue) == 12 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("12:0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            } else { Text("12:\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            }
                                        }
                                            
                                        else {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("\(Int(self.DayRangeValue - 12)):0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            } else {
                                                Text("\(Int(self.DayRangeValue - 12)):\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            }
                                        }
                                        
                                    }.frame(width: 80, height: 22)
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                    
                                    
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 6, height: 6)
                                        .rotationEffect(Angle(degrees: 45))
                                        .padding(.top, 23)
                                }.frame(width: 80, height: 25)
                                    .position(x: CGFloat(self.DayRangeValue) * (gp.size.width - CGFloat(24)) / CGFloat(self.range.upperBound) + CGFloat(24) / 2, y: 0)
                            })
                        if self.dateFormatter.string(from: self.selectedDay) != self.dateFormatter.string(from: self.nextYear()!) {
                            
                            Text(">")
                                .font(.system(size: 20))
                                .padding(.horizontal, 15)
                                .foregroundColor(.purple)
                                .onTapGesture {
                                    self.changeByDate(1)
                                    self.DayRangeValue = 0.0
                                    self.showDaySelector = false
                            }
                            
                        } else {
                            
                            Text(">")
                                .font(.system(size: 20))
                                .padding(.horizontal, 15)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    self.showDaySelector = false
                            }
                        }
                        Spacer()
                    }.frame(height: 30)
                    HStack {
                        Text("\(self.showDate(-1))")
                        Spacer()
                        Text("\(self.showDate(1))")
                    }.padding(.horizontal, 15)
                        .padding(.bottom, 32)
                        .foregroundColor(.purple)
                }
                    
                    
                    
                    
                else {
                    if showDaySelector == true {
                        ZStack {
                            
                            DatePicker(selection: dateBinding, in: Date()...self.nextYear()!, displayedComponents: .date) {
                                Text("")
                            }.frame(width: 320)
                                .clipped()
                                .clipped()
                                .colorMultiply(Color.black)
                                .colorInvert()
                                .background(Color.black)
                                .cornerRadius(15)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 25, height: 25)
                                .rotationEffect(Angle(degrees: 45))
                                .padding(.top, 215)
                        }.padding(.bottom, 5)
                    }
                    
                    Button("\(dateFormatter.string(from: selectedDay))") {
                        self.showDaySelector.toggle()
                    }.padding(.bottom, 28)
                    
                    HStack {
                        Spacer()
                        
                        Text("<")
                            .font(.system(size: 20))
                            .padding(.horizontal, 15)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                self.showDaySelector = false
                        }
                        
                        Slider(value: self.$DayRangeValue, in: self.todaysRange)
                            .padding(.vertical)
                            
                            
                            .overlay(GeometryReader { gp in
                                ZStack {
                                    HStack(alignment: .top) {
                                        if Int(self.DayRangeValue) == 0 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("12:0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            } else { Text("12:\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            }
                                        }
                                        else if self.DayRangeValue < 12 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 { Text("\(Int(self.DayRangeValue)):0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            } else {
                                                Text("\(Int(self.DayRangeValue)):\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            }
                                        } else if Int(self.DayRangeValue) == 12 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("12:0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            } else { Text("12:\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            }
                                        }
                                            
                                        else {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("\(Int(self.DayRangeValue - 12)):0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            } else {
                                                Text("\(Int(self.DayRangeValue - 12)):\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            }
                                        }
                                        
                                    }.frame(width: 80, height: 22)
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                    
                                    
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 6, height: 6)
                                        .rotationEffect(Angle(degrees: 45))
                                        .padding(.top, 23)
                                }.frame(width: 80, height: 25)
                                    .position(x: CGFloat(self.DayRangeValue - self.todaysTimeValue) * (gp.size.width - CGFloat(24)) / CGFloat(self.todaysRange.upperBound - self.todaysTimeValue) + CGFloat(24) / 2, y: 0)
                            })
                        
                        Text(">")
                            .font(.system(size: 20))
                            .padding(.horizontal, 15)
                            .foregroundColor(.purple)
                            .onTapGesture {
                                self.changeByDate(1)
                                self.showDaySelector = false
                                self.DayRangeValue = 0.0
                        }
                        
                        Spacer()
                    }.frame(height: 30)
                    HStack {
                        Spacer()
                        Text("\(self.showDate(1))")
                    }.padding(.horizontal, 15)
                        .padding(.bottom, 32)
                        .foregroundColor(.purple)
                }
            } else {
                if self.dateFormatter.string(from: self.selectedDay) != self.dateFormatter.string(from: self.todaysDate) {
                    if showDaySelector == true {
                        ZStack {
                            
                            DatePicker(selection: dateBinding, in: Date()...self.nextYear()!, displayedComponents: .date) {
                                Text("")
                            }.frame(width: 320)
                                .clipped()
                                .colorInvert()
                                .colorMultiply(Color.black)
                                .background(Color.white)
                                .cornerRadius(15)
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 25, height: 25)
                                .rotationEffect(Angle(degrees: 45))
                                .padding(.top, 215)
                        }.padding(.bottom, 5)
                    }
                    
                    Button("\(dateFormatter.string(from: selectedDay))") {
                        self.showDaySelector.toggle()
                    }.padding(.bottom, 28)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                        }) {
                            Text("<")
                                .font(.system(size: 20))
                                .padding(.horizontal, 15)
                                .foregroundColor(.purple)
                                .onTapGesture {
                                    if self.dateFormatter.string(from: self.previousDate()!) == self.dateFormatter.string(from: self.todaysDate) {
                                        if self.DayRangeValue < self.todaysTimeValue {
                                            self.DayRangeValue = self.todaysTimeValue
                                            self.changeByDate(-1)
                                            self.showDaySelector = false
                                        } else {
                                            self.changeByDate(-1)
                                            self.showDaySelector = false
                                        }
                                        self.todaysRange = (Double(Calendar.current.component(.hour, from: Date())) + (Double(Calendar.current.component(.minute, from: Date())) / 60.0))...23.99
                                    } else {
                                        self.changeByDate(-1)
                                        self.showDaySelector = false
                                        self.todaysRange = (Double(Calendar.current.component(.hour, from: Date())) + (Double(Calendar.current.component(.minute, from: Date())) / 60.0))...23.99
                                    }
                            }
                        }
                        Slider(value: self.$DayRangeValue, in: self.range)
                            .padding(.vertical)
                            
                            .overlay(GeometryReader { gp in
                                ZStack {
                                    HStack(alignment: .top) {
                                        if Int(self.DayRangeValue) == 0 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("12:0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            } else { Text("12:\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            }
                                        }
                                        else if self.DayRangeValue < 12 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 { Text("\(Int(self.DayRangeValue)):0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            } else {
                                                Text("\(Int(self.DayRangeValue)):\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            }
                                        } else if Int(self.DayRangeValue) == 12 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("12:0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            } else { Text("12:\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            }
                                        }
                                            
                                        else {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("\(Int(self.DayRangeValue - 12)):0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            } else {
                                                Text("\(Int(self.DayRangeValue - 12)):\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            }
                                        }
                                        
                                    }.frame(width: 80, height: 22)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .foregroundColor(Color.black)
                                    
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 6, height: 6)
                                        .rotationEffect(Angle(degrees: 45))
                                        .padding(.top, 23)
                                }.frame(width: 80, height: 25)
                                    .position(x: CGFloat(self.DayRangeValue) * (gp.size.width - CGFloat(24)) / CGFloat(self.range.upperBound) + CGFloat(24) / 2, y: 0)
                            })
                        if self.dateFormatter.string(from: self.selectedDay) != self.dateFormatter.string(from: self.nextYear()!) {
                            
                            
                            Text(">")
                                .font(.system(size: 20))
                                .padding(.horizontal, 15)
                                .foregroundColor(.purple)
                                .onTapGesture {
                                    self.changeByDate(1)
                                    self.DayRangeValue = 0.0
                                    self.showDaySelector = false
                            }
                            
                        } else {
                            Text(">")
                                .font(.system(size: 20))
                                .padding(.horizontal, 15)
                                .foregroundColor(.gray)
                                .onTapGesture { }
                        }
                        Spacer()
                    }.frame(height: 30)
                    HStack {
                        Text("\(self.showDate(-1))")
                        Spacer()
                        Text("\(self.showDate(1))")
                    }.padding(.horizontal, 15)
                        .padding(.bottom, 32)
                        .foregroundColor(Color.black)
                }
                    
                    
                    
                    
                else {
                    if showDaySelector == true {
                        ZStack {
                            
                            DatePicker(selection: dateBinding, in: Date()...self.nextYear()!, displayedComponents: .date) {
                                Text("")
                            }.frame(width: 320)
                                .clipped()
                                .colorInvert()
                                .colorMultiply(Color.black)
                                .background(Color.white)
                                .cornerRadius(15)
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 25, height: 25)
                                .rotationEffect(Angle(degrees: 45))
                                .padding(.top, 215)
                        }.padding(.bottom, 5)
                    }
                    
                    Button("\(dateFormatter.string(from: selectedDay))") {
                        self.showDaySelector.toggle()
                    }.padding(.bottom, 28)
                    
                    HStack {
                        Spacer()
                        
                        Text("<")
                            .font(.system(size: 20))
                            .padding(.horizontal, 15)
                            .foregroundColor(.gray)
                            .onTapGesture { }
                        Slider(value: self.$DayRangeValue, in: self.todaysRange)
                            .padding(.vertical)
                            
                            
                            .overlay(GeometryReader { gp in
                                ZStack {
                                    HStack(alignment: .top) {
                                        if Int(self.DayRangeValue) == 0 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("12:0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            } else { Text("12:\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            }
                                        }
                                        else if self.DayRangeValue < 12 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 { Text("\(Int(self.DayRangeValue)):0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            } else {
                                                Text("\(Int(self.DayRangeValue)):\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) AM")
                                            }
                                        } else if Int(self.DayRangeValue) == 12 {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("12:0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            } else { Text("12:\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            }
                                        }
                                            
                                        else {
                                            if Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60) < 10 {
                                                Text("\(Int(self.DayRangeValue - 12)):0\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            } else {
                                                Text("\(Int(self.DayRangeValue - 12)):\(Int(self.DayRangeValue.truncatingRemainder(dividingBy: 1)*60)) PM")
                                            }
                                        }
                                        
                                    }.frame(width: 80, height: 22)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .foregroundColor(Color.black)
                                    
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 6, height: 6)
                                        .rotationEffect(Angle(degrees: 45))
                                        .padding(.top, 23)
                                }.frame(width: 80, height: 25)
                                    .position(x: CGFloat(self.DayRangeValue - self.todaysTimeValue) * (gp.size.width - CGFloat(24)) / CGFloat(self.todaysRange.upperBound - self.todaysTimeValue) + CGFloat(24) / 2, y: 0)
                            })
                        
                        
                        
                        
                        Text(">")
                            .font(.system(size: 20))
                            .padding(.horizontal, 15)
                            .foregroundColor(.purple)
                            .onTapGesture {
                                self.changeByDate(1)
                                self.showDaySelector = false
                                self.DayRangeValue = 0.0
                        }
                        
                        
                        Spacer()
                    }.frame(height: 30)
                    HStack {
                        Spacer()
                        Text("\(self.showDate(1))")
                    }.padding(.horizontal, 15)
                        .padding(.bottom, 32)
                        .foregroundColor(Color.black)
                }
            }
            
            
            
            
            
            
            
            
            
            
            
            
        }.accentColor(.purple)
    }
    
    func changeByDate(_ day: Int) {
        if let date = Calendar.current.date(byAdding: .day, value: day, to: selectedDay) {
            self.selectedDay = date
        }
    }
    
    func previousDate() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: selectedDay)!
    }
    
    func nextYear() -> Date? {
        return Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    }
    
    func showDate(_ day: Int) -> String{
        let date = Calendar.current.date(byAdding: .day, value: day, to: selectedDay)!
        return monthDayFormatter.string(from: date)
    }
}
