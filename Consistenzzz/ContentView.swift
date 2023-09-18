//
//  ContentView.swift
//  Consistenzzz
//
//  Created by Antoine Rose on 17/09/2023.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State var textToUpdate = "Start"
    @State var imageToUpdate = "arrow.3.trianglepath"
    @State private var engine: CHHapticEngine?
    
    
    var body: some View {
        VStack {
            Text("🧘‍♂️")
                .font(.system(size: 128))
            Spacer()
            Image(systemName: imageToUpdate)
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(textToUpdate)
                .onAppear(perform: prepareHaptics)
                .onTapGesture(perform: complexSuccess)
                .font(.system(size: 36))
            Spacer()
        }
        .padding()
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func play(events :[CHHapticEvent]) {
        do {
                let pattern = try CHHapticPattern(events: events, parameters: [])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        self.textToUpdate = "..."
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let evenTap1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        let evenTap2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.3)
        let evenTap3 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.6)
        
        
        var eventsBreatheIn = [CHHapticEvent]()
        eventsBreatheIn.append(evenTap1)
        eventsBreatheIn.append(evenTap2)
        
        
        var eventsHold = [CHHapticEvent]()
        eventsHold.append(evenTap1)
        
        var eventsBreatheOut = [CHHapticEvent]()
        eventsBreatheOut.append(evenTap1)
        eventsBreatheOut.append(evenTap2)
        eventsBreatheOut.append(evenTap3)
        
        
        let breatheInDuration = 4
        let holdDuration = 7
        let breatheOutDuration = 8
        
        let totalDuration = breatheInDuration + holdDuration + breatheOutDuration
        
        
        for id in 0...9999 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(id*totalDuration)) {
                print(String(id) + " - Breathe In")
                self.textToUpdate = "Breathe In"
                self.imageToUpdate = "arrow.down.heart.fill"
                play(events: eventsBreatheIn)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(id*totalDuration + breatheInDuration)) {
                print(String(id) + " - Hold")
                self.textToUpdate = "Hold..."
                self.imageToUpdate = "heart.fill"
                play(events: eventsHold)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(id*totalDuration + breatheInDuration + holdDuration)) {
                print(String(id) + " - Breathe Out")
                self.textToUpdate = "Breathe out"
                self.imageToUpdate = "arrow.up.heart.fill"
                play(events: eventsBreatheOut)
            }
        }
        
        
        self.imageToUpdate = "arrow.3.trianglepath"
        self.textToUpdate = "Start"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
