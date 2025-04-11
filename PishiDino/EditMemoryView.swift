//
//  EditMemoryView.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//

import SwiftUI

struct EditMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MemoryViewModel

    @State var memory: Memory

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Memory Title", text: $memory.title)
                }

                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $memory.date, displayedComponents: .date)
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $memory.description)
                        .frame(height: 100)
                }

                Section(header: Text("Image Name (from Assets)")) {
                    TextField("e.g. paris_trip", text: $memory.imageName)
                }
            }
            .navigationTitle("Edit Memory")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.updateMemory(memory)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
