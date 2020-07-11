import 'package:flutter/material.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';

// import 'package:math_expressions/math_expressions.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

Parser buildParser() {
  final builder = ExpressionBuilder();
  builder.group()
    ..primitive((pattern('+-').optional() &
            digit().plus() &
            (char('.') & digit().plus()).optional() &
            (pattern('eE') & pattern('+-').optional() & digit().plus())
                .optional())
        .flatten('number expected')
        .trim()
        .map(num.tryParse))
    ..wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  builder.group()..prefix(char('-').trim(), (op, a) => -a);
  // builder.group()..right(char('^').trim(), (a, op, b) => pow(a, b));
  builder.group()
    ..left(char('*').trim(), (a, op, b) => a * b)
    ..left(char('/').trim(), (a, op, b) => a / b);
  builder.group()
    ..left(char('+').trim(), (a, op, b) => a + b)
    ..left(char('-').trim(), (a, op, b) => a - b);
  return builder.build().end();
}

double calcString(String text) {
  final parser = buildParser();
  final input = text;
  final result = parser.parse(input);
  if (result.isSuccess)
    return result.value.toDouble();
  else
    return double.parse(text);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result = '0.0';
  String _operation = '';
  // final builder = ExpressionBuilder();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Material(
      child: Column(
        children: <Widget>[
          Container(
              // margin: const EdgeInsets.all(10.0),
              color: hexToColor('#9FBEC3'),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '$_operation',
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        color: hexToColor('#0E5C68'),
                      ),
                    ),
                    Text(
                      '$_result',
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: 40,
                        color: hexToColor('#0E5C68'),
                      ),
                    ),
                  ])),
          Container(
              padding: const EdgeInsets.all(10.0),

              // color: hexToColor('#F9FBFB'),
              decoration: BoxDecoration(
                color: hexToColor('#F9FBFB'),
                borderRadius: BorderRadius.circular(50),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.50,
              child: GridButton(
                borderColor: hexToColor('#F9FBFB'),
                onPressed: (dynamic value) {
                  setState(() {
                    switch (value) {
                      case "C":
                        _result = '0.0';
                        _operation = '';
                        break;
                      case "+/-":
                        _result = '';
                        break;
                      case "=":
                        if (_result !=
                            calcString(_result.replaceAll("X", "*"))
                                .toString()) {
                          _operation = _result;
                        }
                        _result =
                            calcString(_result.replaceAll("X", "*")).toString();
                        break;
                      case "*":
                        _result = _result + "X";
                        break;
                      default:
                        if (_result == '0.0' &&
                            value != "-" &&
                            value != "+" &&
                            value != "/")
                          _result = value;
                        else
                          _result = _result + value;
                    }
                  });
                },
                borderWidth: 10.0,
                textStyle: TextStyle(fontSize: 30),
                items: [
                  [
                    GridButtonItem(
                        borderRadius: 10,
                        title: "C",
                        value: "C",
                        color: hexToColor('#9FBEC3'),
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 30)),
                    GridButtonItem(
                        borderRadius: 10,
                        title: "+/-",
                        value: "+-",
                        color: hexToColor('#9FBEC3'),
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 30)),
                    GridButtonItem(
                        borderRadius: 10,
                        title: "%",
                        value: "%",
                        color: hexToColor('#9FBEC3'),
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 30)),
                    GridButtonItem(
                        borderRadius: 10,
                        title: "/",
                        value: "/",
                        color: hexToColor('#9FBEC3'),
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                  [
                    GridButtonItem(title: "7", value: "7"),
                    GridButtonItem(title: "8", value: "8"),
                    GridButtonItem(title: "9", value: "9"),
                    GridButtonItem(
                        borderRadius: 10,
                        title: "X",
                        value: "*",
                        color: hexToColor('#9FBEC3'),
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                  [
                    GridButtonItem(title: "4", value: "4"),
                    GridButtonItem(title: "5", value: "5"),
                    GridButtonItem(title: "6", value: "6"),
                    GridButtonItem(
                        borderRadius: 10,
                        title: "-",
                        value: "-",
                        color: hexToColor('#9FBEC3'),
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                  [
                    GridButtonItem(title: "1", value: "1"),
                    GridButtonItem(title: "2", value: "2"),
                    GridButtonItem(title: "3", value: "3"),
                    GridButtonItem(
                        borderRadius: 10,
                        title: "+",
                        value: "+",
                        color: hexToColor('#9FBEC3'),
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                  [
                    GridButtonItem(title: "0", value: "0"),
                    GridButtonItem(title: "", value: ""),
                    GridButtonItem(title: ".", value: "."),
                    GridButtonItem(
                        borderRadius: 10,
                        title: "=",
                        value: "=",
                        color: hexToColor('#0E5C68'),
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 30)),
                  ],
                ],
              )),
        ],
      ),
    );
  }
}
