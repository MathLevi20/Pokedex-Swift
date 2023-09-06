# Pokédex Mobile App (Swift)

Bem-vindo ao repositório do aplicativo móvel da Pokédex, desenvolvido em Swift. Este aplicativo permite que você explore informações sobre Pokémon de forma fácil e divertida. Este README fornecerá informações sobre como configurar, executar e contribuir para o projeto.

## Visão Geral

Este aplicativo móvel é a interface do usuário do projeto Pokédex e permite que os usuários visualizem informações detalhadas sobre diferentes Pokémon. Ele utiliza o Swift como linguagem de programação e depende do uso do CocoaPods para gerenciar suas dependências.

## Configuração

### Pré-requisitos

Antes de começar, certifique-se de ter o seguinte instalado:

- Xcode
- CocoaPods

### Configurando o Projeto

1. Clone este repositório:

   ```bash
   git clone https://github.com/seu-usuario/pokedex-mobile-swift.git
Navegue até o diretório raiz do projeto:

bash
Copy code
cd pokedex-mobile-swift
Abra um terminal e execute o comando para criar um arquivo Podfile:

bash
Copy code
pod init

Edite o arquivo Podfile para adicionar as dependências do CocoaPods necessárias. Por exemplo, se você precisa do Alamofire e do SwiftyJSON, seu Podfile pode ficar assim:

ruby
Copy code
platform :ios, '13.0'
use_frameworks!

target 'Pokedex' do
  pod 'Alamofire', '~> 5.0'
  pod 'SwiftyJSON', '~> 5.0'
end
Salve o arquivo Podfile e, em seguida, no terminal, execute o comando para instalar as dependências:

bash
Copy code
pod install
Feche o projeto no Xcode e abra o arquivo .xcworkspace gerado (por exemplo, Pokedex.xcworkspace) para usar o projeto com as dependências do CocoaPods.

Uso
Após configurar o projeto, você pode executar o aplicativo no Xcode, seja em um simulador iOS ou em um dispositivo real. Explore a Pokédex, pesquise Pokémon e aproveite!

Contribuição
Se você deseja contribuir para este projeto, siga estas etapas:

Faça um fork deste repositório.

Crie uma branch para a sua contribuição:

bash
Copy code
git checkout -b minha-contribuicao
Faça as alterações desejadas e adicione commits significativos.

Envie as alterações para o seu fork:

bash
Copy code
git push origin minha-contribuicao
Abra um pull request para revisão.

Licença
Este projeto é licenciado sob a Licença MIT. Consulte o arquivo LICENSE para obter detalhes.
