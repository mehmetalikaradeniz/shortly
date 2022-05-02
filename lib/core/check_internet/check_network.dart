import 'dart:io';

abstract class CheckNetwork {
  Future<bool> hasNetwork();
}

class CheckNetworkImpl extends CheckNetwork{
  @override
  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}