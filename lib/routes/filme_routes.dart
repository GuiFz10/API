import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db.dart';

class FilmeRoutes {
  final Router router = Router();
  final DatabaseService db = DatabaseService();

  FilmeRoutes() {
    router.post('/filmes', _criarFilme);
    router.get('/filmes', _listarFilmes);
    router.get('/filmes/<id>', _buscarFilmePorId);
    router.put('/filmes/<id>', _atualizarFilme);
    router.delete('/filmes/<id>', _deletarFilme);
  }

  Future<Response> _criarFilme(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final titulo = data['titulo'];
      final genero = data['genero'];
      final ano = data['ano'];

      if (titulo == null || genero == null || ano == null) {
        return Response.badRequest(
          body: jsonEncode({'erro': 'Campos obrigatórios não enviados'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final id = db.inserirFilme(titulo, genero, ano);

      return Response(
        201,
        body: jsonEncode({
          'mensagem': 'Filme cadastrado com sucesso',
          'id': id,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'erro': 'Erro ao cadastrar filme'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Response _listarFilmes(Request request) {
    try {
      final filmes = db.listarFilmes();

      return Response.ok(
        jsonEncode(filmes),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'erro': 'Erro ao listar filmes'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Response _buscarFilmePorId(Request request, String id) {
    try {
      final filme = db.buscarFilmePorId(int.parse(id));

      if (filme == null) {
        return Response.notFound(
          jsonEncode({'erro': 'Filme não encontrado'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode(filme),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'erro': 'Erro ao buscar filme'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Future<Response> _atualizarFilme(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final titulo = data['titulo'];
      final genero = data['genero'];
      final ano = data['ano'];

      if (titulo == null || genero == null || ano == null) {
        return Response.badRequest(
          body: jsonEncode({'erro': 'Campos obrigatórios não enviados'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final atualizado = db.atualizarFilme(
        int.parse(id),
        titulo,
        genero,
        ano,
      );

      if (!atualizado) {
        return Response.notFound(
          jsonEncode({'erro': 'Filme não encontrado'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'mensagem': 'Filme atualizado com sucesso'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'erro': 'Erro ao atualizar filme'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Response _deletarFilme(Request request, String id) {
    try {
      final deletado = db.deletarFilme(int.parse(id));

      if (!deletado) {
        return Response.notFound(
          jsonEncode({'erro': 'Filme não encontrado'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'mensagem': 'Filme removido com sucesso'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'erro': 'Erro ao remover filme'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }
}