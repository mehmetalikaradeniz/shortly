import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/core/failure/failure.dart';
import 'package:shortly/features/url_shortener/presentation/bloc/locale/locale_short_url_bloc.dart';
import 'package:shortly/features/url_shortener/presentation/bloc/remote/remote_short_url_bloc.dart';

class ShortUrlForm extends StatefulWidget {
  const ShortUrlForm({Key? key}) : super(key: key);

  @override
  State<ShortUrlForm> createState() => _ShortUrlFormState();
}

class _ShortUrlFormState extends State<ShortUrlForm> {
  final _formKey = GlobalKey<FormState>();
  final inputController = TextEditingController();
  bool textFormFieldFailure = false;
  bool buttonRequesting = false;

  @override
  Widget build(BuildContext context) {
    Widget _widgetState(context, state){
      if(state is RemoteShortUrlBlocIdle){
        buttonRequesting = false;
      }
      else if(state is RemoteShortUrlBlocShortUrlRequesting){
        buttonRequesting = true;
      }
      else if(state is RemoteShortUrlBlocShortUrlRequested){
        BlocProvider.of<RemoteShortUrlBloc>(context).add(ForceRemoteBlocToBeIdle());
        BlocProvider.of<LocaleShortUrlBloc>(context).add(CacheUrl(url: state.shortUrl));
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Succeed!",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),
          ),
        );
      //  inputController.text = "";
        buttonRequesting = false;
        Future.delayed(const Duration(milliseconds: 600), () => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }
      else if(state is RemoteShortUrlBlocShortUrlRequestFailure){
        RequestFailure failure = state.failure as RequestFailure;
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              failure.message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),
          ),
        );
        Future.delayed(const Duration(milliseconds: 600), () => ScaffoldMessenger.of(context).showSnackBar(snackBar));
        BlocProvider.of<RemoteShortUrlBloc>(context).add(ForceRemoteBlocToBeIdle());
        buttonRequesting = false;
      }

      return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 275,
              child: TextFormField(
                controller: inputController,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      textFormFieldFailure = true;
                    });
                    return '';
                  }
                  setState(() {
                    textFormFieldFailure = false;
                  });
                  return null;
                },

                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    hintText: textFormFieldFailure ? "Please add a link here" : "Shorten a link here ...",
                    contentPadding: EdgeInsets.zero,
                    hintStyle: TextStyle(
                      color: textFormFieldFailure ? Colors.red : Color(0xffC1C1C1),
                      fontWeight: FontWeight.w600,
                    ),
                    errorStyle: const TextStyle(
                        fontSize: 0,
                        height: 0
                    )
                ),
              ),

            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                child: ElevatedButton(
                    onPressed: buttonRequesting ? (){} : (){
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<RemoteShortUrlBloc>(context).add(RequestNewShortUrlFromRemote(inputController.text));
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        currentFocus.unfocus();
                      }
                    },
                    child: buttonRequesting ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 1.5,
                      ),
                    ) : const Text(
                      "SHORTEN IT!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                ),
                height: 50,
                width: 275
            )

          ],
        ),
      );
    }
    return BlocProvider(
      create: (context) {
        return RemoteShortUrlBloc(RemoteShortUrlBlocIdle())
          ..add(RemoteShortUrlBlocShortUrlGetWarm());
      },
      child: BlocBuilder<RemoteShortUrlBloc, RemoteShortUrlBlocShortUrlState>(
        builder: (context, state) => _widgetState(context, state),
      ),
    );
  }
}
