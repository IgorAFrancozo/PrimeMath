import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const PrimeMath());

class PrimeMath extends StatelessWidget {
  const PrimeMath({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double tamanhoIcone = 160.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prime Math',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Tabuada',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            IconButton(
              icon: const Icon(Icons.keyboard),
              iconSize: tamanhoIcone,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NumericKeyboardScreen()),
                );
              },
            ),
            const Text(
              'Calculadora',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            IconButton(
              icon: const Icon(Icons.calculate),
              iconSize: tamanhoIcone,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculadoraScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NumericKeyboardScreen extends StatefulWidget {
  @override
  _NumericKeyboardScreenState createState() => _NumericKeyboardScreenState();
}

class _NumericKeyboardScreenState extends State<NumericKeyboardScreen> {
  final TextEditingController _controller = TextEditingController();

  void _calcularTabuada() {
    String input = _controller.text;
    if (input.isNotEmpty) {
      int numero = int.parse(input);
      String tabuada = '';
      for (int i = 1; i <= 10; i++) {
        int resultado = numero * i;
        tabuada += '$numero x $i = $resultado\n';
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(textAlign: TextAlign.center, 'Tabuada do Nº $numero'),
            content: Text(textAlign: TextAlign.center, tabuada),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voltar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                'Digite o Número'),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularTabuada,
              child: const Text('Gerar Tabuada'),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculadoraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voltar'),
      ),
      body: CalculadoraWidget(),
    );
  }
}

class CalculadoraWidget extends StatefulWidget {
  @override
  _CalculadoraWidgetState createState() => _CalculadoraWidgetState();
}

class _CalculadoraWidgetState extends State<CalculadoraWidget> {
  String _equation = '';
  String _result = '';

  void _onButtonPressed(String text) {
    setState(() {
      if (text == '=') {
        try {
          // Substitua os caracteres × e ÷ por * e / respectivamente
          String equation = _equation.replaceAll('×', '*').replaceAll('÷', '/');
          Parser parser = Parser();
          Expression expression = parser.parse(equation);
          ContextModel contextModel = ContextModel();
          double eval = expression.evaluate(EvaluationType.REAL, contextModel);
          _result = eval.toString();
        } catch (e) {
          _result = 'Erro';
        }
        _equation = '';
      } else if (text == 'C') {
        _equation = '';
        _result = '';
      } else {
        _equation += text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.bottomRight,
            child: Text(
              _equation,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.bottomRight,
            child: Text(
              _result,
              style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: <Widget>[
              _buildButtonRow(['7', '8', '9', '÷']),
              _buildButtonRow(['4', '5', '6', '×']),
              _buildButtonRow(['1', '2', '3', '-']),
              _buildButtonRow(['C', '0', '=', '+']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons
            .map((button) => Expanded(
          child: InkWell(
            onTap: () => _onButtonPressed(button),
            child: Container(
              margin: const EdgeInsets.all(5.0), // Espaço entre os botões
              decoration: BoxDecoration(
                color: button == 'C' ||
                    button == '+' ||
                    button == '-' ||
                    button == '×' ||
                    button == '÷'
                    ? Colors.red
                    : Colors.blue,
                borderRadius: BorderRadius.circular(10.0), // Borda arredondada
              ),
              child: Center(
                child: Text(
                  button,
                  style: const TextStyle(
                      fontSize: 34, color: Colors.white),
                ),
              ),
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}