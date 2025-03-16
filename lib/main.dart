import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _input = "0";

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        _input = "0";
        _output = "0";
      } else if (value == "=") {
        try {
          _output = _calculateResult(_input);
          _input = _output;
        } catch (e) {
          _output = "Error";
        }
      } else if (_output=="0"){
        _input += value;
        _output = value;
      } else {
        _input += value;
        _output += value;
      }
    });
  }

  String _calculateResult(String input) {
    try {
      input = input.replaceAll('×', '*').replaceAll('÷', '/');
      ShuntingYardParser p = ShuntingYardParser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return (eval % 1 == 0) ? eval.toInt().toString() : eval.toString();
    } catch (e) {
      return "Error";
    }
  }

  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: SizedBox (
        height: 110,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            backgroundColor: color ?? Colors.grey[800],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60),
                                          side: const BorderSide(
                                              color: Colors.white,
                                              width: 3,
                                            ),
            ),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      )

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3CFDA),
      body: Column(
        children: [
          const SizedBox(height: 100),
          const Text(
            "Pink Calculator 💞",
            style: TextStyle(
              fontSize: 40, // Cỡ chữ lớn
              fontWeight: FontWeight.w800,
              color: Color(0xFFEF6393)
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(25),
              child: Text(
                _output,
                style: const TextStyle(fontSize: 55, color: Colors.black),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: ["7", "8", "9", "÷"].map((e) => _buildButton(e, color: e=="÷" ? Color(0xFFF1719D) : Color(0xFFF198B6))).toList(),
              ),
              Row(
                children: ["4", "5", "6", "×"].map((e) => _buildButton(e, color: e=="×" ? Color(0xFFF1719D) : Color(0xFFF198B6))).toList(),
              ),
              Row(
                children: ["1", "2", "3", "-"].map((e) => _buildButton(e, color: e=="-" ? Color(0xFFF1719D) : Color(0xFFF198B6))).toList(),
              ),
              Row(
                children: ["C", "0", "=", "+"].map((e) => _buildButton(e, color: e == "0" ? Color(0xFFF198B6) :
                                                                                 e == "=" ? Color(
                                                                                     0xFF80AA75) :
                                                                                 e == "+" ? Color(0xFFF1719D) : Color(
                                                                                     0xFFCF5567) )).toList(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
