//
//  ExportView.swift
//  ExportAsset
//
//  Created by Shah Md Imran Hossain on 16/7/23.
//

import SwiftUI

@MainActor
struct ExportView<Content: View>: View {
    let content: Content
    let options = ["PDF", "PNG"]
    @State private var selectedOption = "PDF"
    @State private var renderedImage = Image(systemName: "photo")
    @Environment(\.dismiss) var dismiss
    
    init(_ content: Content) {
        self.content = content
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Group {
                    Spacer()
                    Spacer()
                    Spacer()
                    ShareLink("Export", item: renderedImage, preview: SharePreview(Text("Rendered Image"), image: renderedImage))
                    Spacer()
                    Spacer()
                }
            }
            .onAppear {
                exportToPNG()
            }
            .navigationBarItems(
                trailing: Button("X") { dismiss() }.padding()
            )
        }
    }
}

// MARK: - Methods
extension ExportView {
    private func exportToPNG() {
        // 1: Render Hello World with some modifiers
        let renderer = ImageRenderer(
            content: content.frame(width: Constants.imageWidth, height: Constants.imageWidth, alignment: .center)
        )
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView(Text("Hello World"))
    }
}

