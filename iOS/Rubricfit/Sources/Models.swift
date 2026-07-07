import Foundation

struct Criterion: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var name: String
    var done: Bool

    init(id: UUID = UUID(), createdAt: Date = Date(), name: String, done: Bool) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.done = done
    }
}
