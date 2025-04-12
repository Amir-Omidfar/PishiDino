//
//  ContentView.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//
import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: MemoryViewModel
    @State private var showingAddMemory = false
    init(context: NSManagedObjectContext) {
            _viewModel = StateObject(wrappedValue: MemoryViewModel(context: context))
        }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.memories) { memory in
                    MemoryRow(memory: memory, viewModel: viewModel)
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


}





struct MemoryRow: View {
    let memory: MemoryEntity
    let viewModel: MemoryViewModel

    var body: some View {
        NavigationLink(destination: MemoryDetailView(memory: memory, viewModel: viewModel)) {
            HStack {
                memoryImage
                VStack(alignment: .leading) {
                    Text(memory.title ?? "Untitled")
                        .font(.headline)
                    
                    Text(memory.date.map(formattedDate) ?? "No Date")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }

    var memoryImage: some View {
        Group {
            if let imageName = memory.imageName,
               let uiImage = loadImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image(systemName: "kitten")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
        .scaledToFill()
        .frame(width: 60, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func loadImage(named imageName: String) -> UIImage? {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(imageName)

        if FileManager.default.fileExists(atPath: docURL.path) {
            return UIImage(contentsOfFile: docURL.path)
        }

        return UIImage(named: imageName)
    }
}
