# 🔑 Configuração da API Key do Google Maps

## 📍 Como Obter a API Key

### Passo 1: Acesse o Google Cloud Console

1. Vá para [Google Cloud Console](https://console.cloud.google.com/)
2. Faça login com sua conta Google

### Passo 2: Criar/Selecionar Projeto

1. Clique no dropdown de projeto (canto superior esquerdo)
2. Clique em "NEW PROJECT" ou selecione um existente
3. Dê um nome ao projeto (ex: "TelemetryApp")
4. Clique em "CREATE"

### Passo 3: Ativar APIs Necessárias

1. No menu lateral, vá em **APIs & Services > Library**
2. Pesquise e ative as seguintes APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Maps JavaScript API** (para web)

### Passo 4: Criar API Key

1. Vá em **APIs & Services > Credentials**
2. Clique em **+ CREATE CREDENTIALS > API Key**
3. Sua API Key será gerada (ex: `AIzaSyBOti4mM-6x9WDnZIjIeyb01J_ABCDEFGH`)
4. **IMPORTANTE**: Clique em "RESTRICT KEY" para configurar restrições

### Passo 5: Configurar Restrições (Recomendado)

1. **Application restrictions**: Selecione as plataformas que usará
   - **Android apps**: Adicione o package name (`com.example.telemetry_app`)
   - **iOS apps**: Adicione o bundle ID
   - **HTTP referrers**: Para web
2. **API restrictions**: Selecione apenas as APIs que ativou
3. Clique em **SAVE**

## ⚙️ Configuração no Projeto

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<application>
    <!-- Adicione sua API Key aqui -->
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="AIzaSyBOti4mM-6x9WDnZIjIeyb01J_ABCDEFGH"/>
    <!-- Resto do conteúdo... -->
</application>
```

### iOS (`ios/Runner/AppDelegate.swift`)

```swift
import GoogleMaps

override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
  // Adicione sua API Key aqui
  GMSServices.provideAPIKey("AIzaSyBOti4mM-6x9WDnZIjIeyb01J_ABCDEFGH")
  GeneratedPluginRegistrant.register(with: self)
  return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

## 💡 Informações Importantes

### ✅ O App Funciona Sem API Key

- O app **funcionará normalmente** mesmo sem configurar a API Key
- O mapa terá uma marca d'água "For development purposes only"
- Todas as outras funcionalidades (GPS, sensores) funcionam perfeitamente

### 💰 Custos

- Google Maps oferece **$200 de crédito gratuito por mês**
- Para desenvolvimento e teste, raramente excede o limite gratuito
- Veja detalhes em: [Google Maps Pricing](https://cloud.google.com/maps-platform/pricing)

### 🔒 Segurança

- **NUNCA** commite API Keys no código fonte
- Use restrições de API para limitar uso
- Para produção, considere usar variáveis de ambiente

## 🚀 Testando

```bash
# Executar no Chrome (não precisa de API Key)
flutter run -d chrome

# Executar no dispositivo Android
flutter run -d android

# Executar no iOS (requer Xcode)
flutter run -d ios
```

## 🛠 Funcionalidades do App

✅ **Localização GPS**: Posição atual no mapa  
✅ **Velocidade**: Calculada via GPS (km/h)  
✅ **Aceleração**: Dados do acelerômetro (m/s²)  
✅ **Direção**: Heading/bússola em graus  
✅ **Controles**: Start/Stop coleta de dados  
✅ **Interface**: Dados em tempo real

## 🐛 Resolução de Problemas

### Problema: "This page can't load Google Maps correctly"

**Solução**: Configure a API Key conforme instruções acima

### Problema: Mapa não aparece no Android

**Solução**: Verifique se a API Key está no AndroidManifest.xml

### Problema: Permissões negadas

**Solução**: Aceite permissões de localização quando solicitado

### Problema: Sensores não funcionam

**Solução**: Execute em dispositivo físico (simulador pode não ter sensores)

---

**💡 Dica**: Para desenvolvimento, você pode usar o app sem API Key. Configure apenas quando for para produção!
