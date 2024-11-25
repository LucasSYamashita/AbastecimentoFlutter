# Controle de Abastecimento de Veículos - Flutter

Este é um aplicativo móvel desenvolvido em Flutter para o controle de abastecimento de veículos. Ele permite que os usuários cadastrem seus veículos, registrem abastecimentos, visualizem o histórico de abastecimentos e editem os dados dos veículos.

## Funcionalidades

- **Cadastro de Veículos**: Os usuários podem adicionar e editar veículos, incluindo informações como nome, modelo, placa e ano de fabricação.
- **Registro de Abastecimentos**: O aplicativo permite que os usuários registrem abastecimentos, incluindo dados como quantidade de litros, quilometragem atual e data.
- **Histórico de Abastecimentos**: O histórico completo de abastecimentos é exibido, com a possibilidade de visualizar os detalhes de cada abastecimento.
- **Autenticação com Firebase**: O aplicativo utiliza a autenticação do Firebase para permitir que os usuários se registrem e façam login.
- **Armazenamento no Firestore**: Dados dos veículos e abastecimentos são armazenados no Firebase Firestore.

## Tecnologias Utilizadas

- Flutter: Framework para desenvolvimento de aplicativos móveis.
- Firebase: Usado para autenticação de usuários e armazenamento de dados (Firestore).
- Provider: Para gerenciar o estado do aplicativo.
- Dart: Linguagem de programação utilizada no Flutter.

## Instalação

Clone o repositório para sua máquina local:
   git clone https://github.com/LucasSYamashita/abastecimentoflutter.git

Navegue até o diretório do projeto:
cd abastecimentoflutter

Instale as dependências do projeto:
flutter pub get

## Configure o Firebase:
Crie um novo projeto no Firebase Console.
Adicione seu aplicativo Flutter ao projeto Firebase (Android/iOS).
Configure o Firebase Firestore e Firebase Authentication.
Baixe o arquivo google-services.json (para Android) ou GoogleService-Info.plist (para iOS) e coloque-os nas pastas apropriadas do seu projeto

Execute o aplicativo:

flutter run

# Como Usar
Tela de Login: Insira suas credenciais para fazer login ou registre-se para criar uma nova conta.
Tela de Veículos: Visualize todos os veículos cadastrados e adicione novos veículos. Você pode editar os veículos existentes também.
Tela de Abastecimento: Registre os abastecimentos dos veículos com detalhes como litros, quilometragem e data.
Tela de Histórico de Abastecimento: Consulte todos os abastecimentos realizados com informações detalhadas.

