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

    @State var memory: MemoryEntity

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Memory Title", text: Binding(
                        get: { memory.title ?? "" },
                        set: { memory.title = $0 }
                    ))
                }

                Section(header: Text("Date")) {
                    DatePicker("Date", selection: Binding(
                        get: { memory.date ?? Date() },
                        set: { memory.date = $0 }
                    ), displayedComponents: .date)
                }

                Section(header: Text("Description")) {
                    TextEditor(text: Binding(
                        get: { memory.descriptionText ?? "" },
                        set: { memory.descriptionText = $0 }
                    ))
                    .frame(height: 100)
                }

                Section(header: Text("Image Name (from Assets)")) {
                    TextEditor(text: Binding(
                        get: {memory.imageName ?? ""},
                        set: {memory.imageName = $0}
                    ))
                    .frame(height: 100)
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
