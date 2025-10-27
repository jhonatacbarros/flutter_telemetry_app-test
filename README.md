# 🛰 Telemetry App - Case Técnico Flutter

Um aplicativo Flutter que mostra dados de telemetria em tempo real, incluindo localização, velocidade, aceleração e direção.
[📱 Baixar o APK](https://github.com/jhonatacbarros/flutter_telemetry_app-test/raw/main/app-release.apk)
## 🎯 Funcionalidades

- **📍 Localização GPS**: Mostra a posição atual no mapa
- **🚗 Velocidade**: Calcula velocidade baseada no GPS (km/h)
- **📈 Aceleração**: Lê dados do acelerômetro (m/s²)
- **🧭 Direção**: Mostra heading/bússola em graus
- **🗺️ Mapa**: Google Maps com marcador na posição atual
- **⏯️ Controles**: Botões para iniciar/parar coleta de dados
- **📊 Interface**: Dados de telemetria atualizados em tempo real

## 🛠 Tecnologias Utilizadas

- **geolocator** → Localização e velocidade GPS
- **sensors_plus** → Dados do acelerômetro
- **google_maps_flutter** → Exibição do mapa
- **provider** → Gerenciamento de estado

## 🚀 Como Executar

1. **Clone/Navegue para o projeto:**

   ```bash
   cd telemetry_app
   ```

2. **Instale as dependências:**

   ```bash
   flutter pub get
   ```

3. **Configure a API Key do Google Maps** (opcional para desenvolvimento):

   - Veja instruções detalhadas em `README_SETUP.md`

4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

## 📱 Uso do Aplicativo

1. **Primeira execução**: O app solicitará permissões de localização
2. **Localização inicial**: Pressione o ícone 📍 para centralizar no mapa
3. **Iniciar telemetria**: Pressione "Start Tracking" para começar a coleta
4. **Visualizar dados**: Veja dados em tempo real na parte inferior da tela
5. **Parar telemetria**: Pressione "Stop Tracking" quando quiser parar

## 📊 Dados Coletados

| Dado             | Descrição                     | Unidade   |
| ---------------- | ----------------------------- | --------- |
| **Speed**        | Velocidade baseada no GPS     | km/h      |
| **Heading**      | Direção da bússola            | graus (°) |
| **Acceleration** | Magnitude total da aceleração | m/s²      |
| **Location**     | Coordenadas GPS               | lat, lng  |

## 🔧 Arquitetura

```
lib/
├── main.dart              # Ponto de entrada e UI principal
├── telemetry_provider.dart # Provider com lógica de telemetria
└── README_SETUP.md        # Instruções de configuração
```

### Provider Pattern

- **TelemetryProvider**: Gerencia estado de localização, sensores e streams
- **Consumer**: UI reativa que atualiza automaticamente com mudanças de estado
- **Streams**: Coleta contínua de dados de GPS e acelerômetro

## 📋 Requisitos do Sistema

- **Flutter SDK**: 3.35.6+
- **Dart**: 3.9.2+
- **Dispositivo físico** recomendado (para melhor experiência com sensores)
- **Permissões**: Localização (obrigatória)

## 🔐 Permissões

### Android (`android/app/src/main/AndroidManifest.xml`):

- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `INTERNET`

### iOS (`ios/Runner/Info.plist`):

- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`
- `NSMotionUsageDescription`

## 🐛 Resolução de Problemas

### Problema: Mapa não carrega

**Solução**: Configure a API Key do Google Maps (veja README_SETUP.md)

### Problema: Permissões negadas

**Solução**: Aceite as permissões ou vá em Configurações > App > Permissões

### Problema: Dados de aceleração não funcionam

**Solução**: Execute em dispositivo físico (simulador pode não ter sensores)

### Problema: GPS impreciso

**Solução**: Teste ao ar livre para melhor sinal GPS

## 📄 Licença

Este projeto foi desenvolvido como case técnico para demonstração de habilidades em Flutter.

---

**Desenvolvido por**: Case Técnico Flutter - Mobs2  
**Data**: Outubro 2025
