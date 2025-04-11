//
//  MemoryViewModel.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//
import Foundation
import SwiftUI

class MemoryViewModel: ObservableObject {
    @Published var memories: [Memory] = [] {
        didSet {
            saveMemories()
        }
    }

    private let saveKey = "SavedMemories"

    init() {
        loadMemories()
        loadSampleMemories()
    }

    func loadSampleMemories() {
        memories = [
            Memory(id: UUID(), title: "First Date", date: Date(timeIntervalSince1970: 1577836800), description: "We went to that old Plaza!", imageName: "28FD569C-FEF1-4A03-8402-3762F1510DAE"),
            Memory(id: UUID(), title: "Trip to Bowling Alley", date: Date(timeIntervalSince1970: 1609459200), description: "First Bowling Together", imageName: "4B2EDECB-FEE2-4EBE-8AD3-FC86C95FE7C2_1_105_c")
        ]
        saveMemories()
    }

    func addMemory(title: String, date: Date, description: String, imageName: String, audioFileName: String? = nil) {
        let newMemory = Memory(id: UUID(), title: title, date: date, description: description, imageName: imageName, audioFileName: audioFileName)
        memories.append(newMemory)
        saveMemories()
    }

    func updateMemory(_ memory: Memory) {
        if let index = memories.firstIndex(where: { $0.id == memory.id }) {
            memories[index] = memory
        }
    }

    func deleteMemory(at offsets: IndexSet) {
        memories.remove(atOffsets: offsets)
    }

    private func saveMemories() {
        if let encoded = try? JSONEncoder().encode(memories) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadMemories() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Memory].self, from: data) {
            memories = decoded
        }
    }
}
