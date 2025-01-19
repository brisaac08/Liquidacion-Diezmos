import 'package:flutter/material.dart';
import 'package:calculadora_de_diezmos/services/database_helper.dart';
import 'package:calculadora_de_diezmos/models/liquidacion.dart';

class LiquidadorScreen extends StatefulWidget {
  @override
  _LiquidadorScreenState createState() => _LiquidadorScreenState();
}

class _LiquidadorScreenState extends State<LiquidadorScreen> {
  final Map<int, TextEditingController> _controllers = {};
  double? _total;
  Map<String, double>? _resultados;

  @override
  void initState() {
    super.initState();
    [100000, 50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100]
        .forEach((value) {
      _controllers[value] = TextEditingController();
    });
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _calcular() {
    Map<int, int> cantidades = {};
    Map<String, double> valoresPorDenominacion = {};

    _controllers.forEach((valor, controller) {
      int cantidad = int.tryParse(controller.text) ?? 0;
      cantidades[valor] = cantidad;
      String tipo = valor >= 2000
          ? "Billetes de \$${valor.toString()}"
          : "Monedas de \$${valor.toString()}";
      valoresPorDenominacion[tipo] = valor.toDouble() * cantidad.toDouble();
    });

    double total = cantidades.entries
        .map((entry) => entry.key.toDouble() * entry.value.toDouble())
        .reduce((sum, element) => sum + element);

    double porcentaje21 = total * 0.21;
    double porcentaje8 = total * 0.08;
    double porcentaje7 = total * 0.07;
    double restante = total - porcentaje21 - porcentaje8 - porcentaje7;

    setState(() {
      _total = total;
      _resultados = {
        '21%': porcentaje21,
        '8%': porcentaje8,
        '7%': porcentaje7,
        'Restante': restante,
      };
    });

    _guardarLiquidacion();
  }

  void _guardarLiquidacion() async {
    if (_total != null && _resultados != null) {
      final liquidacion = Liquidacion(
        id: 0,
        total: _total!,
        porcentaje21: _resultados!['21%']!,
        porcentaje8: _resultados!['8%']!,
        porcentaje7: _resultados!['7%']!,
        restante: _resultados!['Restante']!,
        fecha: DateTime.now(),
      );

      final dbHelper = DatabaseHelper();
      await dbHelper.insertLiquidacion(liquidacion);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Liquidación guardada correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liquidador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingrese la cantidad de billetes y monedas:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ..._controllers.keys.map((value) {
                return TextField(
                  controller: _controllers[value],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: value >= 2000
                        ? 'Billetes de \$${value.toString()}'
                        : 'Monedas de \$${value.toString()}',
                  ),
                );
              }).toList(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calcular,
                child: Text('Calcular'),
              ),
              if (_total != null) ...[
                SizedBox(height: 16),
                Text(
                  'Total: \$${_total!.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
              if (_resultados != null) ...[
                SizedBox(height: 16),
                Text('21%: \$${_resultados!['21%']!.toStringAsFixed(2)}'),
                Text('8%: \$${_resultados!['8%']!.toStringAsFixed(2)}'),
                Text('7%: \$${_resultados!['7%']!.toStringAsFixed(2)}'),
                Text(
                  'Restante: \$${_resultados!['Restante']!.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
