# 🔧 Configuração Local da API Key

Para configurar a API Key do Google Maps no seu ambiente local:

## 1. Android (AndroidManifest.xml)

Edite o arquivo `android/app/src/main/AndroidManifest.xml` e descomente/adicione:

```xml
<application>
    <!-- Descomente e adicione sua API Key -->
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="SUA_API_KEY_AQUI"/>
</application>
```

## 2. iOS (AppDelegate.swift)

Edite o arquivo `ios/Runner/AppDelegate.swift` e descomente/adicione:

```swift
override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
  // Descomente e adicione sua API Key
  GMSServices.provideAPIKey("SUA_API_KEY_AQUI")
  GeneratedPluginRegistrant.register(with: self)
  return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

## 3. Sua API Key

A API Key está no arquivo `.env`:

```
GOOGLE_MAPS_API_KEY=AIzaSyCoCt8pXWGTFLhpTqU8v4UP65PY74tQ9aw
```

## ⚠️ IMPORTANTE

- **NÃO** commite a API Key nos arquivos de código
- Mantenha apenas no arquivo `.env` (que está no .gitignore)
- Configure manualmente em cada ambiente local

## 🚀 App Funciona Sem API Key

O app funciona perfeitamente sem a API Key, apenas com uma marca d'água no mapa.

Todas as funcionalidades de telemetria (GPS, velocidade, aceleração, bússola) funcionam normalmente!
