import 'package:flutter/material.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/presentation/widgets/url_row.dart';

class UrlList extends StatelessWidget {
  final ShortUrlList urlList;
  final ScrollController scrollController;
  const UrlList({Key? key, required this.urlList, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      color: const Color(0xffF0F1F7),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
                "Your Link History",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                )
            ),
            const SizedBox(height: 7.5,),
            ...urlList.data.map(
                    (e) => UrlRow(shortUrl: e,)
            )
          ],
        ),
      ),
    );
  }
}
