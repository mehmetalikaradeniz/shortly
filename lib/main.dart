import 'package:flutter/material.dart';
import 'package:shortly/features/url_shortener/presentation/pages/home.dart';

void main() {
  runApp(const Shortly());
}

Map<int, Color> primaryColorValues = {
  50: const Color.fromRGBO(258, 43, 33, .1),
  100: const Color.fromRGBO(258, 43, 33, .2),
  200: const Color.fromRGBO(258, 43, 33, .3),
  300: const Color.fromRGBO(258, 43, 33, .4),
  400: const Color.fromRGBO(258, 43, 33, .5),
  500: const Color.fromRGBO(258, 43, 33, .6),
  700: const Color.fromRGBO(258, 43, 33, .8),
  600: const Color.fromRGBO(258, 43, 33, .7),
  800: const Color.fromRGBO(258, 43, 33, .9),
  900: const Color.fromRGBO(258, 43, 33, 1),
};

class Shortly extends StatelessWidget {
  const Shortly({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(0xff3B3054, primaryColorValues),
          scaffoldBackgroundColor: MaterialColor(0xff3B3054, primaryColorValues),
          buttonTheme: const ButtonThemeData(
              buttonColor: Color(0xff2ACFCE),
              textTheme: ButtonTextTheme.primary
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xff2ACFCE)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
                  textStyle: MaterialStateProperty.all(const TextStyle(
                      color: Colors.white
                  ))
              )
          )
      ),
      home: const Home(),
    );
  }
}
