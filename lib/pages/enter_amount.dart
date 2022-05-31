import 'package:finance2/models/category.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/helpers.dart';
import '../widgets/calculator_button.dart';
import './categories_page.dart';

class EnterAmountPage extends StatefulWidget {
  static const routeName = '/enter-amount';
  const EnterAmountPage({Key? key}) : super(key: key);

  @override
  State<EnterAmountPage> createState() => _EnterAmountPageState();
}

class _EnterAmountPageState extends State<EnterAmountPage> {
  var _userInput = '';
  //change value to true if last pressed char == operand
  var _isOperandHave = false;
  //able and disable next button
  var _isNextPressed = false;
  //status of widget, set to true once widget built first time
  bool _init = false;
  //argumets received from router {'account': MapEntry<dynamic, Account>,'categoryType': CategoryType,}
  Map<String, dynamic>? _args;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init == false) {
      _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    }
    _init = true;
    super.didChangeDependencies();
  }

  //String? textToDisplay = '';
  final List<String> _buttons = [
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '<-',
    '.',
    '0',
    '+',
  ];

  // function to calculate the input operation
  void _equalPressed() {
    if (_userInput.isNotEmpty) {
      String finaluserinput = _userInput.replaceAll('x', '*');
      try {
        Parser p = Parser();
        Expression exp = p.parse(finaluserinput);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        setState(() {
          _userInput = eval.toStringAsFixed(2);
          _isNextPressed = true;
        });
      } catch (e) {
        // setState(() {
        //   _userInput = 'Error';
        // });
      }
    }
  }

  //handle once calculator button pressed
  void _buttonPressed(String buttonValue) {
    setState(() {
      if (_userInput.isEmpty &&
          (buttonValue == '/' ||
              buttonValue == 'x' ||
              buttonValue == '-' ||
              buttonValue == '+' ||
              buttonValue == '.')) {
        _userInput += '';
      } else {
        if ((buttonValue == '/' ||
                buttonValue == 'x' ||
                buttonValue == '-' ||
                buttonValue == '+' ||
                buttonValue == '.') &&
            _isOperandHave == false) {
          _userInput += buttonValue;
          _isOperandHave = true;
          _isNextPressed = false;
          //_equalPressed();
        } else {
          if (buttonValue != '/' &&
              buttonValue != 'x' &&
              buttonValue != '-' &&
              buttonValue != '+' &&
              buttonValue != '.') {
            _userInput += buttonValue;
            _isOperandHave = false;
            _isNextPressed = true;
          }
        }
      }
    });
  }

  //once next button pressed
  void _nextPressed() {
    //Calculate math expression final value
    _equalPressed();
    Navigator.pushNamed(context, CategoriesPage.routeName, arguments: {
      'amount': double.parse(_userInput),
      'categoryType': _args!['categoryType'],
      'account': _args!['account'],
    });
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle =
        '${AppLocalizations.of(context)!.enter} ${Category.getCategoryString(
      _args!['categoryType'],
      context,
    )}';
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 40,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Equal button
            TextButton(
              onPressed: _equalPressed,
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: const Text(
                  '=',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            //Next button
            TextButton(
              onPressed: _isNextPressed ? _nextPressed : null,
              child: Container(
                alignment: Alignment.center,
                width: 100,
                child: Text(
                  '${AppLocalizations.of(context)!.next} >',
                  style: TextStyle(
                    fontSize: 22,
                    color: _isNextPressed ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
            child: Container(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Helpers.retrieveIconFromCodeData(
                            _args!['account'].value.icon,
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 150,
                          child: Text(
                            '${_args!['account'].value.title} ${AppLocalizations.of(context)!.account}',
                            overflow: TextOverflow.clip,
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Text(
                        '${AppLocalizations.of(context)!.balance}: ${_args!['account'].value.balance}',
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    _userInput,
                    style: TextStyle(
                      fontSize: 35,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            //height: 460,
            child: GridView.builder(
              itemCount: _buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (BuildContext context, int index) {
                // Remove character from userInput
                if (index == 12) {
                  return CalculatorButton(
                    onPressed: () {
                      setState(() {
                        if (_userInput.isNotEmpty) {
                          //remove last character from userInput
                          _userInput =
                              _userInput.substring(0, _userInput.length - 1);
                          if (_userInput.isEmpty) {
                            _isNextPressed = false;
                          }
                        }
                      });
                    },
                    onLongPress: () {
                      //clear userInput
                      setState(() {
                        _userInput = '';
                        _isOperandHave = false;
                        _isNextPressed = false;
                      });
                    },
                    buttonText: _buttons[index],
                  );
                }
                //Other buttons
                return CalculatorButton(
                  onPressed: () => _buttonPressed(_buttons[index]),
                  buttonText: _buttons[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
