import 'package:shelf/shelf.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['Authorization'];

      if (authHeader == null || authHeader.isEmpty) {
        return Response.forbidden('Acesso negado: token ausente');
      }

      if (authHeader != '123' && authHeader != 'Bearer 123') {
        return Response.forbidden('Acesso negado: token inválido');
      }

      return innerHandler(request);
    };
  };
}