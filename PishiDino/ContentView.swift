//
//  ContentView.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = MemoryViewModel()
    @State private var showingAddMemory = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.memories) { memory in
                    NavigationLink(destination: MemoryDetailView(memory: memory, viewModel: viewModel)) {
                        HStack {
                            
                            if let uiImage = loadImage(named: memory.imageName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Image(systemName: "kitten")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .foregroundColor(.gray)
                            }

                            VStack(alignment: .leading) {
                                Text(memory.title).font(.headline)
                                Text(formattedDate(memory.date)).font(.subheadline).foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteMemory)
            }
            .navigationTitle("Our Story 💕")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMemory = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMemory) {
                AddMemoryView(viewModel: viewModel)
            }
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
