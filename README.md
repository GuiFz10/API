# CRUD de Filmes em Dart

API simples desenvolvida em Dart para a disciplina de Tópicos Especiais.

## Funcionalidades
- Cadastro de filmes
- Listagem de filmes
- Busca de filme por ID
- Atualização de filme
- Remoção de filme
- Autenticação via middleware com token fixo

## Tecnologias
- Dart
- Shelf
- Shelf Router
- SQLite

## Autenticação
As rotas são protegidas por token no header:

```http
Authorization: 123
````

## Rotas

* `POST /filmes`
* `GET /filmes`
* `GET /filmes/:id`
* `PUT /filmes/:id`
* `DELETE /filmes/:id`

## Como executar

```bash
dart pub get
dart run bin/server.dart
```

