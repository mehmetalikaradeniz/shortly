import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/features/url_shortener/domain/entities/short_url.dart';
import 'package:shortly/features/url_shortener/presentation/bloc/locale/locale_short_url_bloc.dart';
import 'package:shortly/features/url_shortener/presentation/widgets/quadratic_shape.dart';
import 'package:shortly/features/url_shortener/presentation/widgets/short_url_form.dart';
import 'package:shortly/features/url_shortener/presentation/widgets/url_list.dart';
import 'package:shortly/features/url_shortener/presentation/widgets/url_list_loading.dart';
import 'greeting.dart';

class PageContent extends StatefulWidget {
  const PageContent({Key? key}) : super(key: key);

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  ShortUrlList? shortUrlList;
  final ScrollController _controller = ScrollController();

  Widget _pageState(context, state){

    Widget contentBody = const UrlListLoading();

    if(state is WarmingUp || state is UrlListRequesting){
      contentBody = const UrlListLoading();
    }
    else if(state is UrlListEmpty){
      contentBody = const Greeting();
    }
    else if(state is UrlListLoaded){
      shortUrlList = state.shortUrlList!;
      contentBody = UrlList(
        urlList: shortUrlList!,
        scrollController: _controller,
      );

    }
    else if(state is AddedNewUrl){
      shortUrlList = state.shortUrlList!;
      contentBody = UrlList(
        urlList: shortUrlList!,
        scrollController: _controller,
      );
      Future.delayed(const Duration(milliseconds: 300), () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
    else if(state is UrlRemoved){
      contentBody = UrlList(
        urlList: shortUrlList!,
        scrollController: _controller,
      );
    }
    else{
      contentBody = const Greeting();
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
                padding: const EdgeInsets.only(top: 30),
                color: const Color(0xffF0F1F7),
                child: contentBody,
            ),
            flex: 1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              fit: StackFit.expand,
              children: [
                 Positioned(
                    width: MediaQuery.of(context).size.width * 0.77,
                    height:  MediaQuery.of(context).size.width * 0.77 * 0.45,
                    top: 0,
                    right: 0,
                    child: QuadraticShape(
                      width: MediaQuery.of(context).size.width * 0.77,
                    )
                ),
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ShortUrlForm()
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LocaleShortUrlBloc(Idle())
          ..add(GetWarm());
      },
      child: BlocBuilder<LocaleShortUrlBloc, ShortUrlState>(
        builder: (context, state) => _pageState(context, state),
      ),
    );
  }
}
