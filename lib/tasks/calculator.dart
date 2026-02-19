import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = "0";
  String _currentInput = "";
  String _operator = "";
  double _num1 = 0;

  void _buttonPressed(String value) {
    print("Button Pressed: $value");

    setState(() {
      if (value == "C") {
        print("Calculator Cleared");
        _output = "0";
        _currentInput = "";
        _operator = "";
        _num1 = 0;
      }

      else if (["+", "-", "×", "÷"].contains(value)) {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operator = value;
          print("First Number: $_num1");
          print("Operator Selected: $_operator");
          _currentInput = "";
        }
      }

      else if (value == "=") {
        if (_currentInput.isNotEmpty && _operator.isNotEmpty) {
          double num2 = double.parse(_currentInput);
          print("Second Number: $num2");

          double result = 0;

          switch (_operator) {
            case "+":
              result = _num1 + num2;
              break;
            case "-":
              result = _num1 - num2;
              break;
            case "×":
              result = _num1 * num2;
              break;
            case "÷":
              if (num2 == 0) {
                print("Error: Division by zero");
                _output = "Error";
                return;
              }
              result = _num1 / num2;
              break;
          }

          print("Result: $_num1 $_operator $num2 = $result");
          print("--------------------------------");

          _output = result.toString();
          _currentInput = _output;
          _operator = "";
        }
      }

      else {
        _currentInput += value;
        _output = _currentInput;
        print("Current Input: $_currentInput");
      }
    });
  }

  Widget _buildButton(String text,
      {Color bgColor = Colors.black87, Color textColor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 22, color: textColor),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Row(
      children: buttons.map((btn) {
        if (btn == "C") {
          return _buildButton(btn, bgColor: Colors.red);
        } else if (["+", "-", "×", "÷", "="].contains(btn)) {
          return _buildButton(btn, bgColor: Colors.orange);
        } else {
          return _buildButton(btn);
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Flutter Calculator",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildRow(["7", "8", "9", "÷"]),
              _buildRow(["4", "5", "6", "×"]),
              _buildRow(["1", "2", "3", "-"]),
              _buildRow(["C", "0", "=", "+"]),
            ],
          ),
        ],
      ),
    );
  }
}
