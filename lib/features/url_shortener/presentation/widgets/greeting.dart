import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class Greeting extends StatelessWidget {
  const Greeting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 35,),
        SvgPicture.asset(
          "assets/logo.svg",
          width: 120,
        ),
        SvgPicture.asset(
          "assets/illustration.svg",
          width: MediaQuery.of(context).size.width * .90,
        ),
        const Text(
          "Lets Get Started!",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900
          ),
        ),
        const SizedBox(height: 10,),
        const Text(
            "Paste your first link into\nto field to shorten it",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
            )
        ),
        SizedBox(height: 0, width: MediaQuery.of(context).size.width,)
      ],
    );
  }
}
