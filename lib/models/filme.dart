class Filme {
  final int? id;
  final String titulo;
  final String genero;
  final int ano;

  Filme({
    this.id,
    required this.titulo,
    required this.genero,
    required this.ano,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'genero': genero,
      'ano': ano,
    };
  }

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      genero: map['genero'] as String,
      ano: map['ano'] as int,
    );
  }
}