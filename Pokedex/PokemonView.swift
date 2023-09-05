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
    @State  var dominantColor: Color?

    var body: some View {
        if let data = pokemon {
            ScrollView {
                VStack(spacing: 5) {
                    AsyncImage(url: URL(string: data.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .onAppear {
                                // Example usage of the getDominantColor function
                                getDominantColor(from: (URL(string: pokemon!.image) ?? URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png"))!) { color in
                            if let color = color {
                                        // Assign the dominant color to your SwiftUI property
                                        self.dominantColor = color
                                    }
                                }
                            }} placeholder: {
                        ProgressView()
                    }
                    Group{
                        Text("\(data.name)").bold()
                            .foregroundColor(dominantColor)
                 
                        Text("\(data.type)").bold()
                            .foregroundColor(dominantColor)
      
                        Text("\(data.abilities.joined(separator: ", "))").bold()
                            .foregroundColor(dominantColor)
             
                    }


                    HStack {
                    Text("HP: \(data.stats.hp)")
                            .bold()

                            .frame(width: 100, alignment: .trailing)
                            .foregroundColor(dominantColor )
                        ProgressBar(value: Float(data.stats.hp),color:dominantColor)
                                  .frame(height: 10)
                                  .padding()
                    }
                    HStack {
                    Text("ATK: \(data.stats.attack)")
                            
                            .bold()
                                .frame(width: 100, alignment: .trailing)
                            .foregroundColor(dominantColor) // Alinha o texto à direita

                        ProgressBar(value: Float(data.stats.defense),color:dominantColor)
                            .frame(height: 10)
                        .padding()
                        
                    }
                    HStack {
                        Text("DEF: \(data.stats.defense)")
                            .bold()
                            .frame(width: 100, alignment: .trailing)
                            .foregroundColor(dominantColor) // Alinha o texto à direita

                        ProgressBar(value: Float(data.stats.defense),color:dominantColor)
                              .frame(height: 10)
                              .padding()
                    }
                    HStack {
                        Text("SATK: \(data.stats.specialAttack)")
                            .bold()
                            .frame(width: 100, alignment: .trailing)
                            .foregroundColor(dominantColor) // Alinha o texto à direita

                        ProgressBar(value: Float(data.stats.specialAttack),color:dominantColor)
                              .frame(height: 10)
                              
                              .padding()
                    }
                    HStack {
                        Text("SDEF: \(data.stats.specialDefense)")
                            .bold()
                            .frame(width: 100, alignment: .trailing)
                            .foregroundColor(dominantColor) // Alinha o texto à direita

                        ProgressBar(value: Float(data.stats.specialDefense),color:dominantColor)
                              .frame(height: 10)
                              .padding()
                    }
                    HStack {
                        Text("SPD: \(data.stats.speed)")
                            .bold()
                            .frame(width: 100, alignment: .trailing)
                            .foregroundColor(dominantColor) // Alinha o texto à direita

                        ProgressBar(value: Float(data.stats.speed),color:dominantColor)
                              .frame(height: 10)
                              .padding()
                    }
                    Group{
                        // ... Other stats
                        Spacer() // Cria um espaço flexível entre o texto e o padding
                        Text("__About__").bold()
                            .font(.title2)
                            .foregroundColor(dominantColor) // Cor do texto

                        Spacer() // Cria um espaço flexível entre o texto e o padding

                        Text("\(data.story)")
                            .bold()
                            .foregroundColor(Color.white) // Cor do texto
                            .background(dominantColor) // Cor do plano de fundo
                            .multilineTextAlignment(.center)
				

                            .padding(20) //
                            .background(dominantColor)
                            .cornerRadius(20) // Valor do raio da borda arredondada
// Cor de fundo do paddingCor e largura da borda

                        Spacer() // Cria um espaço flexível entre o texto e o padding

                    }

                    
                }
                .padding()
            }.background(Color(red: 253/255, green: 253/255, blue: 253/255))
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
    var color: Color? // Adicione uma propriedade para a cor

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(color)
                    .opacity(0.7)
                Rectangle()
                    .frame(width: CGFloat(self.value) / 140 * geometry.size.width, height: geometry.size.height)
                    .foregroundColor(color) // Use a cor aqui
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
