//
//  ContentView.swift
//  Bike Tracker App
//
//  Created by Sicheng Jiang on 2023-09-09.
//

import SwiftUI
import MapKit

struct WorkoutView: View {
    @State var position: MapCameraPosition = .automatic
    @State var isStarted = false
    @State var isRunning = false
    @State var justRunning = false
    @State var pauseNumber = 0
    @State var satellite = false
    @State var progressTime = 0
    @State var distance = 0.0
    @ObservedObject var lm = LocationManager()
    @State var userCoordinates: [CLLocationCoordinate2D] = []
    @State var pauseCoordinates: [[CLLocationCoordinate2D]] = []
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    let timerWorkout = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Label("\(Stopwatch(progressTime: progressTime))", systemImage: "stopwatch")
                Label("\(String(format: "%.2f",distance/1000)) km",systemImage: "figure.outdoor.cycle")
            }
            HStack {
                if progressTime == 0 {
                    Label("Avg. Speed:\n0.0 kph",systemImage: "speedometer")
                } else {
                    Label("Avg. Speed:\n\(String(format: "%.1f",(distance / Double(progressTime))*3.6)) kph",systemImage: "speedometer")
                }
                Text("Current Speed:\n\(String(format: "%.1f",(lm.currentSpeed))) kph")
            }
            HStack {
                MapCompass()
                MapPitchToggle()
                Button {
                    satellite.toggle()
                } label: {
                    Label(satellite ? "Standard":"Satellite",systemImage: "globe")
                }
            }
            Map(position:$position) {
                if position.positionedByUser == true || position == .automatic {
                    Annotation("Your location", coordinate: lm.currentLocation ?? CLLocationCoordinate2D(latitude: 45, longitude: -100)) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 22)
                            Circle()
                                .fill(.blue)
                                .frame(width: 15)
                        }
                    }
                    .annotationTitles(.hidden)
                }
                if !userCoordinates.isEmpty {
                    MapPolyline(coordinates: userCoordinates)
                        .stroke(.blue, lineWidth: 5)
                }
            }
            .mapStyle(satellite ? .hybrid(elevation: .realistic) : .standard(elevation: .realistic))
            .mapControls() {
                MapUserLocationButton()
            }
            .onAppear() {
                position = .userLocation(fallback: .automatic)
            }
            .padding(.bottom)
            WorkoutButtons(
                isStarted: $isStarted,
                isRunning: $isRunning,
                justRunning: $justRunning,
                userCoordinates: $userCoordinates,
                pauseCoordinates: $pauseCoordinates,
                progressTime: $progressTime,
                distance: $distance)
            .padding()
            .onReceive(timer) { _ in
                if isRunning {
                    userCoordinates.append(lm.currentLocation ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
                    if userCoordinates.count > 1 {
                        if justRunning == false {
                            distance += calculateDistance(alat: Double(userCoordinates[userCoordinates.count-1].latitude), along: Double(userCoordinates[userCoordinates.count-1].longitude), blat: Double(userCoordinates[userCoordinates.count-2].latitude), blong: Double(userCoordinates[userCoordinates.count-2].longitude))
                        } else {
                            justRunning = false
                            pauseCoordinates.append([])
                            pauseCoordinates[pauseNumber].append(userCoordinates[userCoordinates.count-1])
                            pauseCoordinates[pauseNumber].append(userCoordinates[userCoordinates.count-2])
                            pauseNumber += 1
                        }
                    }
                }
            }
            .onReceive(timerWorkout) { _ in
                if isRunning {
                    progressTime += 1
                }
            }
        }
    }
}
