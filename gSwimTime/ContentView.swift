//
//  ContentView.swift
//  gSwimTime
//
//  Created by angi1g on 19/01/24.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var timerSetSecs = 135
    @State private var timerValSecs = 0
    @State private var timerRunning = false
    @State private var timerLaps = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // background
            Color.white
                .ignoresSafeArea()
            
            VStack {
                Image("logoNS-2")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                Text(secondsToFormattedString(timerValSecs))
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(Color("colorNS"))
                
                Text("\(timerLaps * 100) mt")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(Color("colorNS"))
                
                HStack {
                    Spacer()
                    Button {
                        timerRunning = true
                        if timerValSecs == 0 && timerLaps == 0 {
                            timerValSecs = -5
                            timerLaps = 0
                        }
                    } label: {
                        Image(systemName: "figure.pool.swim")
                    }
                    Spacer()
                    Button {
                        timerRunning = false
                    } label: {
                        Image(systemName: "pause.fill")
                    }
                    Spacer()
                }
                .font(.system(size: 50))
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Stepper("", value: $timerSetSecs, in: 120...150)
                        .labelsHidden()
                    Spacer()
                    Text(secondsToFormattedString(timerSetSecs))
                    Spacer()
                }
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(Color("colorNS"))
            }
            .padding()
            .onReceive(timer) { _ in
                if timerRunning {
                    timerValSecs += 1
                    if timerValSecs == timerSetSecs {
                        AudioServicesPlaySystemSound(1013)
                        timerValSecs = 0
                        timerLaps += 1
                    }
                }
            }
        }
        .onAppear(perform: {
            UIApplication.shared.isIdleTimerDisabled = true
        })
        .onDisappear(perform: {
            UIApplication.shared.isIdleTimerDisabled = false
        })
    }
    
    func secondsToFormattedString (_ seconds: Int) -> String {
        return String(format: "%02i:%02i", seconds / 60, seconds % 60)
    }
}

#Preview {
    ContentView()
}
