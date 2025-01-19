class Liquidacion {
  final int id;
  final double total;
  final double porcentaje21;
  final double porcentaje8;
  final double porcentaje7;
  final double restante;
  final DateTime fecha;

  Liquidacion({
    required this.id,
    required this.total,
    required this.porcentaje21,
    required this.porcentaje8,
    required this.porcentaje7,
    required this.restante,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'porcentaje21': porcentaje21,
      'porcentaje8': porcentaje8,
      'porcentaje7': porcentaje7,
      'restante': restante,
      'fecha': fecha.toIso8601String(),
    };
  }
}
