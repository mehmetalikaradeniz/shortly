import 'package:flutter/material.dart';
import 'package:shortly/features/url_shortener/presentation/widgets/page_content.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 20),
          child: Container(height: 20, color: const Color(0xffF0F1F7),)),
      body: SafeArea(
        child: GestureDetector(
          child: const PageContent(),
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            currentFocus.unfocus();
          },
        ),
      ),
    );
  }
}
