class RestClientConfig {
  // Configuração para quando estiver executando em emulador Android
  static const String emulatorBaseUrl = 'http://10.0.2.2:8080/';

  // Configuração para quando estiver executando em dispositivo físico
  // Use o IP da sua máquina na mesma rede do dispositivo
  static const String deviceBaseUrl = 'http://192.168.1.X:8080/';

  // Defina o tipo de ambiente atual
  static const String baseUrl = emulatorBaseUrl;

  // Tempo limite para conexão com o servidor
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 60);
}
