//
//  SlideOverCard.swift
//  Navigator
//
//  Created by Jonathan Sillak on 17.11.2023.
//

import SwiftUI

struct SlideUpCardCompact: View {
    @Environment(\.colorScheme) var colorScheme
    @GestureState private var dragState = DragState.inactive
    @State var position = CardPosition.bottom
    
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        
        return Group {
            Slider()
            VStack(spacing: 10) {
                Capsule()
                    .frame(
                        width: 45,
                        height: 7
                    )
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                SessionControls()
                
                SessionStats()
                
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(x: (-UIScreen.main.bounds.width / 2.5) + 120, y: self.position.rawValue)
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position.rawValue + drag.translation.height
        let positionAbove: CardPosition
        let positionBelow: CardPosition
        let closestPosition: CardPosition

        if cardTopEdgeLocation <= CardPosition.top.rawValue {
            positionAbove = .top
            positionBelow = .bottom
        } else {
            positionAbove = .top
            positionBelow = .bottom
        }

        if (cardTopEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - cardTopEdgeLocation) { closestPosition = positionAbove }
        else { closestPosition = positionBelow }

        if verticalDirection > 0 { self.position = positionBelow }
        else if verticalDirection < 0 { self.position = positionAbove}
        else { self.position = closestPosition }
    }

    enum CardPosition: CGFloat {
        case top = 50
        case bottom = 300
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
}

#Preview {
    SlideUpCardCompact()
}
