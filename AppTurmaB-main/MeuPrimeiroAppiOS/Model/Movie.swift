struct Pokemon: Decodable {
    let number: Int
    let name: String
    let type: String
    let image: String
    let stats: Stats
    let abilities: [String]

    private enum CodingKeys: String, CodingKey {
        case number
        case name
        case type
        case image
        case stats
        case abilities
    }
}

struct Stats: Decodable {
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
}
