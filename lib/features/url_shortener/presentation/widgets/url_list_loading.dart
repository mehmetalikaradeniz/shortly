import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UrlListLoading extends StatelessWidget {
  const UrlListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/logo.svg",
              width: 120,
            ),
            const SizedBox(height: 100,),
            Text(
                "Warming Up",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor
                ),
            ),
            const SizedBox(height: 30,),
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2ACFCE)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
