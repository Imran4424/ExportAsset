//
//  HomeView.swift
//  ExportAsset
//
//  Created by Shah Md Imran Hossain on 16/7/23.
//

import AVFoundation
import CoreML
import CoreVideo
import SwiftUI

struct Line {
    var points = [CGPoint]()
    var color: Color = .black
    var lineWidth: Double = 5.0
}

struct HomeView: View {
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
    @State private var recognizedChar = "None"
    @State private var renderedImage = Image(systemName: "photo")
    @State private var pixelBuffer: CVPixelBuffer?
    @State private var canvasWidth: CGFloat = Constants.imageWidth
    @State private var canvasHeight: CGFloat = Constants.imageWidth
    @State private var ciImage = CIImage()
    
    @State private var modalDetail = false
    
    var canvasView: some View {
        Canvas { context, size in
            for line in lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                // creating an array of all touch points
                let newPoint = value.location
                currentLine.points.append(newPoint)
            })
            .onEnded({ _ in
                self.lines.append(currentLine)
                self.currentLine = Line(points: [])
            })
        )
        .background(Color.white)
        .frame(width: canvasWidth, height: canvasHeight)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                canvasView
                    .padding()
                HStack {
                    Button("CLEAR") {
                        self.lines = []
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .background(.red)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Export") {
                        modalDetail.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $modalDetail) {
                let content = Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                    }
                }
                .background(Color.white)
                .frame(width: canvasWidth, height: canvasHeight)
                
                ExportView(content)
            }
        }
    }
}

extension HomeView {
    @MainActor private func exportToPNG(content: some View) {
        // 1: Render Hello World with some modifiers
        let renderer = ImageRenderer(
            content: content.frame(width: canvasWidth, height: canvasHeight, alignment: .center)
        )
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

