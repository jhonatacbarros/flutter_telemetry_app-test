# Configuração da API Key do Google Maps

Para que o Google Maps funcione corretamente, você precisa:

1. **Obter uma API Key do Google Maps:**

   - Acesse o [Google Cloud Console](https://console.cloud.google.com/)
   - Crie um novo projeto ou selecione um existente
   - Ative a API do Google Maps para Android e iOS
   - Gere uma API Key na seção "Credenciais"

2. **Configurar para Android:**
   - Edite o arquivo `android/app/src/main/AndroidManifest.xml`
   - Adicione sua API key no local indicado abaixo:

```xml
<application>
    <!-- TODO: Adicione sua API Key aqui -->
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR_API_KEY_HERE"/>
    <!-- Resto do conteúdo... -->
</application>
```

3. **Configurar para iOS:**

   - Edite o arquivo `ios/Runner/AppDelegate.swift`
   - Adicione sua API key conforme o exemplo em AppDelegate.swift

4. **Testando:**
   - Execute `flutter run` em um dispositivo físico ou emulador
   - O app funcionará mesmo sem a API key, mas o mapa pode ter uma marca d'água "For development purposes only"

## Funcionalidades do App

✅ **Localização GPS**: Mostra posição atual no mapa
✅ **Velocidade**: Calcula velocidade baseada no GPS (km/h)
✅ **Aceleração**: Lê dados do acelerômetro (m/s²)
✅ **Direção**: Mostra heading/bússola em graus
✅ **Controles**: Botões para iniciar/parar coleta de dados
✅ **Mapa**: Google Maps com marcador na posição atual
✅ **Interface**: Dados de telemetria em tempo real

## Para executar:

```bash
cd telemetry_app
flutter run
```

**Nota:** Para testar todas as funcionalidades, execute em um dispositivo físico, pois o simulador pode não ter todos os sensores disponíveis.
