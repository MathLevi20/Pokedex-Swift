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
                    Text("HP: \(data.stats.hp)")
                    Text("Attack: \(data.stats.attack)")
                    Text("Defense: \(data.stats.defense)")
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




struct PokemonDetail: View {
    let pokemonNumber: Int
    
    var body: some View {
        Text("Detail view for Pokémon number \(pokemonNumber)")
    }
}
