class Tarea {
  int id;
  String titulo;
  bool estado;

  Tarea(this.id, this.titulo, this.estado);

  @override
  String toString() {
    return 'Tarea{id: $id, titulo: $titulo, estado: $estado}';
  }
}
