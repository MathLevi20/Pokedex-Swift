//
//  PokemonView.swift
//  Pokedex
//
//  Created by Matheus Levi on 23/08/23.
//

import SwiftUI



/*struct PokemonView: View {
    let pokemon: Pokemon? // Receive the selected Pokemon

    var body: some View {
        VStack {
            Text("Selected Pokémon:")
            if let pokemon = pokemon {
                Text(pokemon.name)
                // Display other details of the selected Pokemon
            } else {
                Text("No Pokémon selected")
            }
        }
    }
}

extension Optional where Wrapped == Pokemon {
    var isNotNil: Bool {
        self != nil
    }
}*/

import SwiftUI



struct PokemonDetailView: View {
    @State private var pokemon: Pokemon?
    let receivedNumber: Int
    
    var body: some View {
        if let data = pokemon {
            ScrollView {
                VStack(spacing: 10) {
                    AsyncImage(url: URL(string: data.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                    Text("Name: \(data.name)")
             
                    Text("Type: \(data.type)")
                    HStack {
                    Text("HP: \(data.stats.hp)").frame(width: 120, alignment: .trailing)

                        ProgressBar(value: Float(data.stats.hp))
                                  .frame(height: 10)
                                  .padding()
                    }
                    HStack {
                    Text("Attack: \(data.stats.attack)").frame(width: 120, alignment: .trailing) // Alinha o texto à direita

                    ProgressBar(value: Float(data.stats.attack))
                              .frame(height: 10)
                        .padding()
                        
                    }
                    HStack {
                        Text("Defense: \(data.stats.defense)").frame(width: 120, alignment: .trailing) // Alinha o texto à direita

                        ProgressBar(value: Float(data.stats.defense))
                              .frame(height: 10)
                              .padding()
                    }
                    // ... Other stats
                    Text("Abilities: \(data.abilities.joined(separator: ", "))")
                    Text("Story: \(data.story)")
                    
                }
                .padding()
            }
        } else {
            Text("Loading...")
                .onAppear {
                    fetchData()
                }
        }
    }
    
    private func fetchData() {
        guard let apiUrl = URL(string: "https://pokede.onrender.com/pokemon/\(receivedNumber)") else {
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
                    let apiResponse = try JSONDecoder().decode(Pokemon.self, from: data)
                    DispatchQueue.main.async {
                        self.pokemon = apiResponse
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


struct ProgressBar: View {
    var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.2)
                
                Rectangle()
                    .frame(width: CGFloat(self.value) / 100 * geometry.size.width, height: geometry.size.height)
                    .foregroundColor(.blue)
            }
            .cornerRadius(45.0)
        }
    }
}

struct PokemonDetail: View {
    let pokemonNumber: Int
    
    var body: some View {
        Text("Detail view for Pokémon number \(pokemonNumber)")
    }
}
