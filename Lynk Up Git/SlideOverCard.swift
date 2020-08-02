//
import Foundation
import SwiftUI
import Mapbox
struct SlideOverCard<Content: View> : View {
    @GestureState private var dragState = DragState.inactive
    @Binding var position: CardPosition
    var mapStyle: URL
    var content: () -> Content
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
        }
        .onEnded(onDragEnded)
        if mapStyle == MGLStyle.darkStyleURL {
            return VStack (spacing: 0) {
                Handle(mapStyle: self.mapStyle)
                self.content()
            }
            .frame(height: UIScreen.main.bounds.height)
            .background(Color.init(red: 15/255, green: 15/255, blue: 15/255))
            .cornerRadius(10.0)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
            .offset(y: self.position.offset + self.dragState.translation.height)
            .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
            .gesture(drag)
        } else {
            return VStack (spacing: 0) {
                Handle(mapStyle: self.mapStyle)
                self.content()
            }
            .frame(height: UIScreen.main.bounds.height)
            .background(Color.white)
            .cornerRadius(10.0)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
            .offset(y: self.position.offset + self.dragState.translation.height)
            .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
            .gesture(drag)
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position.offset + drag.translation.height
        let positionAbove: CardPosition
        let positionBelow: CardPosition
        let closestPosition: CardPosition
        if cardTopEdgeLocation <= CardPosition.middle(UIScreen.main.bounds.height - 250).offset {
            positionAbove = .top(50)
            positionBelow = .middle(UIScreen.main.bounds.height - 250)
        } else {
            positionAbove = .middle(UIScreen.main.bounds.height - 250)
            positionBelow = .bottom(UIScreen.main.bounds.height - 77.5)
        }
        if (cardTopEdgeLocation - positionAbove.offset) < (positionBelow.offset - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        } else {
            self.position = closestPosition
        }
    }
}

enum RelativeCardPosition {
    case top
    case middle
    case bottom
}
 
struct CardPosition {
    let relativeCardPosition: RelativeCardPosition
    let offset: CGFloat
    
    static func top(_ offset: CGFloat) -> CardPosition {
        CardPosition(relativeCardPosition: .top, offset: offset)
    }
    
    static func middle(_ offset: CGFloat) -> CardPosition {
        CardPosition(relativeCardPosition: .middle, offset: offset)
    }
    
    static func bottom(_ offset: CGFloat) -> CardPosition {
        CardPosition(relativeCardPosition: .bottom, offset: offset)
    }
}
 
enum DragState {
    case inactive
    case dragging(translation: CGSize)
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
 
