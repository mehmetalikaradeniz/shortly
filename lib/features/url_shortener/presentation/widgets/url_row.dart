import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/presentation/bloc/locale/locale_short_url_bloc.dart';

class UrlRow extends StatefulWidget {
  final ShortUrl shortUrl;
  const UrlRow({Key? key, required this.shortUrl}) : super(key: key);

  @override
  State<UrlRow> createState() => _UrlRowState();
}

class _UrlRowState extends State<UrlRow> {
  late ShortUrl shortUrl;
  bool animationActive = false;
  @override
  void initState() {
    shortUrl = widget.shortUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.5),
      child: ClipRRect(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                     Expanded(
                      child: Text(
                          shortUrl.result!.originalLink,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      flex: 1,
                    ),
                    SizedBox(
                      width: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<LocaleShortUrlBloc>(context).add(RemoveUrlFromCache(url: shortUrl));
                        },
                        child: SvgPicture.asset(
                          "assets/del.svg",
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: const BorderSide(width: 0, color: Colors.transparent),
                            )),
                            shadowColor: MaterialStateProperty.all(Colors.transparent)
                        ),
                      ),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xffF0F1F7)))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                        shortUrl.result!.shortLink,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff2ACFCE)
                        )
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: animationActive ? (){} : (){
                            setState(() {
                              animationActive = true;
                            });
                            Clipboard.setData(ClipboardData(text: shortUrl.result!.shareLink));
                            Future.delayed(const Duration(milliseconds: 1200), () => setState(() {
                              animationActive = false;
                            }));
                          },
                          style: ButtonStyle(
                            backgroundColor: animationActive ? MaterialStateProperty.all(Theme.of(context).primaryColor) : Theme.of(context).elevatedButtonTheme.style!.backgroundColor
                          ),
                          child: Text(
                            animationActive ? "COPIED!" : "COPY",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
