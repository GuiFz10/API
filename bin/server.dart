import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import '../lib/middleware/auth_middleware.dart';
import '../lib/routes/filme_routes.dart';

void main() async {
  final filmeRoutes = FilmeRoutes();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(authMiddleware())
      .addHandler(filmeRoutes.router.call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);

  print('Servidor rodando em http://localhost:${server.port}');
}