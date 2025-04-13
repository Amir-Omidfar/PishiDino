import Foundation
import CoreData
import SwiftUI

class MemoryViewModel: ObservableObject {
    @Published var memories: [MemoryEntity] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchMemories()
    }

    
    func fetchMemories() {
        let request: NSFetchRequest<MemoryEntity> = MemoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MemoryEntity.date, ascending: false)]

        do {
            memories = try context.fetch(request)
        } catch {
            print("⚠️ Failed to fetch memories:", error.localizedDescription)
        }
    }

    func addMemory(title: String, date: Date, description: String, imageName: String, audioFileName: String? = nil) {
        let newMemory = MemoryEntity(context: context)
        newMemory.id = UUID()
        newMemory.title = title
        newMemory.date = date
        newMemory.descriptionText = description
        newMemory.imageName = imageName
        newMemory.audioFileName = audioFileName

        saveContext()
        fetchMemories()
    }

    func updateMemory(_ memory: MemoryEntity) {
        saveContext()
        fetchMemories()
    }

    func deleteMemory(at offsets: IndexSet) {
        for index in offsets {
            let memory = memories[index]
            context.delete(memory)
        }

        saveContext()
        fetchMemories()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("💥 Failed to save context:", error.localizedDescription)
        }
    }
}
