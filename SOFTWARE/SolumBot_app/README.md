# SolumBot App

## Descrição
Este é o aplicativo móvel **SolumBot**, desenvolvido em Kotlin para Android. Ele permite controlar o robô Solum de forma remota via Bluetooth, utilizando módulos HC-05, e interagir com os módulos de locomoção. É possível utilizar o app para controlar os seus próprios robôs, fazendo pequenas alterações no código, se necessário.

## Estrutura do App
SolumBot_app/
├── src/
│ ├── main/
│ │ ├── java/ # Código-fonte Kotlin/Java
│ │ ├── res/ # Layouts, imagens, ícones, cores, strings
│ │ └── AndroidManifest.xml
├── release/
│ └── SolumBot_v1.0.apk # APK compilado
├── build.gradle.kts # Configurações de build e dependências
└── README.md # Este arquivo


### src/
- Contém todo o código-fonte e recursos necessários para compilar o app.
- Não inclui pastas de build, caches ou configurações do Android Studio.

### res/
- Contém layouts, imagens, ícones, cores, strings e arquivos XML de configuração.
- É essencial para a interface e recursos do app.

### release/
- Contém os APKs compilados do SolumBot.
- Cada APK pode ser instalado diretamente em dispositivos Android.
- **Observação:** cada módulo Bluetooth tem endereço MAC único; para usar outro módulo, altere o endereço MAC no código.

### build.gradle.kts
- Contém todas as dependências, versão do SDK, configurações de compilação e plugins.
- É usado para compilar e gerar o APK.

## Pré-requisitos
- Android Studio (recomenda-se versão 2022.1 ou superior)
- SDK Android 21 ou superior
- Dispositivo Android ou emulador para testes
- Conexão Bluetooth habilitada

## Como Rodar
1. Clone o repositório:
   ```bash
   git clone https://github.com/Azazel-Admetus/projeto_caelum.git
