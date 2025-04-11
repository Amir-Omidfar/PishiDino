//
//  AddMemoryView.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//
import SwiftUI
import PhotosUI
struct AddMemoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MemoryViewModel

    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var description: String = ""
    @State private var imageName: String = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var audioFileName: String? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Memory Title", text: $title)
                }

                Section(header: Text("Date")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }

                Section(header: Text("Photo")) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Select from Library")
                        }
                    }

                    if let data = selectedImageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                }
                
                Section(header: Text("Voice Memory")) {
                    HStack {
                        Button(action: {
                            if audioRecorder.isRecording {
                                audioRecorder.stopRecording()
                            } else {
                                let name = UUID().uuidString + ".m4a"
                                audioFileName = name
                                audioRecorder.startRecording(to: name)
                            }
                        }) {
                            Label(audioRecorder.isRecording ? "Stop Recording" : "Start Recording",
                                  systemImage: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        }
                        .foregroundColor(audioRecorder.isRecording ? .red : .blue)
                    }

                    if let audioFileName {
                        Text("🎧 Recorded: \(audioFileName)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Add Memory")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var imageName = ""

                        if let data = selectedImageData {
                            let id = UUID().uuidString
                            imageName = "\(id).jpg"

                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                .appendingPathComponent(imageName)

                            try? data.write(to: url)
                        }

                        viewModel.addMemory(title: title, date: date, description: description, imageName: imageName, audioFileName: audioFileName)
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
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }
    
}
