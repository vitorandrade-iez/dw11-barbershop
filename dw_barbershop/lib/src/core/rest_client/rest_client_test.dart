import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:flutter/foundation.dart';

class RestClientTest {
  final RestClient _restClient;

  RestClientTest(this._restClient);

  Future<bool> testConnection() async {
    try {
      // Usar um endpoint público conforme config.yaml
      // Images está disponível sem autenticação (GET)
      final response = await _restClient.get('/images/');

      debugPrint(
          'Conexão com servidor REST bem-sucedida: ${response.statusCode}');
      // Consideramos 200 ou 404 como sucesso de conexão (o servidor está online)
      return response.statusCode == 200 || response.statusCode == 404;
    } catch (e) {
      debugPrint('Falha ao conectar com o servidor REST: $e');

      // Se recebemos um 403, a conexão está funcionando, só não temos autorização
      if (e.toString().contains('403')) {
        debugPrint('Servidor está acessível, mas requer autenticação');
        return true;
      }
      return false;
    }
  }
}
