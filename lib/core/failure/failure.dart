import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  @override
  List<Object> get props => [];
}

class ConnectionFailure extends Failure{}
class RequestFailure extends Failure{
  String message;
  RequestFailure({required this.message});

  List<Object> get props => [message];
}