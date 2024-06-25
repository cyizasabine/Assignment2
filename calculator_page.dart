import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '';
      } else if (buttonText == '=') {
        try {
          _result = _calculate(_expression);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_result.isNotEmpty && !_isOperator(buttonText)) {
          _expression = '';
          _result = '';
        }
        _expression += buttonText;
      }
    });
  }

  bool _isOperator(String buttonText) {
    return buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '×' ||
        buttonText == '÷' ||
        buttonText == '%' ||
        buttonText == '(' ||
        buttonText == ')';
  }

  String _calculate(String expression) {
    try {
      String modifiedExpression = _handleModulus(expression);
      modifiedExpression =
          modifiedExpression.replaceAll('×', '*').replaceAll('÷', '/');
      final parser = Parser();
      final expressionAst = parser.parse(modifiedExpression);
      final result =
      expressionAst.evaluate(EvaluationType.REAL, ContextModel());
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  String _handleModulus(String expression) {
    RegExp regex = RegExp(r'(\d+\.?\d*)\s*%\s*(\d+\.?\d*)');
    while (regex.hasMatch(expression)) {
      expression = expression.replaceFirstMapped(regex, (match) {
        double leftOperand = double.parse(match.group(1)!);
        double rightOperand = double.parse(match.group(2)!);
        double result = leftOperand % rightOperand;
        return result.toString();
      });
    }
    return expression;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(20),
                child: Text(
                  _expression,
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(20),
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  buildButtonRow(['C', '(', ')', '÷']),
                  buildButtonRow(['7', '8', '9', '×']),
                  buildButtonRow(['4', '5', '6', '-']),
                  buildButtonRow(['1', '2', '3', '+']),
                  buildButtonRow(['0', '.', '=', '%']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttonTexts) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttonTexts
            .map((text) =>
            CalculatorButton(text, _onButtonPressed))
            .toList(),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String _text;
  final Function _onPressed;

  CalculatorButton(this._text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () => _onPressed(_text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          minimumSize: Size(80, 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Text(
          _text,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
