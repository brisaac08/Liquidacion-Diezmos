class Calculos {
  // Calcula el total del dinero ingresado
  static double calcularTotal(Map<int, int> cantidades) {
    double total = 0.0;
    cantidades.forEach((valor, cantidad) {
      total += valor * cantidad;
    });
    return total;
  }

  // Aplica los porcentajes al total
  static Map<String, double> aplicarPorcentajes(double total) {
    double porcentaje21 = total * 0.21;
    double porcentaje8 = total * 0.08;
    double porcentaje7 = total * 0.07;
    double restante = total - (porcentaje21 + porcentaje8 + porcentaje7);

    return {
      '21%': porcentaje21,
      '8%': porcentaje8,
      '7%': porcentaje7,
      'Restante': restante,
    };
  }
}
