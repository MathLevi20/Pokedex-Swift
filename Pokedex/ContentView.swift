import SwiftUI


struct Pokemon: Codable {
    let number: Int
    let name: String
    let type: String
    let image: String
    let stats: Stats
    let story: String
    let abilities: [String]
}

struct Stats: Codable {
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
}

struct PokemonRowView: View {
    let pokemon: Pokemon
    
    var body: some View {
        NavigationLink(destination: PokemonDetailView(receivedNumber: pokemon.number)) { // Adicione um NavigationLink
            
            HStack {
                AsyncImage(url: URL(string: pokemon.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
                
                Text(String(pokemon.number))
                Text(pokemon.name)
                Spacer()
                Text(pokemon.type)
            }
        }  .navigationTitle("Navegação")
    }
}


struct PokemonListView: View {
    @State private var pokemonList: [Pokemon] = []
    @State private var showPokemonView = false
    
    var body: some View {

        NavigationView {
                VStack{

            List(pokemonList, id: \.number) { pokemon in
                PokemonRowView(pokemon: pokemon)
            }
        .onAppear {
            fetchData()
        }
                }
            }
    }

    private func fetchData() {
        guard let apiUrl = URL(string: Constants.apiURL) else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: apiUrl) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.pokemonList = apiResponse.result
                    }
                    print("API Data: \(apiResponse)")
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
}

struct APIResponse: Codable {
    let result: [Pokemon]
}

struct Constants {
    static let apiURL = "https://pokede.onrender.com/pokemon"
}

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
      
                PokemonListView()
            
        }
    }
}

// Sample data
let samplePokemonData = Pokemon(
    number: 2,
    name: "Ivysaur",
    type: "Grass/Poison",
    image: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/002.png",
    stats: Stats(hp: 60, attack: 62, defense: 63, specialAttack: 80, specialDefense: 80, speed: 60),
    story: "Ivysaur is the evolved form of Bulbasaur. It has a larger bulb on its back that supports its growing plant. Ivysaur is more independent and capable of moving quickly. It can shoot seeds and vines from its bulb to attack opponents. As Ivysaur continues to evolve, its plant grows into a large and powerful flower.",
    abilities: ["Overgrow", "Chlorophyll"]
)

