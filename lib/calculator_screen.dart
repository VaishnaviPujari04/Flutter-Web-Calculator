import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'calculator_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == '⌫') {
        input = input.isNotEmpty ? input.substring(0, input.length - 1) : '';
      } else if (value == '=') {
        calculateResult();
      } else {
        input += value;
      }
    });
  }

  void calculateResult() {
    try {
      Parser parser = Parser();
      Expression expression = parser.parse(input.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      setState(() {
        result = eval.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      '7', '8', '9', 'C',
      '4', '5', '6', '⌫',
      '1', '2', '3', '+',
      '0', '.', '=', '-',
      '×', '÷', '%'
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 4 : 6;  // 4 columns on mobile, 6 on wider screens

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      input,
                      style: TextStyle(
                        fontSize: screenWidth < 500 ? 26 : 36,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      result,
                      style: TextStyle(
                        fontSize: screenWidth < 500 ? 32 : 44,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return CalculatorButton(
                  text: buttons[index],
                  onPressed: () => buttonPressed(buttons[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
