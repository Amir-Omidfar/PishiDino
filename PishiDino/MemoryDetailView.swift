//
//  MemoryDetailView.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//

import SwiftUI

struct MemoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingEditView = false
    let memory: Memory
    @ObservedObject var viewModel: MemoryViewModel

    var body: some View {
        ScrollView {
            if let uiImage = loadImage(named: memory.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }

            Text(memory.title)
                .font(.title)
                .bold()
                .padding(.top)

            Text(formattedDate(memory.date))
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(memory.description)
                .padding()
        }
        .navigationTitle("Memory")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") {
                showingEditView = true
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditMemoryView(viewModel: viewModel, memory: memory)
        }
        
        if let audioFile = memory.audioFileName {
            AudioPlayerView(audioFileName: audioFile)
        }
    }
    
        
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func loadImage(named imageName: String) -> UIImage? {
        // First, try loading from the Documents directory
            let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(imageName)
            
            if FileManager.default.fileExists(atPath: docURL.path) {
                return UIImage(contentsOfFile: docURL.path)
            }

            // If not found, try loading from asset catalog
            return UIImage(named: imageName)
    }
}
