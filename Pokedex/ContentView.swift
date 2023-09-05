import SwiftUI
import UIImageColors
import SDWebImageSwiftUI


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
    
    func extractColor(from inputString: String, pokemonData: [String: PokemonType]) -> Color {
        if let pokemonType = pokemonData[inputString] {
            print("Color: \(pokemonType.color)") // Exibe a cor no console
            debugPrint("Color: \(pokemonType.color)")
            debugPrint(Color(pokemonType.color) )// Exibe a cor no console de depuração
            let lowercaseColorString = pokemonType.color

            switch lowercaseColorString {
            case "red":
                return Color.red
            case "blue":
                return Color.blue
            case "green":
                return Color.green
            case "bronw":
                return Color.brown
  
            // Adicione mais casos para outras cores conforme necessário
            default:
                return Color.gray
            }
            return Color(pokemonType.color)
        } else {
            return Color.gray
        }


    }
    
    struct PokemonType {
        let color: String
        let exampleAbility: String
    }
    
    // Sample data
    let samplePokemonData: [String: PokemonType] = [
        "Grass/Poison": PokemonType(color: "green", exampleAbility: "Overgrow"),
        "Fire": PokemonType(color: "red", exampleAbility: "Blaze"),
        "Water": PokemonType(color: "blue", exampleAbility: "Torrent"),
        "Bug": PokemonType(color: "green", exampleAbility: "Shield Dust"),
        "Normal/Flying": PokemonType(color: "brown", exampleAbility: "Keen Eye"),
        // Adicione mais tipos de Pokémon conforme necessário
    ]
    @State private var dominantColor: Color?

    var body: some View {


        NavigationLink(destination: PokemonDetailView(receivedNumber: pokemon.number)) {
            HStack {
                let randomColor = Color(
                    red: Double.random(in: 0...1),
                    green: Double.random(in: 0...1),
                    blue: Double.random(in: 0...1)
                )
                let typeColor = extractColor(from: pokemon.type, pokemonData: samplePokemonData)

        
                AsyncImage(url: URL(string: pokemon.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .onAppear {
                                // Example usage of the getDominantColor function
                                getDominantColor(from: (URL(string: pokemon.image) ?? URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png"))!) { color in
                                    if let color = color {
                                        // Assign the dominant color to your SwiftUI property
                                        self.dominantColor = color
                                    }
                                }
                            
                                                 
                                                 }
                    default:
                        ProgressView()
                    }
                }


                Text(String(pokemon.number))
                Text(pokemon.name)
                Spacer()
                Text(pokemon.type).background(Color("CellBackgroundColor"))
            }
        }
        .navigationBarTitle("Pokedex")
        .background(dominantColor)
        .buttonStyle(BorderlessButtonStyle()) // Remove the white border
        .padding(10) //
        .background(dominantColor)
        .cornerRadius(10)
    }


 



}

import SwiftUI
import UIKit
import UIImageColors

func getDominantColor(from imageURL: URL, completion: @escaping (Color?) -> Void) {
    // Download the image from the URL
    URLSession.shared.dataTask(with: imageURL) { data, _, error in
        if let data = data, let uiImage = UIImage(data: data) {
            // Resize the UIImage if needed
            let size = CGSize(width: 100, height: 100) // Ajuste o tamanho conforme necessário
            let resizedImage = uiImage.resize(to: size)
            
            // Get the dominant color using UIImageColors
            resizedImage.getColors { colors in
                if let colors = colors {
                    // Convert UIColor to SwiftUI Color
                    let swiftUIColor: Color
                    
                    if let uiColor = colors.background {
                        if uiColor.isBlackOrVeryDark() {
                            // Se a cor for preta ou muito escura, use a cor secundária
                            swiftUIColor = Color(colors.secondary)
                        } else {
                            swiftUIColor = Color(uiColor)
                        }
                        completion(swiftUIColor)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }.resume()
}

extension UIColor {
    func isBlackOrVeryDark() -> Bool {
        var white: CGFloat = 0
        self.getWhite(&white, alpha: nil)
        return white <= 0.2 // Você pode ajustar este limite conforme necessário
    }
}


extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}



struct PokemonListView: View {
    @State private var pokemonList: [Pokemon] = []
    @State private var showPokemonView = false
        @State private var searchText: String = ""
        var filteredPokemonList: [Pokemon] {
            if searchText.isEmpty {
                return pokemonList
            } else {
                return pokemonList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
        }

            var body: some View {

            NavigationView {
                    VStack{
                        SearchBar(text: $searchText)
                                .padding(.horizontal)
                                .padding(.bottom, 7.0)
                        
                        List(filteredPokemonList, id: \.number) { pokemon in
                                 PokemonRowView(pokemon: pokemon)
                        }.listStyle(.plain)          .onAppear {
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
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.vertical, 10)
                .padding(.horizontal, 10.0)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            
            Spacer() // Empurra o botão "x" para a extremidade direita
            
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    
                    .foregroundColor(.gray)
                    .opacity(text.isEmpty ? 0 : 1)
            }
        }.padding(.leading, 20.0)
    }
}

struct ContentView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

        




// Define a structure to represent Pokémon types and their attributes
